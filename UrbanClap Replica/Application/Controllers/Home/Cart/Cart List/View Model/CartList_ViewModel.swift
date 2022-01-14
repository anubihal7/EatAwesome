
//

import Foundation
import Alamofire

protocol CartListVCDelegate
{
   // func getData (subcats : [CartListResult],addon : [AddOn],sum:Double,items:Int,lPoints:lPointsDec)
    func setupViewAfterGettingData()
    func nothingFound()
}

class CartList_ViewModel
{
    var delegate : CartListVCDelegate
    var view : CartListVC
    
    init(Delegate : CartListVCDelegate, view : CartListVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getCartList()
    {
        WebService.Shared.GetApi(url: APIAddress.GET_CART_LIST, Target: self.view, showLoader: true, completionResponse:
            { (response) in
                
//                do
//                {
//                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                    let model = try JSONDecoder().decode(CartListModel.self, from: jsonData)
//                    self.delegate.getData(subcats: model.body.data, addon: model.body.addOns!, sum: 0.0 ,items: model.body.totalQunatity ?? 0,lPoints:model.body.lPoints)
//                }
//                catch
//                {
//                    self.delegate.nothingFound()
//                    self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
//                }
                
                
                if let responseData = response as? NSDictionary
                {
                    let code = responseData.value(forKey: "code") as? Int ?? 0
                    let msg = responseData.value(forKey: "message") as? String ?? "success"
                    
                    
                    if (code == 200)
                    {
                        DispatchQueue.main.async
                        {
                            let dic = responseData.value(forKey: "body") as? NSDictionary
                            let dicArr = dic?.object(forKey: "data") as? NSArray
                            let ArrAddons = dic?.object(forKey: "addOns") as? NSArray
                            
                            self.view.apiDataLPoints = dic?.object(forKey: "lPoints") as? NSDictionary ?? NSDictionary()
                            self.view.sumTotal = Double("\(dic?.value(forKey: "sum") ?? 0)")!
                            self.view.sumItems = Int("\(dic?.value(forKey: "totalQunatity") ?? "0")")!
                            
                            
                            self.view.apiData = dicArr ?? NSArray()
                            self.view.apiDataAddones = ArrAddons ?? NSArray()
                            self.view.apiDataLPoints = dic?.object(forKey: "lPoints") as? NSDictionary ?? NSDictionary()
                            
                            self.delegate.setupViewAfterGettingData()
                        }
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
            self.delegate.nothingFound()
            if(err != "Details")
            {
                self.view.showToastSwift(alrtType: .error, msg: err, title: kFailed)
            }
            else
            {
                AppDefaults.shared.CartCompanyID = ""
                AppDefaults.shared.cartCount = 0
            }
        }
        
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
                    var cartCount = AppDefaults.shared.cartCount
                    cartCount = cartCount-1
                    if(cartCount < 1)
                    {
                        cartCount = 0
                    }
                    AppDefaults.shared.cartCount = cartCount
                    self.view.showToastSwift(alrtType: .success, msg: msg, title: "")
                    self.getCartList()
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
    
    
    func ClearCartList()
    {
        let obj : [String:Any] = [:]
        
        WebService.Shared.deleteApi(url: APIAddress.CLEAR_CART_ITEMS, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    AppDefaults.shared.serviceType = "" //setting service type refresh for new entries
                    AppDefaults.shared.CartCompanyID = ""
                    AppDefaults.shared.cartCount = 0
                    self.getCartList()
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
            self.delegate.nothingFound()
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        }
    }
    
    
    func AddServiceToCart(serviceID:String,Price:String,Quantity:String,TotalPrice:String,cmpId:String,isAddone:Bool)
    {
        let status = self.view.getDeliveryTypeStatus()
        let obj : [String:Any] = ["serviceId":serviceID,"orderPrice":Price,"quantity":Quantity,"orderTotalPrice":TotalPrice,"deliveryType":status,"companyId":cmpId,"vendorType":kvendorType]
        
        
        WebService.Shared.PostApi(url: APIAddress.ADD_TO_CART, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    var cartCount = AppDefaults.shared.cartCount
                    cartCount = cartCount+1
                    AppDefaults.shared.cartCount = cartCount
                    self.getCartList()
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
        }, completionnilResponse: {(error) in
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
}

