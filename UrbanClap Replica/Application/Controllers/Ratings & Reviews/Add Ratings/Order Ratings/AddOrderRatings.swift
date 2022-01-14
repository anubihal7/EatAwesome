//

//

import UIKit
import Cosmos
import KMPlaceholderTextView

class AddOrderRatings: CustomController
{
    
    @IBOutlet var viewNavBar: UIView!
    @IBOutlet var viewImages: UIView!
    @IBOutlet var viewRestrnt: UIView!
    @IBOutlet var viewItems: UIView!
    @IBOutlet var itemViewHeight: NSLayoutConstraint!
    @IBOutlet var lblItemHeader: UILabel!
    @IBOutlet var rstrntViewTop: NSLayoutConstraint!
    
    @IBOutlet var rateViewPackage: CosmosView!
    @IBOutlet var rateViewQuality: CosmosView!
    @IBOutlet var rateViewValueMoney: CosmosView!
    @IBOutlet var tblHeight: NSLayoutConstraint!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var collGallery: UICollectionView!
    @IBOutlet var btnSubmit: ButtonWithShadowAndRadious!
    
    @IBOutlet var ivVendor: UIImageView!
    @IBOutlet var lblVendorName: UILabel!
    @IBOutlet var VendorRate: CosmosView!
    @IBOutlet var txtView: KMPlaceholderTextView!
    
    var rstrntImage = ""
    var rstrntName = ""
    
    var restaurantData = NSDictionary()
    var arrayItems = NSMutableArray()
    var arrayGallery = NSMutableArray()
    var selectedPicker: ImagePickers?
    var vendorID = ""
    
    var approach = ""
    var rstrntDetailJson:RatingInfoDec?
    var orderID = ""
    
    enum ImagePickers
    {
        case gallery
        
        
        init()
        {
            self = .gallery
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideNAV_BAR(controller: self)
        self.setStatusBarColor(view: self.view, color: kpinkTheme)
        self.viewNavBar.backgroundColor = kpinkTheme
        self.btnSubmit.updateLayerProperties()
        
        
        if(approach == "profile")//coming from restaurant's profile
        {
            self.hideOrderItemsView()
            self.setProfileData()
        }
        else//coming from order
        {
            self.getServiceList(orderID:orderID)
        }
        
        
        let dic = NSMutableDictionary()
        dic.setValue(UIImage(), forKey: "data")
        dic.setValue(imageURL, forKey: "url")
        dic.setValue(1, forKey: "dummy")
        
        self.arrayGallery.add(dic)
        self.collGallery.reloadData()
        
        self.txtView.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
    @IBAction func acnSubmit(_ sender: Any)
    {
        if (self.VendorRate.rating == 0)
        {
            self.showToastSwift(alrtType: .statusOrange, msg: "Please add rating for restaurant", title: "")
        }
        else
        {
            self.calculatePostData()
        }
        
    }
    
    @IBAction func acnDeleteImage(_ sender: UIButton)
    {
        let arr = self.arrayGallery.mutableCopy() as! NSMutableArray
        arr.removeObject(at: sender.tag)
        self.arrayGallery = arr
        self.collGallery.reloadData()
    }
    
    
    func calculatePostData()
    {
        var parm = [String:Any]()
        
        parm["companyId"] = self.vendorID
        parm["orderId"] = self.orderID
        parm["rating"] = "\(self.VendorRate.rating)"
        parm["review"] = self.txtView.text
        parm["foodQuantity"] = "\(self.rateViewValueMoney.rating)"
        parm["foodQuality"] = "\(self.rateViewQuality.rating)"
        parm["packingPres"] = "\(self.rateViewPackage.rating)"
        
        
        var mediaObjs = [[String:Any]]()
        let itemRatngs = NSMutableArray()
        
        
        if(self.arrayGallery.count > 1)
        {
            for i in 0...self.arrayGallery.count-1
            {
                if(i != 0)
                {
                    let obj = self.arrayGallery.object(at: i) as! NSDictionary
                    
                    var mediaObj = [String:Any]()
                    mediaObj["fileType"] = "Image"
                    mediaObj["url"] = obj.value(forKey: "url")as! URL
                    let img : UIImage = obj.value(forKey: "data")as! UIImage
                    mediaObj["imageData"] = img
                    mediaObjs.append(mediaObj)
                }
            }
        }
        
        //Item Rating
        if(self.arrayItems.count > 0)
        {
            for i in 0...self.arrayItems.count-1
            {
                let obj = self.arrayItems.object(at: i) as? NSDictionary
                
                let inxpth = IndexPath(row: i, section: 0)
                let cell = self.tblView.cellForRow(at: inxpth)as! cellOrderItems
                
                let ratings = cell.viewRate.rating
                let sid = obj?.value(forKey: "id")as? String ?? ""
                
                let dic = NSMutableDictionary()
                dic.setValue("\(ratings)", forKey: "rating")
                dic.setValue(sid, forKey: "serviceId")
                
                itemRatngs.add(dic)
                 
            }
        }
                
        parm["images"] = mediaObjs
        let json = self.convert_Array(arr: itemRatngs)
        parm["ratingData"] = json
        
        self.submitRatings(obj: parm)
    }
    
    func submitRatings(obj: [String:Any])
    {
        WebService.Shared.uploadData_Multiple_image(mediaType:.Image, url: APIAddress.ADD_ORDER_RATING, postdatadictionary: obj, Target: self, completionResponse: { response in
            
            Commands.println(object: response as Any)
            
            self.showToastSwift(alrtType: .success, msg: "Your feedback submitted successfully.", title: "")
            self.navigationController?.popViewController(animated: true)
        }, completionnilResponse: { (errorMsg) in
            self.showToastSwift(alrtType: .error, msg: errorMsg, title: kFailed)
        }, completionError: { (error) in
            self.showToastSwift(alrtType: .error, msg: error as? String ?? "", title: kFailed)
        })
    }
    
    
   
    
}





class cellClassGallery:UICollectionViewCell
{
    @IBOutlet var collGallery: UIImageView!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lblAdd: UILabel!
}


class cellOrderItems:UITableViewCell
{
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var ivVendor: UIImageView!
    @IBOutlet var viewRate: CosmosView!
    @IBOutlet var lblName: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)
    }
}

struct ItemRate
{
    let rating,serviceId:String
}
