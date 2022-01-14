//

//

import Foundation
import UIKit



extension ServiceDetailVC
{
    
    
    func setUI()
    {
        self.btnCart.updateLayerProperties()
        self.ivImage.setImage(with: objData?.thumbnail ?? "", placeholder: kplaceholderImage)
        self.ivImage.CornerRadius(radius: 10.0)
        self.viewRatings.rating = Double(objData?.rating ?? "0") ?? 0.0
        self.lblName.text = objData?.name ?? ""
        
       // self.lblPrice.text = "\(objData?.currency ?? "")\(objData?.price ?? "")"
        self.lblPrice.text = "\(AppDefaults.shared.currency)\(objData?.price ?? 0)"
        
        price = Int("\(objData?.price ?? 0)") ?? 0
        
        let abt = objData?.bodyDescription ?? ""
        let data = Data(abt.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        {
            self.lblDetail.attributedText = attributedString
        }
        else
        {
            self.lblDetail.text = kDataNothingTOSHOW
        }
        
        self.btnCart.backgroundColor = Appcolor.get_category_theme()
        self.btnCart.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
    
        self.lblDuration.text = objData?.duration
       // self.lblTurnAroundTime.text = objData?.turnaroundTime
        self.lblPricing.text = self.lblPrice.text
        
        self.lblIncludedServices.text = objData?.includedServices
        self.lblExcludedServices.text = objData?.excludedServices
        
        
        
        
        if (self.lblIncludedServices.text?.count ?? 0 == 0)
        {
           self.lblIncludedServices.text = "Not Available"
        }
        if (self.lblExcludedServices.text?.count ?? 0 == 0)
        {
           self.lblExcludedServices.text = "Not Available"
        }
//        if (self.lblTurnAroundTime.text?.count ?? 0 == 0)
//        {
//           self.lblTurnAroundTime.text = "Not Available"
//        }
        
        
        
        if (objData?.favourite?.count ?? 0 > 0)
        {
            self.btnFav.setImage(UIImage(named: "fav"), for: .normal)
        }
        else
        {
            self.btnFav.setImage(UIImage(named: "unfav"), for: .normal)
        }
        
        self.companyID = objData?.category.id ?? ""
        
        if (objData?.cart?.count ?? 0 > 0)
        {
            self.cartVendorID = objData?.cart ?? ""
            self.btnCart.backgroundColor = UIColor.red
            self.btnCart.setTitle("REMOVE FROM CART?", for: .normal)
        }
        else
        {
            self.btnCart.backgroundColor = Appcolor.get_category_theme()
            self.btnCart.setTitle("ADD TO CART", for: .normal)
        }
        
        
        let discnt = objData?.originalPrice
        if(discnt != nil && discnt != 0)
        {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(AppDefaults.shared.currency)\(String(describing: discnt!))")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            self.lblDiscount.attributedText = attributeString
        }
        else
        {
            self.lblDiscount.attributedText = NSAttributedString(string: "")
        }
        
        if(objData?.itemType == "0")
        {
            self.ivVeg.image = UIImage(named: "veg")
        }
        else
        {
            self.ivVeg.image = UIImage(named: "nonveg")
        }
        
        self.view.setNeedsLayout()
    }
    
    
func checkVendorIsSameForCartVendoer(serviceid:String,price:Int)
{
    let controller = Navigation.GetInstance(of: .AddToCartVC)as! AddToCartVC
    controller.compID = AppDefaults.shared.companyID
    controller.serviceID = serviceid
    controller.price = price
    controller.delegateInstructions = self
    
    if (AppDefaults.shared.CartCompanyID.count == 0)
    {
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    else
    {
        if(AppDefaults.shared.CartCompanyID == AppDefaults.shared.companyID)
        {
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
        else
        {
            self.AlertMessageWithOkCancelAction(titleStr: "Items already in cart", messageStr: "Your cart contains items from a different restaurant. Would you like to reset your cart before adding this item?", Target: self)
            { (actn) in
                if (actn == KYes)
                {
                    self.viewModel?.clearCart(serviceid:serviceid,price:price)
                }
            }
        }
    }
}
    
}

extension ServiceDetailVC:UpdateViewAfterAddCart_Delegate
{
    //updating view after adding quantity and add to cart
    func refreshController(text: String)
    {
        self.viewModel?.getServiceDetails(sId: catID)
        AppDefaults.shared.CartCompanyID = AppDefaults.shared.companyID
        self.updateCartBadge(target:self)
    }
}





