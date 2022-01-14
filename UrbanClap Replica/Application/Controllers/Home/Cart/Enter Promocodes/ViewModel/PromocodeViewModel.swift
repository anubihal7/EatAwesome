

import Foundation
import Alamofire

protocol PromocodeVCDelegate
{
    func getData (offrs : [PromocodeResult])
    func nothingFound()
    func getCouponResults()
}

class Promocode_ViewModel
{
    var delegate : PromocodeVCDelegate
    var view : PromocodesVC
    
    init(Delegate : PromocodeVCDelegate, view : PromocodesVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getOffersList()
    {
        WebService.Shared.GetApi(url: APIAddress.GET_PROMOCODES, Target: self.view, showLoader: false, completionResponse:
            { (response) in
                
                do
                {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(PromocodeModel.self, from: jsonData)
                    self.delegate.getData(offrs: model.body)
                }
                catch
                {
                    self.delegate.nothingFound()
                    self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
                }
                
        })
        { (err) in
            self.delegate.nothingFound()
            self.view.showToastSwift(alrtType: .error, msg: err, title: kOops)
        }
        
    }
    
    
    func applyPromoCode(code:String)
    {
        let obj : [String:Any] = ["promoCode":code]
        
        WebService.Shared.PostApi(url: APIAddress.ADD_PROMOCODE, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    if let dicnry = responseData.value(forKey: "body")as? [String:Any]
                    {
                        let totlAmnt = dicnry["totalAmount"] as? Float
                        let payAmnt = "\(dicnry["payableAmount"]!)"
                        let cpDiscnt = dicnry["coupanDiscount"] as? String
                        let code = dicnry["coupanCode"] as? String
                        
                        self.view.delegateCart?.getOffPercentage(payableAmount:"\(payAmnt)",cpDiscount:"\(cpDiscnt ?? "")",totalAmount:"\(totlAmnt ?? 0.0)",cpnCode:code ?? "")
                        self.view.delegateCart?.offerAppliedSuccffull()
                        self.view.showToastSwift(alrtType: .success, msg: msg, title: kSuccess)
                        self.view.dismiss(animated: true, completion: nil)
                    }
                    else
                    {
                        self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
                    }
                }
                else
                {
                    self.view.showToastSwift(alrtType: .error, msg: msg, title: "")
                }
            }
            else
            {
                self.view.showAlertMessage(titleStr: kAppName, messageStr: kResponseNotCorrect)
            }
        }, completionnilResponse: {(error) in
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
    }
    
    
}


