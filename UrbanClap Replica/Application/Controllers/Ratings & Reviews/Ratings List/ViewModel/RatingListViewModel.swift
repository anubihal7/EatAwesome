
//

import Foundation
import Alamofire

protocol RatingListVCDelegate
{
    func getData (model : [rateData])
    func nothingFound()
}

class RatingList_ViewModel
{
    var delegate : RatingListVCDelegate
    var view : UIViewController
    var viewMain : RatingListVC
    
    init(Delegate : RatingListVCDelegate, viewMain : RatingListVC,view :UIViewController)
    {
        delegate = Delegate
        self.view = view
        self.viewMain = viewMain
    }
    
    func getRatingList(Page:Int,Limit:Int,servcID:String)
    {
        let url = APIAddress.GET_RATINGS + "?serviceId=\(servcID)&page=\(Page)&limit=\(Limit)"
        WebService.Shared.GetApi(url: url , Target: self.view, showLoader: false, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(RatingList_ResponseModel.self, from: jsonData)
                self.delegate.getData(model: model.body.data)
            }
            catch
            {
                self.delegate.nothingFound()
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        }, completionnilResponse: {(error) in
            self.delegate.nothingFound()
           // self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
        })
        
    }
    
}

