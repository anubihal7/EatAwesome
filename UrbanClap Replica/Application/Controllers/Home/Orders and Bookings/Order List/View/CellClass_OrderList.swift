
//

import UIKit

class CellClass_OrderList: UITableViewCell
{
    
    @IBOutlet weak var btnhelp: ButtonWithShadowAndRadious!
    @IBOutlet var btnTrack: ButtonWithShadowAndRadious!
    @IBOutlet var lblServiceDate: UILabel!
    @IBOutlet var lblHeadingService: UILabel!
    @IBOutlet var lblBookedOn: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var btnCencel: ButtonWithShadowAndRadious!
    
    @IBOutlet var btnTapOnCell: UIButton!
    @IBOutlet var cellCollectionView: UICollectionView!
    @IBOutlet var cellCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet var titleServiceDate: UILabel!
    @IBOutlet var titleBookedOn: UILabel!
    @IBOutlet var titleServices: UILabel!
    @IBOutlet var btnRate: ButtonWithShadowAndRadious!
    
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.btnCencel.updateLayerProperties()
        self.btnTrack.updateLayerProperties()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    
    func getOrderStatus(status:Int)-> String
    {
        if(status == 0)
        {
            return "Pending"
        }
        if(status == 1)
        {
            return "Confirmed"
        }
        if(status == 2)
        {
            return "Cancelled"
        }
        if(status == 3)
        {
            return "Processing"
        }
        if(status == 4)
        {
            return "Cancelled By Company"
        }
        if(status == 5)
        {
            return "Completed"
        }
        if(status == 6)
        {
            return "Cooking"
        }
        if(status == 7)
        {
            return "Packed"
        }
        if(status == 8)
        {
            return "Out for delivery"
        }
        if(status == 9)
        {
            return "Reached"
        }
        if(status == 10)
        {
            return "Reached and waiting"
        }
        
        return "Pending"
    }
    
    func getStatusColor(status:Int)-> UIColor
    {
        if(status == 5)
        {
            return Appcolor.kButtonBackgroundColorGreen
        }
        if(status == 4)
        {
            return UIColor.red
        }
        if(status == 2)
        {
            return UIColor.red
        }
        else
        {
            return Appcolor.kTheme_ColorOrange
        }
    }
    
    func hideAnimation()
    {
        [self.lblHeadingService,self.lblBookedOn,self.lblTotal].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.lblHeadingService,self.lblBookedOn,self.lblTotal].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }
    
}





class CellClass_CellCollection: UICollectionViewCell
{
    
    @IBOutlet var iv: UIImageView!
    @IBOutlet var lblSrviceName: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
}




class CellClass_NewOrderList: UITableViewCell
{
    
    @IBOutlet var widthRateBtn: NSLayoutConstraint!
    @IBOutlet weak var btnhelp: ButtonWithShadowAndRadious!
    @IBOutlet weak var btnRate: ButtonWithShadowAndRadious!
    @IBOutlet var btnCencel: ButtonWithShadowAndRadious!
    
    @IBOutlet var ivVendor: UIImageView!
    @IBOutlet var lblVendrName: UILabel!
    @IBOutlet var lblOrderDate: UILabel!
    @IBOutlet var lblDeliverdDate: UILabel!
    @IBOutlet var lblTotal: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.btnCencel.updateLayerProperties()
        self.btnhelp.updateLayerProperties()
        self.btnRate.updateLayerProperties()
        // Initialization code
    }
    
    
    func getOrderStatus(status:Int)-> String
    {
        if(status == 0)
        {
            return "Pending"
        }
        if(status == 1)
        {
            return "Confirmed"
        }
        if(status == 2)
        {
            return "Cancelled"
        }
        if(status == 3)
        {
            return "Processing"
        }
        if(status == 4)
        {
            return "Cancelled By Company"
        }
        if(status == 5)
        {
            return "Completed"
        }
        if(status == 6)
        {
            return "Cooking"
        }
        if(status == 7)
        {
            return "Packed"
        }
        if(status == 8)
        {
            return "Out for delivery"
        }
        if(status == 9)
        {
            return "Reached"
        }
        if(status == 10)
        {
            return "Reached and waiting"
        }
        
        return "Pending"
    }
    
    func getStatusColor(status:Int)-> UIColor
    {
        if(status == 2)
        {
            return UIColor.red
        }
        if(status == 4)
        {
            return UIColor.red
        }
        if(status == 5)
        {
            return kpurpleTheme
        }
        if(status == 9)
        {
            return kpurpleTheme
        }
        if(status == 10)
        {
            return kpurpleTheme
        }
        else
        {
            return korangeTheme
        }
    }
    
    
    
}



