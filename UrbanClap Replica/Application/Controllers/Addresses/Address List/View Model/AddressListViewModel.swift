//

//

import Foundation
import Alamofire

protocol AddressListVCDelegate
{
    func getData (model : [AddressList_Result])
    func nothingFound()
}

class AddressList_ViewModel
{
    var delegate : AddressListVCDelegate
    var view : UIViewController
    var viewMain : AddressListVC
    
    init(Delegate : AddressListVCDelegate, viewMain : AddressListVC,view :UIViewController)
    {
        delegate = Delegate
        self.view = view
        self.viewMain = viewMain
    }
    
    func getAddressList()
    {
        WebService.Shared.GetApi(url: APIAddress.GET_ADDRESS , Target: self.view, showLoader: false, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(AddressList_ResponseModel.self, from: jsonData)
                self.delegate.getData(model: model.body)
            }
            catch
            {
                self.delegate.nothingFound()
               // self.view.showAlertMessage(titleStr: kAppName, messageStr: kResponseNotCorrect)
            }
            
        }, completionnilResponse: {(error) in
            self.delegate.nothingFound()
           // self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
        })
        
    }
    
    
    func Make_Address_Default_Undefault(addressId:String,addressName:String,city:String,lat:String,long:String,defaultStatus:String)
    {
        let obj : [String:Any] = ["addressId":addressId,"latitude":lat,"longitude" :long,"addressName":addressName,"city":city,"default":defaultStatus]
        
        WebService.Shared.PutApi(url: APIAddress.UPDATE_ADDRESS, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.getAddressList()
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
    
    
    func DeleteAddress(addressID:String)
    {
        let obj : [String:Any] = ["addressId":addressID]
        WebService.Shared.deleteApi(url: APIAddress.DELETE_ADDRESS,parameter: obj, Target: self.view, showLoader: true, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.view.AlertMessageWithOkAction(titleStr: kAppName, messageStr: msg, Target: self.view)
                    {
                        self.viewMain.deleteCellROW()
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
