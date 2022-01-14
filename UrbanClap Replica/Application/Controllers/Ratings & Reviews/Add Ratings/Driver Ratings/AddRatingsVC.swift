
//

import UIKit
import Cosmos

protocol AddRatingVC_Delegate
{
    func ratingFound(updateData:NSMutableDictionary)
}

class AddRatingsVC: UIViewController,UITextViewDelegate
{

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var ivService: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var rateView: CosmosView!
    @IBOutlet var txtViewDesc: UITextView!
    @IBOutlet var btnAdd: CustomButton!
    
    var data = NSMutableDictionary()
    var delegateAddRatings: AddRatingVC_Delegate?
    var isRated = false
    var oldRating = 0.0
    var isDriver = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUI()

        // Do any additional setup after loading the view.
    }
    
    
    
    func setUI()
    {
        if(isDriver == true)
        {
            self.lblTitle.text = "Rate service driver"
            let fName = self.data.value(forKey: "firstName")as? String ?? ""
            let lName = self.data.value(forKey: "lastName")as? String ?? ""
            self.lblName.text = "\(fName) \(lName)"
            self.rateView.rating = data.value(forKey: "rating")as? Double ?? 0.0
            let img = data.value(forKey: "image")as? String ?? ""
            self.ivService.setImage(with: img, placeholder: kplaceholderImage)
            self.ivService.CornerRadius(radius: 10.0)
        }
        else
        {
            self.lblTitle.text = "Rate service"
            self.lblName.text = data.value(forKey: "name")as? String ?? ""
            self.rateView.rating = data.value(forKey: "rating")as? Double ?? 0.0
            let img = data.value(forKey: "icon")as? String ?? ""
            self.ivService.setImage(with: img, placeholder: kplaceholderImage)
            self.ivService.CornerRadius(radius: 10.0)
        }
        
        self.oldRating = data.value(forKey: "rating")as? Double ?? 0.0
        self.btnAdd.backgroundColor = Appcolor.get_category_theme()
        self.btnAdd.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        
        self.blurView.layer.cornerRadius = 10
        self.blurView.layer.masksToBounds = true
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    

    @IBAction func actionAdd(_ sender: Any)
    {
        self.txtViewDesc.resignFirstResponder()
        let ratings : Double = self.rateView.rating
        
        if(ratings == 0.0)
        {
            self.isRated = false
        }
        else
        {
            self.isRated = true
        }
            
        
        if (self.isRated == true)
        {
            
            if (self.txtViewDesc.text == "Add some thoughts" || self.txtViewDesc.text == "")
            {
                self.txtViewDesc.text = "N/A"
            }
            
            //rating for driver
            if(isDriver == true)
            {
                let Icon = self.data.value(forKey: "image")as? String ?? ""
                let sid = self.data.value(forKey: "id")as? String ?? ""
                let fName = self.data.value(forKey: "firstName")as? String ?? ""
                let lName = self.data.value(forKey: "lastName")as? String ?? ""
                
                self.data.setValue(Icon, forKey: "image")
                self.data.setValue(sid, forKey: "id")
                self.data.setValue(fName, forKey: "firstName")
                self.data.setValue(lName, forKey: "lastName")
                
                self.data.setValue(self.txtViewDesc.text, forKey: "description")
                self.data.setValue(ratings, forKey: "rating")
                self.data.setValue("1", forKey: "rated")
                
                Commands.println(object:self.data as Any)
                self.delegateAddRatings?.ratingFound(updateData: self.data)
            }
            else//rating for service
            {
                let Icon = self.data.value(forKey: "icon")as? String ?? ""
                let sid = self.data.value(forKey: "id")as? String ?? ""
                let Name = self.data.value(forKey: "name")as? String ?? ""
                
                self.data.setValue(Icon, forKey: "icon")
                self.data.setValue(sid, forKey: "id")
                self.data.setValue(Name, forKey: "name")
                self.data.setValue(self.txtViewDesc.text, forKey: "description")
                self.data.setValue(ratings, forKey: "rating")
                self.data.setValue("1", forKey: "rated")
                
                Commands.println(object:self.data as Any)
                self.delegateAddRatings?.ratingFound(updateData: self.data)
            }
            
            
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            Commands.println(object: "USER DOESNT GIVED ANY RATINGS FOR THIS SERVICE")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
