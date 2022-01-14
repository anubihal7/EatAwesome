//

//

import Foundation
import Alamofire

protocol OrderServicesVCDelegate
{
    func getData (model : NSArray,orderID:String,hasDriver:Bool)
    func nothingFound()
}

class OrderServices_ViewModel
{
    var delegate : OrderServicesVCDelegate
    var view : UIViewController
    var viewMain : OrderServiceListVC
    
    init(Delegate : OrderServicesVCDelegate, viewMain : OrderServiceListVC,view :UIViewController)
    {
        delegate = Delegate
        self.view = view
        self.viewMain = viewMain
    }
    
    func getServiceList(orderID:String)
    {
        let url = APIAddress.GET_ORDER_SERVICES + "/\(orderID)"
        WebService.Shared.GetApi(url: url , Target: self.view, showLoader: false, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    let dataArr = NSMutableArray()
                    guard let data = responseData.value(forKey: "body")as? NSDictionary else {return}
                    guard let services = data.value(forKey: "suborders")as? NSArray else {return}
                    guard let driver = data.value(forKey: "assignedEmployees")as? NSArray else {return}
                    let orderid = responseData.value(forKey: "id")as? String ?? ""
                    
                    if (services.count > 0)
                    {
                        for i in 0...services.count-1
                        {
                            let servcObj = services.object(at: i)as? NSDictionary
                            let objNew = servcObj?.value(forKey: "service") as? NSDictionary
                            dataArr.add(objNew ?? NSDictionary())
                        }
                    }
                    
                    if(driver.count > 0)
                    {
                        let driverDetails = driver.lastObject as? NSDictionary
                        let driverInfo = driverDetails?.value(forKey: "employee") as? NSDictionary
                        dataArr.add(driverInfo ?? NSDictionary())
                        self.delegate.getData(model: dataArr, orderID: orderid,hasDriver:true)
                    }
                    else
                    {
                        self.delegate.getData(model: dataArr, orderID: orderid,hasDriver:false)
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
                self.delegate.nothingFound()
            }
            
        }, completionnilResponse: {(error) in
            self.delegate.nothingFound()
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
    
    func callAPI_ADD_REVIEWS(orderId:String,ratingArray:[NSMutableDictionary],driverArray:[NSMutableDictionary])
    {
        //f153c50b-a318-4a6f-a0b1-3b0d620b4256
        //id = "5f7e9eda-2f5d-4554-918b-445808007659"
        
        var obj = [String:Any]()
        
        if(driverArray.count > 0)
        {
            obj = ["orderId":orderId,"ratingData":ratingArray,"empRatingData":driverArray]
        }
        else
        {
            obj  = ["orderId":orderId,"ratingData":ratingArray,"empRatingData":[]]
        }
        
        
        
        WebService.Shared.PostApi(url: APIAddress.ADD_NEW_RATINGS, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? ""
                
                if (code == 200)
                {
                    self.view.AlertMessageWithOkAction(titleStr: kAppName, messageStr: msg, Target: self.view)
                    {
                       // self.view.moveBACK(controller: self.view)
                        self.view.dismiss(animated: true, completion: nil)
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


