//

//

import UIKit

protocol UpdateCartAfterOfferApplied_Delegate
{
    func offerAppliedSuccffull()
    func getOffPercentage(payableAmount:String,cpDiscount:String,totalAmount:String,cpnCode:String)
}

class PromocodesVC: BaseUIViewController,UITextFieldDelegate
{
    
    @IBOutlet var btnApply: CustomButton!
    @IBOutlet var tfCode: CustomUITextField!
    @IBOutlet var tableViewOffers: UITableView!
    let cellID = "CellClass_Promocodes"
    
    var isSkeleton_Service = true
    var skeletonItems_Service = 4
    var apiData : [PromocodeResult]?
    var viewModel:Promocode_ViewModel?
    var delegateCart: UpdateCartAfterOfferApplied_Delegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tfCode.layer.cornerRadius = 15
        self.tfCode.layer.masksToBounds = true
        
        self.tableViewOffers.setEmptyMessage("")
        
        self.viewModel = Promocode_ViewModel.init(Delegate: self, view: self)
        self.viewModel?.getOffersList()
        
        
        self.tfCode.makeRound_Boarders()
        self.btnApply.backgroundColor = Appcolor.get_category_theme()
        self.btnApply.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        
    }
    
    
    
   
    
    
    @IBAction func actionHide(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionApply(_ sender: UIButton)
    {
        if (tfCode.text?.count == 0)
        {
            self.showAlertMessage(titleStr: kAppName, messageStr: "Please enter promocode!")
            sender.shake()
        }
        else
        {
            self.view.endEditing(true)
            self.viewModel?.applyPromoCode(code:self.tfCode.text!)
        }
    }
    
    @IBAction func actionApplyFromList(_ sender: UIButton)
    {
        let obj = self.apiData![sender.tag]
        self.viewModel?.applyPromoCode(code:obj.code ?? "")
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    
}


extension PromocodesVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSkeleton_Service == true
        {
            return skeletonItems_Service
        }
        
        return apiData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellID, for: indexPath)as! CellClass_Promocodes
        
        if let obj = apiData?[indexPath.row]
        {
            cell.hideAnimation()
            cell.btnApply.tag = indexPath.row
            let img = obj.thumbnail ?? ""
            cell.ivPrmo.setImage(with: img, placeholder: kplaceholderImage)
            cell.ivPrmo.CornerRadius(radius: 10.0)
            
            let abt = obj.bodyDescription ?? ""
            let data = Data(abt.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            {
                cell.lblDesc.attributedText = attributedString
            }
            else
            {
                cell.lblDesc.text = kDataNothingTOSHOW
            }
            
            
         //   let crrncy = AppDefaults.shared.currency
           // cell.lblAppliedon.text = "\(obj.discount ?? "")% off on minimum order of \(crrncy)\(obj.minimumAmount ?? "")"
          //  cell.lblAppliedon.text = "\(obj.discount ?? "")% off"
           // cell.lblRccmmd.text = "\(obj.name)"
            
            cell.lblNew.text = "\(obj.code ?? "")"
           // cell.ivCode.layer.borderWidth = 1
           // cell.ivCode.layer.borderColor = Appcolor.get_category_theme().cgColor
            
            
        }
        else
        {
            cell.showAnimation()
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 280.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let obj = self.apiData?[indexPath.row]
        let controller = Navigation.GetInstance(of: .CouponDetailsVC)as! CouponDetailsVC
        controller.delegateDetails = self
        controller.OfferImg = obj?.thumbnail ?? ""
       // controller.offerName = obj?.name ?? ""
        controller.offerName = obj?.code ?? ""
        controller.offerCode = obj?.code ?? ""
        controller.OfferOff = obj?.discount ?? ""
        controller.OfferDetails = obj?.bodyDescription ?? ""
        self.present(controller, animated: true, completion: nil)
    }
}


extension PromocodesVC : PromocodeVCDelegate
{
    func getCouponResults()
    {
        
    }
    
    func getData(offrs: [PromocodeResult])
    {
        DispatchQueue.main.async
            {
                if (offrs.count > 0)
                {
                    self.apiData = offrs
                    self.isSkeleton_Service = false
                    self.tableViewOffers.setEmptyMessage("")
                    self.tableViewOffers.animateReload()
                }
                else
                {
                    self.nothingFound()
                }
        }
    }
    
    func nothingFound()
    {
        self.isSkeleton_Service = false
        self.apiData = nil
        self.tableViewOffers.setEmptyMessage("Offers not available!")
        self.tableViewOffers.animateReload()
    }
    
    
}

extension PromocodesVC:UpdateViewAfterCouponDetails_Delegate
{
    func refreshController(text: String)
    {
        
    }
    
    
}
