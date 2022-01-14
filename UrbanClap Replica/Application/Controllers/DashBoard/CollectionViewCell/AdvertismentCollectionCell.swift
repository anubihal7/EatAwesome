
//

import UIKit

class AdvertismentCollectionCell: UICollectionViewCell
{
    //MARK:- Outlet And Variables
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewBack: UIView!
    
    //MARK:- other Functions
    func setView()
    {
        
        viewBack.layer.cornerRadius = 10
        viewBack.layer.shadowColor = UIColor.lightGray.cgColor
        viewBack.layer.shadowOffset = CGSize(width: 4, height: 4)
        viewBack.layer.shadowRadius = 2
        viewBack.layer.shadowOpacity = 0.6
        viewBack.layer.masksToBounds = false
        viewBack.clipsToBounds = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        // self.viewBack.dropShadow(radius:8.0)
        //  viewBack.setDropShadow()
    }
    
    //MARK:- setBanners
    func setBanner(bannerList: BannerNew)
    {
        if let url = bannerList.url
        {
            self.imageView.setImage(with: url, placeholder: kplaceholderImage)
        }
    }
}
