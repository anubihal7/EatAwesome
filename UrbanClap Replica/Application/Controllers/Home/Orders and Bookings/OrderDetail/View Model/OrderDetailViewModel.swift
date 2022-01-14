
//

import Foundation
import Alamofire

protocol OrderDetailVCDelegate
{
    func getData (data : OrderDetail)
    func nothingFound()
}

class OrderDetailViewModel
{
    var delegate : OrderDetailVCDelegate
    var view : OrderDetailVC
    
    init(Delegate : OrderDetailVCDelegate, view : OrderDetailVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getOrderDetail(id: String)
    {
        WebService.Shared.GetApi(url: APIAddress.GetOrderDetail + "\(id)" , Target: self.view, showLoader: true, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(OrderDetail.self, from: jsonData)
                self.delegate.getData(data: model)
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
    
    
    func completeOrder(orderId:String,stts:String)
    {
        let obj : [String:Any] = ["id":orderId,"status":stts]
        
        WebService.Shared.PostApi(url: APIAddress.ORDER_COMPLETE, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.view.AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Order has been completed successfully.", Target: self.view)
                    {
                        self.view.navigationController?.popViewController(animated: true)
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
        }, completionnilResponse: {(error) in
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
    }
    
    
    
    func OrderAgain(orderID:String)
    {
       
       let compnyId = self.view.OrderDetailData?.body.companyID ?? ""
                
        if (AppDefaults.shared.CartCompanyID.count == 0)
        {
            self.callAPI_ReOrder(odrID:orderID, cmpnyID: compnyId)
        }
        else
        {
            if(AppDefaults.shared.CartCompanyID == compnyId)
            {
                self.callAPI_ReOrder(odrID:orderID, cmpnyID: compnyId)
            }
            else
            {
                self.view.AlertMessageWithOkCancelAction(titleStr: "Items already in cart", messageStr: "Your cart contains items from a different restaurant. Would you like to reset your cart before adding this item?", Target: self.view)
                { (actn) in
                    if (actn == KYes)
                    {
                        self.clearCart(order: orderID, cpID: compnyId)
                    }
                }
            }
        }
    }
    
    
    func clearCart(order:String,cpID:String)
    {
        let obj : [String:Any] = [:]
        
        WebService.Shared.deleteApi(url: APIAddress.CLEAR_CART_ITEMS, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.callAPI_ReOrder(odrID:order, cmpnyID: cpID)
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
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        }
    }
    
    
    func callAPI_ReOrder(odrID:String,cmpnyID:String)
    {
        let obj : [String:Any] = ["orderId":odrID]
        
        WebService.Shared.PostApi(url: APIAddress.ORDER_AGAIN, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    //Cart Cmpy Id and Current cnpny id should be this order's compny id because this reorder will add on cart
                    AppDefaults.shared.CartCompanyID = cmpnyID
                    AppDefaults.shared.companyID = cmpnyID
                    
                    self.view.showToastSwift(alrtType: .success, msg: "Reorder placed successfully", title: "")
                    
                    let controller = Navigation.GetInstance(of: .CartListVC)as! CartListVC
                    self.view.push_To_Controller(from_controller: self.view, to_Controller: controller)
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
