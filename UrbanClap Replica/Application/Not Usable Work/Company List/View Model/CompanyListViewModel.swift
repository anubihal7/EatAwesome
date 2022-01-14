//
/
//

import Foundation
import Alamofire

protocol CompanyListVCDelegate
{
    func getData (list : [CompanyBody])
    func nothingFound()
}

class CompanyList_ViewModel
{
    var delegate : CompanyListVCDelegate
    var view : CompanyListVC
    var catgryID :String?
    
    init(Delegate : CompanyListVCDelegate, view : CompanyListVC)
    {
        delegate = Delegate
        self.view = view
        
    }
    
    func getCompanyList(catId:String)
    {
        self.catgryID = catId
        WebService.Shared.GetApi(url: APIAddress.GET_COMPANIES + "?categoryId=\(catId)&latitude=\(AppDefaults.shared.app_LATITUDE)&longitude=\(AppDefaults.shared.app_LONGITUDE)" , Target: self.view, showLoader: true, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(CompanyListModel.self, from: jsonData)
                self.delegate.getData(list: model.body)
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
    
    func clearCart()
    {
        let obj : [String:Any] = [:]
        
        WebService.Shared.deleteApi(url: APIAddress.CLEAR_CART_ITEMS, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.getCompanyList(catId:self.catgryID ?? "")
                    self.view.showAlertMessage(titleStr: kAppName, messageStr: "Your cart is cleared successfully. Now you can choose your service vendor.")
                }
                else
                {
                    self.view.showToastSwift(alrtType: .error, msg: msg, title: "")
                }
            }
            else
            {
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        })
        { (error) in
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        }
    }
}




