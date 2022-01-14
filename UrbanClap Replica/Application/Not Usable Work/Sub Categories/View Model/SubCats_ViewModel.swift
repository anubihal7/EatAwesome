//

//

import Foundation
import Alamofire

protocol SubCatVCDelegate
{
    func getData (subcats : [Subcategory])
    func nothingFound()
}

class SubCateCat_ViewModel
{
    var delegate : SubCatVCDelegate
    var view : SubCatsVC
    
    init(Delegate : SubCatVCDelegate, view : SubCatsVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getSubCategoryList(catID:String)
    {
        let params = ["category_id":catID]
        WebService.Shared.PostApi(url: APIAddress.GET_HOME_SUBCATEGORIES, parameter: params, Target: self.view, completionResponse:
        { (response) in
            
           do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(SubCatsModel.self, from: jsonData)
                self.delegate.getData(subcats: model.body.subcategories)
            }
            catch
            {
                self.delegate.nothingFound()
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
        })
        { (err) in
            self.delegate.nothingFound()
            self.view.showToastSwift(alrtType: .error, msg: err, title: kFailed)
        }
    }
}

