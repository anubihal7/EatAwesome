
//

import UIKit

class TiffinHomeCell: UITableViewCell {
    
    //MARK:- outlet and Variables
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var imgNonVeg: UIImageView!
    @IBOutlet weak var kWidthNonVeg: NSLayoutConstraint!
    @IBOutlet weak var lblPackages: UILabel!
    @IBOutlet weak var imgVeg: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblAvailability: UILabel!
    @IBOutlet weak var kImgRight: NSLayoutConstraint!
   
    var serviceType,avaliable,packes:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    //MARK:- Other function
    func setView(data:TiffinHomeBody?){
        // imgView.CornerRadius(radius: 2)
        
        if let url = data?.thumbnail{
            imgView.setImage(with: url, placeholder: kplaceholderImage)
        }
        else{
            imageView?.image = UIImage(named: kplaceholderImage)
        }
        if data?.itemType == "0"{
            imgVeg.isHidden = false
            imgNonVeg.isHidden = true
            kWidthNonVeg.constant = 0
            kImgRight.constant = 0
        }
        else if data?.itemType == "1"{
            imgVeg.isHidden = true
            imgNonVeg.isHidden = false
            kWidthNonVeg.constant = 20
            kImgRight.constant = 8
        }
        else if data?.itemType == "2"{
            imgVeg.isHidden = false
            imgNonVeg.isHidden = false
            kWidthNonVeg.constant = 20
            kImgRight.constant = 8
        }
        else{
            imgVeg.isHidden = false
            imgNonVeg.isHidden = false
        }
        lblTitle.text = data?.name ?? ""
        serviceType = ""
        if let tags = data?.tags{
            for data in tags{
                if serviceType == "" {
                    serviceType = data
                }
                else{
                    serviceType = (serviceType ?? "") + ", " + data
                }
            }
        }
        lblServiceType.text = serviceType ?? ""
        
        avaliable = ""
        if let avaliblity = data?.availability{
            for data in avaliblity{
                if avaliable == "" {
                    avaliable = data
                }
                else{
                    avaliable = (avaliable ?? "") + ", " + data
                }
            }
        }
        lblAvailability.text = avaliable ?? ""
        
        packes = ""
        if let packages = data?.packages{
            for data in packages{
                if packes == "" {
                    packes = data
                }
                else{
                    packes = (packes ?? "") + ", " + data
                }
            }
        }
        lblPackages.text = packes ?? ""
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func hideAnimation()
    {
        [self.imgVeg,self.lblPackages,self.imgVeg,self.lblTitle,self.imgView,self.lblAvailability].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.imgVeg,self.lblPackages,self.imgVeg,self.lblTitle,self.imgView,self.lblAvailability].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }
}


