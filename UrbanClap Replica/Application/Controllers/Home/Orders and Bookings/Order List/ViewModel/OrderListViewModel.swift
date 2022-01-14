//

//

import Foundation
import Alamofire

protocol OrderListVCDelegate
{
    func getData (orders : [OrderData])
    func nothingFound()
}

class OrderList_ViewModel
{
    var delegate : OrderListVCDelegate
   // var view : OrderListVC
    var view : NewOrderListVC
    var progressStatus = ""
    var pageCount = ""
    var Limits = ""
    
    init(Delegate : OrderListVCDelegate, view : NewOrderListVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getOrderList(status:String,page:String,limit:String)
    {
        self.progressStatus = status
        self.pageCount = page
        self.Limits = limit
        
        let urlsource = APIAddress.GET_ORDER_LIST + "progressStatus=\(status)&page=\(page)&limit=\(limit)"
        WebService.Shared.GetApi(url: urlsource, Target: self.view, showLoader: true, completionResponse:
            { (response) in
                
                do
                {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(OrderListModel.self, from: jsonData)
                    self.delegate.getData(orders: model.body!)
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
    
    
    func cancelOrder(orderId:String,reason:String)
    {
        let obj : [String:Any] = ["orderId":orderId,"cancellationReason":reason]
        WebService.Shared.PostApi(url: APIAddress.CANCEL_ORDER, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.view.AlertMessageWithOkAction(titleStr: kAppName, messageStr: msg, Target: self.view)
                    {
                        self.getOrderList(status:self.progressStatus,page:self.pageCount,limit:self.Limits)
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
                    self.view.AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Order completed successfully.", Target: self.view)
                    {
                        self.getOrderList(status:self.progressStatus,page:self.pageCount,limit:self.Limits)
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
}


