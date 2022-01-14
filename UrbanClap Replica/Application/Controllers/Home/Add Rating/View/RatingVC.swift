
//

import UIKit

class RatingVC: CustomController {
    
     @IBOutlet var lblTitle: UILabel!
     @IBOutlet var lblLoc: UILabel!
     @IBOutlet var txtRating: UITextView!
    
    @IBOutlet weak var viewBGG: UIView!
    @IBOutlet weak var sliderTotalRating: SliderStep!
    @IBOutlet weak var sliderStepRating1: SliderStep!
    @IBOutlet weak var sliderStepRating2: SliderStep!
    @IBOutlet weak var sliderStepRating3: SliderStep!
    
    @IBOutlet weak var btnProceed: ButtonWithShadowAndRadious!
     var viewModel:RatingViewModel?
    var str_rating1 : String?
        var str_rating2 : String?
        var str_rating3 : String?
     var str_rating4 : String?
        var title1 : String = ""
    var comId : String = ""
        var loc : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ratings"
        BackButton()
        self.btnProceed.updateLayerProperties()
        self.viewModel = RatingViewModel.init(Delegate: self, view: self)
        setupRatingView(slider: sliderTotalRating, ratingVar: str_rating4 ?? "0")
        setupRatingView(slider: sliderStepRating1, ratingVar: str_rating1 ?? "0")
        setupRatingView(slider: sliderStepRating2, ratingVar: str_rating2 ?? "0")
        setupRatingView(slider: sliderStepRating3, ratingVar: str_rating3 ?? "0")
        CornerRadius(radius: 8, view: txtRating)
        txtRating.layer.borderColor = UIColor.darkGray.cgColor
        txtRating.layer.borderWidth = 1
        lblLoc.text = loc
        lblTitle.text = title1
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.viewBGG.frame.origin.y == 6 {
                self.viewBGG.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.viewBGG.frame.origin.y != 6 {
            self.viewBGG.frame.origin.y = 6
        }
    }
    

    
    @IBAction func submitRating(_ sender: UIButton) {
        
        print(comId)
        
        self.view.endEditing(true)
        
        self.viewModel?.addRating(companyId: comId , rating: str_rating4  ?? "0" , review: txtRating.text , foodQuantity: str_rating3 ?? "0", foodQuality: str_rating1 ?? "0", packingPres: str_rating2 ?? "0")
      }
      
      //MARK:- Design
      func setupRatingView(slider: SliderStep, ratingVar : String) {
        
          slider.stepImages =   [UIImage(named:"terrible")!, UIImage(named:"bad")!, UIImage(named:"okay")!, UIImage(named:"good")!,UIImage(named:"great")!, ]
          
          slider.tickTitles = ["Terrible", "Bad", "Okay", "Good", "Great"]
          slider.tickImages = [UIImage(named:"unTerrible")!, UIImage(named:"unBad")!, UIImage(named:"unOkay")!, UIImage(named:"unGood")!,UIImage(named:"unGreat")!, ]
          
          slider.minimumValue = 1
          slider.maximumValue = Float(slider.stepImages!.count) + slider.minimumValue - 1.0
          slider.stepTickColor = UIColor.clear
          slider.stepTickWidth = 40
          slider.stepTickHeight = 40
          slider.trackHeight = 1
        slider.value = (ratingVar as NSString).floatValue.rounded(.towardZero)
          slider.trackColor = #colorLiteral(red: 0.9371728301, green: 0.9373074174, blue: 0.9371433258, alpha: 1)
          slider.enableTap = true
          slider.sliderStepDelegate = self
          slider.selectedFont  = UIFont.systemFont(ofSize:10)
          slider.unselectedFont  = UIFont.systemFont(ofSize: 10)
         slider.highlightedImageSize = 25

          //sliderStepRating.translatesAutoresizingMaskIntoConstraints = false
       //   self.view.addSubview(slider)
//          NSLayoutConstraint.activate([
//              //sliderStepRating
//              slider.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
//              slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//              slider.heightAnchor.constraint(equalToConstant: 35),
//              slider.widthAnchor.constraint(equalToConstant: 150)
//          ])
      }
}


//MARK:- SliderStepDelegate
extension RatingVC: SliderStepDelegate {
    func didSelectedValue(sliderStep: SliderStep, value: Float) {
        
      
      //  let s = NSString(format: "%.0f", value)

        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        // Configure the number formatter to your liking
        let s2 = nf.string(from: NSNumber(value: value))
        
        if sliderStep == sliderTotalRating {
            str_rating4 = s2
        }
        else if sliderStep == sliderStepRating1 {
            str_rating1 = s2
        }
        
        else if sliderStep == sliderStepRating2 {
            str_rating2 = s2
        }
        else if sliderStep == sliderStepRating3 {
                   str_rating3 = s2
               }
        
        print(Int(value))
    }
}

extension RatingVC : RatingVCDelegate
{
    func getData() {
        
    }
    
    func nothingFound() {
        
    }
    
}

extension RatingVC : UITextViewDelegate {
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
            if text == "\n" {
                textView.resignFirstResponder()
                 self.viewBGG.frame.origin.y = 6
                return false
            }
            return true
       
    }
}
