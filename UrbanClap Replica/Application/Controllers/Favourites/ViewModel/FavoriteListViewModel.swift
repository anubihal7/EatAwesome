
//

import Foundation
import Alamofire

protocol FavoriteListVCDelegate
{
    func getData (subcats : [FavoriteListResult])
    func nothingFound()
}

class FavoriteList_ViewModel
{
    var delegate : FavoriteListVCDelegate
    var view : FavoriteListVC
    var cID = ""
    var scatID = ""
    
    init(Delegate : FavoriteListVCDelegate, view : FavoriteListVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getFavList()
    {
        let urls = APIAddress.GET_FAVORITES
        WebService.Shared.GetApi(url: urls, Target: self.view, showLoader: false, completionResponse:
            { (response) in
                
                do
                {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(FavoriteListModel.self, from: jsonData)
                    self.delegate.getData(subcats: model.body)
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
    
    
    func Set_UNFavorite(serviceId:String)
    {
        let params = ["favId":serviceId]
        
        WebService.Shared.deleteApi(url: APIAddress.REMOVE_FROM_FAVORITES, parameter: params, Target: self.view, showLoader: true, completionResponse:
        { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.getFavList()
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
        { (err) in
            self.view.showToastSwift(alrtType: .error, msg: err, title: kFailed)
        }
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
                    self.getFavList()
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



