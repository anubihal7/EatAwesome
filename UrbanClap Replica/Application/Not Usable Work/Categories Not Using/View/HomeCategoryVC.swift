//

//

import UIKit
import BottomPopup
import SkeletonView

class HomeCategoryVC: BottomPopupViewController
{
    
    @IBOutlet var tableViewServices: UITableView!
    @IBOutlet var ivSlide: UIImageView!
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    override var popupDimmingViewAlpha: CGFloat { return 0.5 }
    
   // var viewModel:HomeCat_ViewModel?
    
   // var bannersList: [Banner]? = nil
  //  var trendingServicesList: [TrendingService]? = nil
  //  var servicesList: [Service]? = nil
    
    var isSkeleton = true
    var skeletonItems = 5
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true
        
      //  self.viewModel = HomeCat_ViewModel.init(Delegate: self, view: self)
        setUI()
        // Do any additional setup after loading the view.
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
       // self.viewModel?.getCategoryList()
    }
   
    func setUI()
    {
        ivSlide.backgroundColor = Appcolor.get_category_theme()
        ivSlide.layer.cornerRadius = 5
        ivSlide.layer.masksToBounds = true
        roundCorners()
    }
    
    func roundCorners()
    {
        let path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.bounds
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
    }
    
}

/*extension HomeCategoryVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (isSkeleton == false)
        {
           return self.servicesList?.count ?? 0
        }
        return skeletonItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellClass_HomeVC", for: indexPath)as! CellClass_HomeVC
        
        if let data = servicesList?[indexPath.row]
        {
            cell.hideAnimation()
            cell.lblCatNamme.text = data.name
            let img = data.icon
            cell.ivCat.image = UIImage(named:"dumProfile")
            cell.ivCat.setImage(with: img, placeholder: kplaceholderProfile)
            cell.ivCat.CornerRadius(radius: 30.0)
        }
        else
        {
            cell.showAnimation()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
    
}*/

/*extension HomeCategoryVC : HomeCatVCDelegate
{
    func getData(banners: [Banner], services: [Service], trendingService: [TrendingService])
    {
        self.bannersList = banners
        self.servicesList = services
        self.trendingServicesList = trendingService
        
        if (servicesList?.count ?? 0 > 0)
        {
            self.isSkeleton = false
            self.tableViewServices.setEmptyMessage("")
            self.tableViewServices.reloadData()
        }
        else
        {
            self.isSkeleton = true
            skeletonItems = 0
            self.tableViewServices.setEmptyMessage("Services Not Available!")
        }
        
    }
    
}*/


