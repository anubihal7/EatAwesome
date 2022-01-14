
//

import Foundation
import Alamofire

protocol ServiceDetailVCDelegate
{
    func getData (data : ServiceDetailResult?)
}

class ServiceDetail_ViewModel
{
    var delegate : ServiceDetailVCDelegate
    var view : ServiceDetailVC
    var serviceID = ""
    
    init(Delegate : ServiceDetailVCDelegate, view : ServiceDetailVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getServiceDetails(sId:String)
    {
        self.serviceID = sId
        WebService.Shared.GetApi(url: APIAddress.GET_SERVICE_DETAILS + "serviceId=\(sId)" , Target: self.view, showLoader: false, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(ServiceDetailCatModel.self, from: jsonData)
                self.delegate.getData(data: model.body)
            }
            catch
            {
               // self.delegate.nothingFound(type: "slots")
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        }, completionnilResponse: {(error) in
           // self.delegate.nothingFound(type: "slots")
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
    
    
    func deleteCartItem(cartID:String)
    {
        let obj : [String:Any] = ["cartId":cartID]
        
        WebService.Shared.deleteApi(url: APIAddress.DELETE_CART_ITEM, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.getServiceDetails(sId: self.serviceID)
                    var cartCount = AppDefaults.shared.cartCount
                    cartCount = cartCount-1
                    AppDefaults.shared.cartCount = cartCount
                    self.view.updateCartBadge(target: self.view)
                    self.view.showToastSwift(alrtType: .success, msg: msg, title: "")
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
    
    
    func clearCart(serviceid:String,price:Int)
    {
        let obj : [String:Any] = [:]
        
        WebService.Shared.deleteApi(url: APIAddress.CLEAR_CART_ITEMS, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    let controller = Navigation.GetInstance(of: .AddToCartVC)as! AddToCartVC
                    controller.compID = AppDefaults.shared.companyID
                    controller.serviceID = serviceid
                    controller.price = price
                    controller.delegateInstructions = self.view
                    AppDefaults.shared.CartCompanyID = ""
                    AppDefaults.shared.cartCount = 0
                    self.view.updateCartBadge(target: self.view)
                    self.view.present(controller, animated: true, completion: nil)
                }
                else
                {
                    self.view.showToastSwift(alrtType: .error, msg: msg, title: kOops)
                }
            }
            else
            {
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        })
        { (error) in
            self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        }
    }
    
    func Set_Favorite(serviceId:String)
    {
        let params = ["serviceId":serviceId]
        WebService.Shared.PostApi(url: APIAddress.ADD_TO_FAVORITES, parameter: params, Target: self.view, completionResponse:
        { (response) in
            
           if let responseData = response as? NSDictionary
           {
               let code = responseData.value(forKey: "code") as? Int ?? 0
               let msg = responseData.value(forKey: "message") as? String ?? "success"
               
               if (code == 200)
               {
                  self.view.btnFav.setImage(UIImage(named: "fav"), for: .normal)
                  self.getServiceDetails(sId: self.serviceID)
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
                    self.view.btnFav.setImage(UIImage(named: "unfav"), for: .normal)
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
}

