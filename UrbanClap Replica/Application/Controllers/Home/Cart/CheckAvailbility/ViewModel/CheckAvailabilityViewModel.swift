
//

import Foundation
import Alamofire

protocol CheckAvailabilityVCDelegate
{
    func nothingFound(type:String)
    func getSlotsResult(data : SlotsResult?)
}

class CheckAvailability_ViewModel
{
    var delegate : CheckAvailabilityVCDelegate
    var view : CheckAvailabilityVC
    
    init(Delegate : CheckAvailabilityVCDelegate, view : CheckAvailabilityVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    
    func getServiceSlots(date:String)
    {
        
        WebService.Shared.GetApi(url: APIAddress.GET_SLOTS_DATES + "serviceDate=\(date)" , Target: self.view, showLoader: true, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(Slot_Model.self, from: jsonData)
                self.delegate.getSlotsResult(data: model.body)
                
            }
            catch
            {
                self.delegate.nothingFound(type: "slots")
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        }, completionnilResponse: {(error) in
            self.delegate.nothingFound(type: "slots")
        })
    }
    
    func getOrderInstructions(compID:String)
    {
        let dlvry = self.view.getDeliveryTypeStatus()
        WebService.Shared.GetApi(url: APIAddress.GET_INSTRUCTIONS + "?companyId=\(compID)&deliveryType=\(dlvry)", Target: self.view, showLoader: true, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(InstructionsModel.self, from: jsonData)
                let status = self.view.getDeliveryTypeStatus()
                if(status == "0")
                {
                    self.view.apiDataInstructions = model.body.deliveryInstructions
                }
                else
                {
                    self.view.apiDataInstructions = model.body.pickupInstructions
                }
                self.view.tableViewInstructions.animateReload()
                self.view.handleViewHeight()
            }
            catch
            {
                self.delegate.nothingFound(type: "slots")
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
                self.view.handleViewHeight()
            }
            
        }, completionnilResponse: {(error) in
            self.delegate.nothingFound(type: "slots")
            self.view.handleViewHeight()
        })
    }
    
    
    func removePromoCode(code:String)
    {
        let obj : [String:Any] = ["promoCode":code]
        
        WebService.Shared.PostApi(url: APIAddress.REMOVE_PROMOCODE, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    
                    self.view.isOfferApplied = false
                    self.view.finalPRICE = self.view.originalPRICE
                    self.view.handleCoupon_Removal()
                    self.view.showToastSwift(alrtType: .success, msg: msg, title: kSuccess)
                    
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
    
    
    func createOrder(addressID:String,serviceDATE_TIME:String,orderPRICE:String,serviceCHARGE:Float,promoCODE:String)
    {
        let stts = self.view.getDeliveryTypeStatus()
        var deliveryInst = ""
        var pickupInst = ""
        var cookingInstruct = self.view.btnCookingInstructions.titleLabel?.text ?? ""
        
        if (cookingInstruct == "Add instructions")
        {
            cookingInstruct = ""
        }
        
        if(stts == "0")
        {
            deliveryInst = self.view.selectedInstructions.componentsJoined(by: ",")
        }
        else
        {
            pickupInst = self.view.selectedInstructions.componentsJoined(by: ",")
        }
        
        //        let obj : [String:Any] = ["addressId":addressID,"serviceDateTime":serviceDATE_TIME,"orderPrice":orderPRICE,"serviceCharges":"\(serviceCHARGE)","promoCode":promoCODE,"deliveryType":stts,"companyId":AppDefaults.shared.companyID,"deliveryInstructions":deliveryInst,"pickupInstructions":pickupInst,"cookingInstructions":cookingInstruct,"tip":"\(self.view.tipAmount)","usedLPoints":"\(self.view.useLoyaltypoint)","LPointsPrice":"0"] //\(self.view.myLoaylty?.onePointValue ?? 0)
        
        
        var parm = [String:Any]()
        parm["addressId"] = addressID
        parm["serviceDateTime"] = serviceDATE_TIME
        parm["orderPrice"] = orderPRICE
        parm["serviceCharges"] = "\(serviceCHARGE)"
        
        parm["promoCode"] = promoCODE
        parm["deliveryType"] = stts
        parm["companyId"] = AppDefaults.shared.companyID
        parm["deliveryInstructions"] = deliveryInst
        parm["pickupInstructions"] = pickupInst
        parm["cookingInstructions"] = cookingInstruct
        parm["tip"] = "\(self.view.tipAmount)"
        parm["usedLPoints"] = "\(self.view.useLoyaltypoint)"
        
      //  let onepoint = "\(self.view.myLoaylty.value(forKey: "onePointValue") ?? 0)"
     //   let price1 = Float(onepoint) ?? 0
     //   let loyltyBenifit = price1 * Float(self.view.useLoyaltypoint)
        
        parm["LPointsPrice"] = self.view.loyltiPointBalance
        parm["paymentType"] = self.view.payType
        
        
        
        var mediaObjs = [[String:Any]]()
        
        if(self.view.myAudioFile != nil)
        {
            var mediaObj = [String:Any]()
            mediaObj["fileType"] = "Audio"
            mediaObj["url"] = self.view.myAudioFile
            mediaObjs.insert(mediaObj, at: 0)
        }
        parm["cookingInstMedia"] = mediaObjs
        
        
        WebService.Shared.uploadDataMulti(mediaType: .Song, url: APIAddress.CREATE_ORDER, postdatadictionary: parm, Target: self.view, completionResponse: { (response) in
            
            Commands.println(object: response)
            
            if response.count > 0
            {
                let code = response["code"] as? Int ?? 0
                let msg = response["message"] as? String ?? "success"
                
                if (code == 200)
                {
                    if(self.view.payType == "2")//COD
                    {
                        self.openThankYouScreen()
                    }
                    else//Online Pay
                    {
                        let body = response["body"] as? NSDictionary
                        let ordrID = body?.value(forKey: "id")as? String ?? ""
                        self.view.orderID = ordrID
                        
                        DispatchQueue.main.async {
                            self.view.makePayment()
                        }
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
            
        }, completionnilResponse:
            { (error) in
                self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        { (error) in
            self.view.showToastSwift(alrtType: .error, msg: error.debugDescription, title: kFailed)
        }
        
        
        
        
        //        WebService.Shared.PostApi(url: APIAddress.CREATE_ORDER, parameter: obj , Target: self.view, completionResponse: { response in
        //            Commands.println(object: response)
        //
        //            if let responseData = response as? NSDictionary
        //            {
        //                let code = responseData.value(forKey: "code") as? Int ?? 0
        //                let msg = responseData.value(forKey: "message") as? String ?? "success"
        //
        //                if (code == 200)
        //                {
        //                    let body = responseData.value(forKey: "body")as? NSDictionary
        //                    let ordrID = body?.value(forKey: "id")as? String ?? ""
        //                    self.view.orderID = ordrID
        //                    self.view.makePayment()
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
    }
    
    
    func updatePaymentStatus(transactionID:String,paymentMODE:String,Status:String,orderID:String,Amount:String)
    {
        
        let obj : [String:Any] = ["transactionId":transactionID,"paymentMode":paymentMODE,"orderId":orderID,"amount":Amount,"status":Status]
        
        WebService.Shared.PostApi(url: APIAddress.UPATE_PAYEMENT_STATUS, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.openThankYouScreen()
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
    
    
    
    func checkAddressCharges(addresID:String,getResult:  @escaping (String) -> Void)
    {
        let obj : [String:Any] = ["companyId":AppDefaults.shared.companyID,"addressId":addresID]
        
        WebService.Shared.PostApi(url: APIAddress.GET_ADDRESS_CHARGES, parameter: obj , Target: self.view, completionResponse: { response in
            
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                
                if (code == 200)
                {
                    self.view.btnPayNow.isHidden = false
                    let body = responseData.value(forKey: "body") as? NSDictionary
                    let charges = body?.value(forKey: "shipment")as? String ?? "0"
                    getResult(charges)
                }
                else
                {
                    self.view.showToastSwift(alrtType: .error, msg: msg, title: "")
                    self.view.btnPayNow.isHidden = true
                }
            }
            else
            {
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
                self.view.btnPayNow.isHidden = true
            }
        }, completionnilResponse: {(error) in
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
            self.view.btnPayNow.isHidden = true
        })
    }
    
    
    func addDates()
    {
        let arr = NSMutableArray()
        let formatter = DateFormatter()
        let formatter2 = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        formatter2.dateFormat = "dd     MMM    yyyy"
        
        for i in 0...4
        {
            guard let newDate = Calendar.current.date(byAdding: .day, value: i, to: Date()) else { return }
            let fDate = formatter.string(from: newDate)
            let NDate = formatter2.string(from: newDate)
            let dic = NSMutableDictionary()
            dic.setValue(fDate, forKey: "date")
            dic.setValue(NDate, forKey: "date2")
            arr.add(dic)
        }
        
        self.view.slotDates = arr
        self.view.collectionView_Dates.setEmptyMessage("")
        self.view.collectionView_Dates.reloadData()
        self.view.preDateSelection(indx: 0)
        
    }
    
    func openThankYouScreen()
    {
        AppDefaults.shared.serviceType = "" //setting service type refresh for new entries
        AppDefaults.shared.cartCount = 0
        AppDefaults.shared.CartCompanyID = ""
        AppDefaults.shared.companyID = ""
        let controller = Navigation.GetInstance(of: .OrderReceivedVC)as! OrderReceivedVC
        controller.delegateOrderRecvd = self.view
        self.view.present(controller, animated: true, completion: nil)
    }
}

