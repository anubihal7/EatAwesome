//


import Foundation
import UIKit
import PayUMoneyCoreSDK
import PlugNPlay
import CryptoSwift
import AVFoundation


extension CheckAvailabilityVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (collectionView == self.collectionView_Dates)
        {
            return self.slotDates.count
        }
        else
        {
            if isSkeleton_Service == true
            {
                return skeletonItems_Service
            }
            
            return self.apiData_Slots?.slots.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell = UICollectionViewCell()
        
        if (collectionView == self.collectionView_Dates)
        {
            let cellNew = collectionView.dequeueReusableCell(withReuseIdentifier: cellDATE, for: indexPath)as! CellClass_SlotDates
            
            cellNew.viewBG.layer.cornerRadius = 25
            cellNew.viewBG.layer.masksToBounds = true
            cellNew.viewBG.layer.borderWidth = 1
            cellNew.viewBG.layer.borderColor = UIColor.darkGray.cgColor
            
            if let obj = self.slotDates[indexPath.item]as? NSDictionary
            {
                cellNew.lblName.text = obj.value(forKey: "date2") as? String ?? "N/A"
                
                if (indexPath.item == self.selectedIndxDate)
                {
                    cellNew.viewBG.backgroundColor = Appcolor.get_category_theme()
                    cellNew.lblName.textColor = Appcolor.kTextColorWhite
                }
                else
                {
                    cellNew.viewBG.backgroundColor = Appcolor.kViewBackgroundColorWhite
                    cellNew.lblName.textColor = Appcolor.kTextColorBlack
                }
            }
            cell = cellNew
        }
        else
        {
            let cellNew2 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)as! CellClass_Slots
            if isSkeleton_Service == false
            {
                if let obj = self.apiData_Slots?.slots[indexPath.item]
                {
                    let txt = obj.slot
                    cellNew2.lblName.text = txt
                    
                    if (indexPath.item == self.selectedIndx)
                    {
                        cellNew2.viewBG.backgroundColor = Appcolor.get_category_theme()
                        cellNew2.lblName.textColor = Appcolor.kTextColorWhite
                    }
                    else
                    {
                        cellNew2.viewBG.backgroundColor = Appcolor.kViewBackgroundColorWhite
                        cellNew2.lblName.textColor = Appcolor.kTextColorBlack
                        
                        if (obj.status == 1)
                        {
                            cellNew2.lblName.textColor = Appcolor.kTextColorBlack
                            cellNew2.isUserInteractionEnabled = true
                        }
                        else if(obj.status == 2)
                        {
                            cellNew2.lblName.textColor = Appcolor.kTextColorBlack
                            cellNew2.isUserInteractionEnabled = false
                            cellNew2.viewBG.backgroundColor = UIColor.red
                        }
                        else
                        {
                            cellNew2.lblName.textColor = Appcolor.kTextColorGray
                            cellNew2.isUserInteractionEnabled = false
                            cellNew2.viewBG.backgroundColor = UIColor.white
                        }
                    }
                }
            }
            
            cellNew2.viewBG.layer.cornerRadius = 25
            cellNew2.viewBG.layer.masksToBounds = true
            cellNew2.viewBG.layer.borderWidth = 1
            cellNew2.viewBG.layer.borderColor = UIColor.darkGray.cgColor
            
            cell = cellNew2
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if (collectionView == self.collectionView_Dates)
        {
           // let obj = self.slotDates[indexPath.item]as? String
            self.preDateSelection(indx:indexPath.item)
        }
        else
        {
            self.selectedIndx = indexPath.item
            let obj = self.apiData_Slots?.slots[indexPath.item]
            self.selectedLot = obj?.slot ?? ""
            self.collectionView_Slots.reloadData()
        }
    }
    
    func preDateSelection(indx:Int)
    {
        let obj = self.slotDates[indx]as? NSDictionary
        self.selectedDate = obj?.value(forKey: "date") as? String ?? ""
        self.selectedIndxDate = indx
        self.collectionView_Dates.reloadData()
        self.viewModel?.getServiceSlots(date:self.selectedDate)
        self.selectedIndx = -2
        self.selectedLot = ""
    }
}

