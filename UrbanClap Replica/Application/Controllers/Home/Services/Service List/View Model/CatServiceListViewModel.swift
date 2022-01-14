
//

import Foundation
import Alamofire

protocol ServiceListVCDelegate
{
    func getData (subcats : [ServiceListResult], tags:[subCategoryResult])
    func nothingFound()
    func noMainCategory()
    func handleCartAddOrRemove(status:String,sID:String)
     func reloadTable (indx : Int)
    func removeItem (indx : Int)
    func getData(services: [subcats])
}

class ServiceList_ViewModel
{
    var delegate : ServiceListVCDelegate
    var view : CatServiceListVC
    var cID = ""
    var scatID = ""
    
    init(Delegate : ServiceListVCDelegate, view : CatServiceListVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    
    
    func getCategoryList()
    {
        WebService.Shared.GetApi(url: APIAddress.GET_COMPANIES_CATEGORIES + "/?category=\(self.view.vendrCatID)&itemType=" , Target: self.view, showLoader: true, completionResponse: { response in
          //  Commands.println(object: response)
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(HomeCat_ResponseModel.self, from: jsonData)
                self.delegate.getData(services: (((model.body?.subcat))!))
            }
            catch
            {
                self.delegate.noMainCategory()
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        }, completionnilResponse: {(error) in
            self.delegate.noMainCategory()
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
    
    func getServiceList(catID:String)
    {
        self.scatID = catID
        WebService.Shared.GetApi(url: APIAddress.GET_HOME_SUBCAT_SERVICE + "/?category=\(catID)&itemType=\(self.view.vegOnly)" , Target: self.view, showLoader: false, completionResponse: { response in
          //  Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(ServiceListModel.self, from: jsonData)
                self.delegate.getData(subcats: model.body.services ?? [], tags: model.body.headers ?? [])
            }
            catch
            {
                self.delegate.nothingFound()
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        }, completionnilResponse: {(error) in
            self.delegate.nothingFound()
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
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
                   self.getServiceList(catID: self.scatID)
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
        
        WebService.Shared.deleteApi(url: APIAddress.REMOVE_FROM_FAVORITES, parameter: params, Target: self.view, showLoader: false, completionResponse:
        { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.getServiceList(catID: self.scatID)
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
    
    
    
//   func AddServiceToCart(serviceID:String,Price:String,Quantity:String,TotalPrice:String)
//    {
//        let status = self.getDeliveryTypeStatus()
//       // let userId = AppDefaults.shared.userID
//       let obj : [String:Any] = ["serviceId":serviceID,"orderPrice":Price,"quantity":Quantity,"orderTotalPrice":TotalPrice,"deliveryType":status,"companyId":self.compID]
//        
//        WebService.Shared.PostApi(url: APIAddress.ADD_TO_CART, parameter: obj , Target: self.view, completionResponse: { response in
//            Commands.println(object: response)
//            
//            if let responseData = response as? NSDictionary
//            {
//                let code = responseData.value(forKey: "code") as? Int ?? 0
//                let msg = responseData.value(forKey: "message") as? String ?? "success"
//                
//                if (code == 200)
//                {
//                    self.view.AlertMessageWithOkAction(titleStr: kAppName, messageStr: msg, Target: self.view)
//                    {
//                        self.view.updateCartBadge(target:self.view)
//                        self.delegate.handleCartAddOrRemove(status: status, sID: servieID)
//                    }
//                }
//                else
//                {
//                    self.view.showToastSwift(alrtType: .error, msg: msg, title: "")
//                }
//            }
//            else
//            {
//                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
//            }
//        }, completionnilResponse: {(error) in
//            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
//        })
//        
//    }
    
    func deleteCartItem(cartID:String, Index: Int)
    {
        let obj : [String:Any] = ["cartId":cartID]
        //self.scatID = cartID
        WebService.Shared.deleteApi(url: APIAddress.DELETE_CART_ITEM, parameter: obj, Target: self.view, showLoader: false, completionResponse: { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.getServiceList(catID: self.scatID)
                    var cartCount = AppDefaults.shared.cartCount
                    if cartCount != 0
                    {
                        cartCount = cartCount-1
                    }
                    AppDefaults.shared.cartCount = cartCount
                    self.view.checkCartBadge()
                    self.view.showToastSwift(alrtType: .success, msg: msg, title: "")
                    self.delegate.removeItem(indx: Index)
                    
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
    
    func clearCart(serviceid:String,price:Int, Index: Int)
    {
        let obj : [String:Any] = [:]
        
        WebService.Shared.deleteApi(url: APIAddress.CLEAR_CART_ITEMS, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    
                    AppDefaults.shared.CartCompanyID = ""
                    AppDefaults.shared.cartCount = 0
                    self.delegate.reloadTable(indx: Index)
                    self.view.checkCartBadge()
                    
                    self.view.showToastSwift(alrtType: .success, msg: "Cart cleared successfully. Now you can add items in your cart", title: kOops)
                    
//                    let controller = Navigation.GetInstance(of: .AddToCartVC)as! AddToCartVC
//                    controller.compID = AppDefaults.shared.companyID
//                    controller.serviceID = serviceid
//                    controller.price = price
//                    controller.delegateInstructions = self.view
//
//                    self.view.updateCartBadge(target: self.view)
//                    self.view.present(controller, animated: true, completion: nil)
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
}


