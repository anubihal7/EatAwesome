
//

import UIKit
import BottomPopup
import SkeletonView
import MapKit
import CoreLocation

class HomeVC: CustomController,UIScrollViewDelegate
{
    
    //Outlets
    @IBOutlet var mapVIEW: MKMapView!
    @IBOutlet var ivAlpha: UIImageView!
    @IBOutlet var lblRstrntName: UILabel!
    @IBOutlet var ivVendor: UIImageView!
    @IBOutlet var lblRatings: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblTimings: UILabel!
    @IBOutlet var lblAbtTitle: UILabel!
    @IBOutlet var lblAbtDesc: UITextView!
    
    @IBOutlet var bannerCollection: UICollectionView!
    @IBOutlet var catCollection: UICollectionView!
    
    @IBOutlet var DetailViewHeight: NSLayoutConstraint!
    @IBOutlet var catView_Height: NSLayoutConstraint!
    @IBOutlet var catColl_Height: NSLayoutConstraint!
    @IBOutlet var BannerView_Height: NSLayoutConstraint!
    
    
    @IBOutlet var btnOrder: ButtonWithShadowAndRadious!
    
    
    @IBOutlet var btnDrawer: UIBarButtonItem!
    @IBOutlet var scrollView: UIScrollView!
    
    
    // var GooglePlaceDelegate : AutoCompleteAddress_Google?
    // var sideBar = SWRevealViewController()
    
    var viewModel:HomeCat_ViewModel?
    
    var compnyBanners: [compnyBanners]? = nil
    var bannersList: [Offer]? = nil
    var trendingServicesList: [galleryDec]? = nil
    var servicesList: [subcats]? = nil
    
    var profileDetails:Details?
    var profileRatings:RatingInfoDec?
    var isSkeleton_Cats = true
    var isSkeleton_Trending = true
    var isSkeleton_Offers = true
    
    var skeletonItems_Cats = 10
    
    let cellID_banners = "CellClass_CompnyBanners"
    let cellID_cats = "CellClass_Categories"
    let cellID_trending = "CellClass_TrendingServices"
    let cellID_offer = "CellClass_Offers"
    var categoryID = "0"
    var Tittle = "Menu"
    
    
    @IBOutlet weak var btnRate: ButtonWithShadowAndRadious!
    
    
    var str_rating1 : String = "0"
    var str_rating2 : String = "0"
    var str_rating3 : String = "0"
    
    var comId : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        hideNAV_BAR(controller: self)
        
        self.setUI()
        self.addBadge(itemvalue: "0")
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.viewModel = HomeCat_ViewModel.init(Delegate: self, view: self)
        self.viewModel?.getCategoryList()
        self.updateCartBadge(target:self)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        // self.showNAV_BAR(controller: self)
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func acnLike(_ sender: Any)
    {
        
    }
    
    @IBAction func acnShare(_ sender: Any)
    {
        // text to share
        let text = "Tell your friends about \(kAppName) app!"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func addRating(_ sender: UIButton)
    {
        if AllUtilies.isConnectedToInternet
        {
            //            let storyboard = UIStoryboard(name: "Ratings", bundle: nil)
            //            let VC1 = storyboard.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
            //            VC1.title1 = Tittle
            //            VC1.loc = lblLocation.text ?? ""
            //            VC1.str_rating1 = self.str_rating1
            //            VC1.str_rating2 = self.str_rating2
            //            VC1.str_rating3 = self.str_rating3
            //            VC1.str_rating4 = self.lblRatings.text
            //            VC1.comId = comId ?? ""
            //            let navController = UINavigationController(rootViewController: VC1) //
            //            self.present(navController, animated:true, completion: nil)
            
            let ctrlr = Navigation.GetInstance(of: .AddOrderRatings) as! AddOrderRatings
            ctrlr.approach = "profile"
            ctrlr.vendorID = self.comId ?? ""
            ctrlr.rstrntDetailJson = self.profileRatings
            ctrlr.rstrntImage = self.profileDetails?.logo1 ?? ""
            ctrlr.rstrntName = self.profileDetails?.companyName ?? ""
            self.push_To_Controller(from_controller: self, to_Controller: ctrlr)
            
        }
        else
        {
            self.showToastSwift(alrtType:.info,msg:"Internet appears to be offline!",title:kOops)
        }
    }
    
    
    
    @IBAction func acnViewAllGallery(_ sender: Any)
    {
        //        let controller = Navigation.GetInstance(of: .GalleryVC) as! GalleryVC
        //        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //        controller.compnyID = self.categoryID
        //        controller.arrGallry = self.trendingServicesList
        //        self.present(controller, animated: true, completion: nil)
        
        let controller = Navigation.GetInstance(of: .UploadGalleryVC) as! UploadGalleryVC
        controller.compnyID = self.comId ?? ""
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    @IBAction func actionGoToCart(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .CartListVC)as! CartListVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    @IBAction func actionAboutUs(_ sender: Any)
    {
        if(DetailViewHeight.constant == 320)
        {
            DetailViewHeight.constant = 190
            self.lblAbtDesc.isHidden = true
        }
        else if(DetailViewHeight.constant == 190)
        {
            DetailViewHeight.constant = 320
            self.lblAbtDesc.isHidden = false
        }
        
        self.viewDidLayoutSubviews()
    }
    
    
    
    
    
    @IBAction func acnViewDirections(_ sender: Any)
    {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=0.0,0.0&zoom=14&views=traffic&q=0.0,0.0")!, options: [:], completionHandler: nil)
        }
        else
        {
            // if GoogleMap App is not installed
            //UIApplication.shared.openURL(NSURL(string:"https://www.google.co.in/maps/dir/?saddr=0.0,0.0&daddr=0.0,0.0&directionsmode=driving")! as URL)
        }
    }
    @IBAction func acnViewOrder(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .CatServiceListVC)as! CatServiceListVC
        controller.vendrCatID = categoryID
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    
    
    
    func setCollection_Layout()
    {
        //        let height = catCollection.collectionViewLayout.collectionViewContentSize.height
        //        catColl_Height.constant = height-7
        //        catView_Height.constant = height
        //        self.view.layoutSubviews()
    }
}



//MARK:- SliderStepDelegate
extension HomeVC: SliderStepDelegate
{
    func didSelectedValue(sliderStep: SliderStep, value: Float)
    {
        print(Int(value))
    }
}
extension Float
{
    var clean: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