extension CheckAvailabilityVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if (collectionView == self.collectionView_Dates)
        {
            return CGSize(width: 76, height: 93)
        }
        else
        {
            return CGSize(width: 76, height: 96)
        }
        
    }
    
}



extension CheckAvailabilityVC
{
    func handleCoupon_Applied()
    {
        UIView.animate(withDuration: 0.6, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            
            //            let fprice = Int(self.price)
            //            let off = ((fprice ?? 0) * self.offDiscount)/100
            //
            //            let disc = (fprice ?? 0) - off
            //
            //            self.lblFinalPrice.text = "\(AppDefaults.shared.currency) \(disc)"
            //
            
            let updatedPrice = (Float(self.finalPRICE) ?? 0) + self.shippingCharges + self.tipAmount
            self.finalPriceTOTAL = "\(updatedPrice)"
            self.lblFinalPrice.text = "\(AppDefaults.shared.currency)\(self.finalPriceTOTAL)"
            
        //    self.ConstraintWidth_CouponRemove.constant = 62
        //    self.ivCouponArrow.isHidden = true
            
            self.btnCoupon.setTitle("\(self.cpnName)% discount coupon applied", for: .normal)
            self.setOfferLabel()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func setOfferLabelPrice()
    {
        self.totalPriceBeforeOffer = "\((Float(self.originalPRICE) ?? 0) + self.shippingCharges + self.tipAmount)"
        if(self.isOfferApplied == true)
        {
           self.setOfferLabel()
        }
    }
    
    func setOfferLabel()
    {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(AppDefaults.shared.currency) \(self.totalPriceBeforeOffer)")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.lblDiscount.attributedText = attributeString
    }
    
    func handleCoupon_Removal()
    {
        UIView.animate(withDuration: 0.6, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            
            let updatedPrice = ((Float(self.finalPRICE) ?? 0) + self.shippingCharges + self.tipAmount) - self.loyltiPointBalance
            self.finalPriceTOTAL = "\(updatedPrice)"
            
            
        //    self.ConstraintWidth_CouponRemove.constant = 0
        //    self.ivCouponArrow.isHidden = false
            self.lblDiscount.attributedText = NSAttributedString(string: "")
            self.btnCoupon.setTitle("Apply coupon", for: .normal)
            self.cpnCODE = ""
            self.cpnName = ""
            self.ivPromo.image = UIImage(named: "pl")
            self.lblFinalPrice.text = "\(AppDefaults.shared.currency)\(self.finalPriceTOTAL)"
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func handleTipRemoval()
    {
        self.btnTip10.tag = 0
        self.btnTip20.tag = 0
        self.btnTip30.tag = 0
        self.btnTip50.tag = 0
        self.btnTip10.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip20.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip30.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip50.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.tipAmount = 0.0
    }
    
    
    //MARK: TABLE VIEW DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.apiDataInstructions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellClassInstructions", for: indexPath)as! cellClassInstructions
        
        if let obj = self.apiDataInstructions?[indexPath.row]
        {
            cell.lblTitle.text = obj.heading ?? "N/A"
            cell.lblTXT.text = obj.instruction ?? "N/A"
            
            let instrctID = self.apiDataInstructions?[indexPath.row].id ?? 0
            
            if(self.selectedInstructions.contains(instrctID))
            {
                cell.ivTick.image = UIImage(named: "tick2")
            }
            else
            {
                cell.ivTick.image = UIImage(named: "untick")
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.tableViewInstructions.deselectRow(at: indexPath, animated: true)
        let instrctID = self.apiDataInstructions?[indexPath.row].id ?? 0
        if(self.selectedInstructions.count == 0)
        {
            self.selectedInstructions.add(instrctID)
        }
        else
        {
            if(self.selectedInstructions.contains(instrctID))
            {
                self.selectedInstructions.remove(instrctID)
            }
            else
            {
                self.selectedInstructions.add(instrctID)
            }
        }
        self.tableViewInstructions.reloadData()
    }
    
    
    func handleViewHeight()
    {
        if (self.apiDataInstructions?.count ?? 0 > 0)
        {
            let height = CGFloat((self.apiDataInstructions?.count ?? 0)*70)
         //   self.ConstraintHeight_InstructTblView.constant = height
            self.ConstraintHeight_InstructView.constant = height + 30
        }
        else
        {
          //  self.ConstraintHeight_InstructTblView.constant = 0
            self.ConstraintHeight_InstructView.constant = 0
        }
        
        handleAddressView()
        self.viewDidLayoutSubviews()
    }
    
    
    
    
    
    func setUI()
    {
        // AppDefaults.shared.userAddressID = ""
        self.ivPromo.image = UIImage(named: "pl")
        self.setStatusBarColor(view: self.view, color: kpinkTheme)
        self.navView.backgroundColor = kpinkTheme
        self.addrssID = AppDefaults.shared.userAddressID
        self.lblItems.text = "\(self.items)"
        self.lblDiscount.text = ""
        self.lblFinalPrice.text = "\(AppDefaults.shared.currency)\(self.finalPRICE)"
        self.btnPayNow.backgroundColor = Appcolor.get_category_theme()
        self.btnPayNow.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        self.lblFinalPrice.textColor = Appcolor.get_category_theme()
   //     self.ConstraintWidth_CouponRemove.constant = 0
        
        
        let hgt = CGFloat(30)
        
        self.btnTip10.layer.cornerRadius = hgt
        self.btnTip10.layer.masksToBounds = true
        
        self.btnTip20.layer.cornerRadius = hgt
        self.btnTip20.layer.masksToBounds = true
        
        self.btnTip30.layer.cornerRadius = hgt
        self.btnTip30.layer.masksToBounds = true
        
        self.btnTip50.layer.cornerRadius = hgt
        self.btnTip50.layer.masksToBounds = true
        
        
        let crrncy = AppDefaults.shared.currency
        self.btnTip10.setTitle("\(crrncy)10", for: .normal)
        self.btnTip20.setTitle("\(crrncy)20", for: .normal)
        self.btnTip30.setTitle("\(crrncy)30", for: .normal)
        self.btnTip50.setTitle("\(crrncy)50", for: .normal)
        
        
        self.btnTip10.layer.borderWidth = 1
        self.btnTip10.layer.borderColor = UIColor.darkGray.cgColor
        
        self.btnTip20.layer.borderWidth = 1
        self.btnTip20.layer.borderColor = UIColor.darkGray.cgColor
        
        self.btnTip30.layer.borderWidth = 1
        self.btnTip30.layer.borderColor = UIColor.darkGray.cgColor
        
        self.btnTip50.layer.borderWidth = 1
        self.btnTip50.layer.borderColor = UIColor.darkGray.cgColor
        
       
        
        
        
        let usablePoints = "\(self.myLoaylty.value(forKey: "usablePoints") ?? 0)"
        let onePoint = "\(self.myLoaylty.value(forKey: "onePointValue") ?? 0)"
        let blnc = "\(self.myLoaylty.value(forKey: "balance") ?? 0)"
        
        
        //Loyalty Points Section
        self.lblLoyaltyPoints.text = "You can use loyalty points : \(usablePoints)/\(blnc)"
        self.lblLoyltyInstruction.text = "Use loyalty points to redeem price, 1 Point = \(AppDefaults.shared.currency)\(onePoint)"
        self.lblLoyaltyPoints.textColor = Appcolor.get_category_theme()
        
        if(blnc == "0")
        {
            self.ConstaintHeight_LoyltiPointView.constant = 0//66
            self.ivLoyltySign.isHidden = true
        }
        else
        {
            self.ConstaintHeight_LoyltiPointView.constant = 66
            self.ivLoyltySign.isHidden = false
        }
        
       // self.priceDetailViewHeight.constant = 348//282
        self.handleAddressView()
    }
    
    
    func makePayment()
    {
        let txnsID = self.generateRandomString()
        PlugNPlay .setMerchantDisplayName("Payment")
        
        //Customize UI of PayuMoney
        
        PlugNPlay.buttonColor()
        
        
        PlugNPlay .setButtonTextColor(UIColor.white)
        PlugNPlay .setButtonColor(Appcolor.get_category_theme())
        PlugNPlay .setTopTitleTextColor(UIColor.white)
        PlugNPlay .setTopBarColor(Appcolor.get_category_theme())
        PlugNPlay .setDisableCompletionScreen(true)
        PlugNPlay.setExitAlertOnBankPageDisabled(true)
        PlugNPlay.setExitAlertOnCheckoutPageDisabled(true)
        
        let txnParam = PUMTxnParam()
        txnParam.phone = AppDefaults.shared.userPhoneNumber
        txnParam.email = AppDefaults.shared.userEmail
        txnParam.amount = self.finalPriceTOTAL
        //txnParam.amount = "1"
        txnParam.environment = PUMEnvironment.test
        //txnParam.environment = PUMEnvironment.production
        txnParam.firstname = AppDefaults.shared.userName
        txnParam.key = "vnlMA5F0"
        txnParam.merchantid = "7001862"
        txnParam.txnID = txnsID
        txnParam.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php"
        txnParam.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php"
        txnParam.productInfo = kAppName
        txnParam.udf1 = "as"
        txnParam.udf2 = "sad"
        txnParam.udf3 = "ud3"
        txnParam.udf4 = ""
        txnParam.udf5 = ""
        txnParam.udf6 = ""
        txnParam.udf7 = ""
        txnParam.udf8 = ""
        txnParam.udf9 = ""
        txnParam.udf10 = ""
        
        
        let hashSequence = "\(txnParam.key!)|\(txnParam.txnID!)|\(txnParam.amount!)|\(txnParam.productInfo! )|\(txnParam.firstname!)|\(txnParam.email!)|\(txnParam.udf1!)|\(txnParam.udf2!)|\(txnParam.udf3!)|\(txnParam.udf4!)|\(txnParam.udf5!)|\(txnParam.udf6!)|\(txnParam.udf7!)|\(txnParam.udf8!)|\(txnParam.udf9!)|\(txnParam.udf10!)|\(salt)"
        
        let data = hashSequence.data(using: .utf8)
        
        txnParam.hashValue = data?.sha512().toHexString()
        
        
        PlugNPlay.presentPaymentViewController(withTxnParams: txnParam, on: self)
        { (response, error, extraParam) in
            
            
            if (response != nil)
            {
                if let dict : Dictionary = response
                {
                    print(dict)
                    
                    let result = dict["result"]as? NSDictionary
                    let status  = result?.value(forKey: "status")as? String
                    let payMode  = result?.value(forKey: "mode")as? String
                    let errmsg = result?.value(forKey: "error_Message")as? String ?? "Unknown error occurred!"
                    let trscnID = "\(result?.value(forKey: "paymentId")as? Int ?? 0)"
                    
                    if (status == "success")
                    {
                        self.viewModel?.updatePaymentStatus(transactionID: trscnID, paymentMODE: payMode ?? "", Status: "1", orderID: self.orderID, Amount: self.finalPriceTOTAL)
                    }
                    else
                    {
                        // let reason = self.get_transaction_failed_reason(dicnry: result ?? NSDictionary())
                        self.showToastSwift(alrtType: .error, msg: errmsg, title: kFailed)
                        
                        // self.viewModel?.updatePaymentStatus(transactionID: trscnID, paymentMODE: payMode ?? "", Status: "2", orderID: self.orderID, Amount: self.finalPRICE)
                    }
                }
                else
                {
                    self.showToastSwift(alrtType: .error, msg: kSomthingWrong, title: kOops)
                    // self.viewModel?.updatePaymentStatus(transactionID: trscnID, paymentMODE: self.payMode, Status: "2", orderID: self.orderID, Amount: self.finalPRICE)
                }
            }
            else
            {
                self.showToastSwift(alrtType: .error, msg: error?.localizedDescription ?? "Payment failed!", title: kFailed)
                //  self.viewModel?.updatePaymentStatus(transactionID: "", paymentMODE: self.payMode, Status: "1", orderID: self.orderID, Amount: self.finalPRICE)
            }
            
        }
        
    }
    
   
    
    func playSound()
    {
       // guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }
        
        if(self.myAudioFile != nil)
        {
            do
            {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: self.myAudioFile ?? URL(string: "")!, fileTypeHint: AVFileType.mp3.rawValue)
                
                player?.delegate = self
                /* iOS 10 and earlier require the following line:
                 player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
                
                guard let player = player else { return }
                
                player.play()
                
            }
            catch let error
            {
                self.btnPlayAudio.tag = 0
                self.btnPlayAudio.setBackgroundImage(UIImage(named: "recordplay"), for: .normal)
                print(error.localizedDescription)
            }
        }
        else
        {
            self.btnPlayAudio.tag = 0
            self.btnPlayAudio.setBackgroundImage(UIImage(named: "recordplay"), for: .normal)
        }
    }
    
    
    func handleAddressView()//if pickup option is choose then address view should be hidden
    {
        
        if(AppDefaults.shared.deliveryType == "delivery")
        {
            self.setTypeDelivery()
        }
        if(AppDefaults.shared.deliveryType == "pickup")
        {
            self.setTypePickup()
        }
        else//both
        {
            if(AppDefaults.shared.deliveryTypeForBoth == "1")
            {
                self.setTypeDelivery()
            }
            else
            {
                self.setTypePickup()
            }
        }
    }
    
    
    func setTypeDelivery()
    {
        self.InstrcViewTop.constant = 18
        self.lblAddressTitle.isHidden = false
        self.btnEditAddress.isHidden = false
        self.lblAddressType.isHidden = false
        self.lblAddressName.isHidden = false
        self.ivLocation.isHidden = false
        
        self.addressFound(addrss: AppDefaults.shared.userHomeAddress, type: AppDefaults.shared.userAddressType, adrssID: AppDefaults.shared.userAddressID)
        
        self.lblAvailDate.text = "Choose your delivery date"
        self.lblAvailTime.text = "Choose your delivery time"
        self.lblInstructHeader.text = "Delivery instructions"
        self.lblTipTitle.text = "Tip your delivery partner"
        self.lblTipDesc.text = "Thank your delivery partner for helping you stay safe indoors. Support them with some tips"
        self.lblShippingChargesTitle.text = "Delivery Charges"
    }
    
    func setTypePickup()
    {
        self.InstrcViewTop.constant = -100
        self.lblAddressTitle.isHidden = true
        self.btnEditAddress.isHidden = true
        self.lblAddressType.isHidden = true
        self.lblAddressName.isHidden = true
        self.ivLocation.isHidden = true
        
        let fp = Float(self.finalPRICE) ?? 0.0
        self.finalPriceTOTAL = "\(fp)" // Address not required so setting up final price here and dont remove this line
        
        self.lblAvailDate.text = "Choose your pickup date"
        self.lblAvailTime.text = "Choose your pickup time"
        self.lblTipTitle.text = "Tip for your order boy"
        self.lblInstructHeader.text = "Pickup instructions"
        self.lblTipDesc.text = "Thank your order boy for helping you for pickup order. Support him with some tip"
        self.lblShippingCharges.text = "\(AppDefaults.shared.currency)\(0)"
        self.lblShippingChargesTitle.text = "Service Charges"
    }

}
