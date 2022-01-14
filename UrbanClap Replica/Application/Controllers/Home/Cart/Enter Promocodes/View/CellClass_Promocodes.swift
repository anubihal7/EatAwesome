//


import UIKit

class CellClass_Promocodes: UITableViewCell
{

    
    @IBOutlet var lblNew: UILabel!
    @IBOutlet var btnApply: CustomButton!
    @IBOutlet var ivPrmo: UIImageView!
    @IBOutlet var lblDesc: UILabel!
  //  @IBOutlet var lblRccmmd: UILabel!
  //  @IBOutlet var lblAppliedon: UILabel!
    @IBOutlet var ivCode: UIImageView!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.btnApply.setTitleColor(Appcolor.get_category_theme(), for: .normal)
        
        self.ivCode.backgroundColor = kpinkTheme
        self.ivPrmo.backgroundColor = kpurpleTheme
        self.ivPrmo.CornerRadius(radius: 10.0)
        self.ivCode.CornerRadius(radius: 7.0)
        self.ivCode.layer.borderColor = UIColor.lightGray.cgColor
        self.ivCode.layer.borderWidth = 1
      //  self.lblRccmmd.layer.cornerRadius = 7
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func hideAnimation()
    {
        [self.btnApply,self.ivPrmo,self.ivCode].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.btnApply,self.ivPrmo,self.ivCode].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
    
}

