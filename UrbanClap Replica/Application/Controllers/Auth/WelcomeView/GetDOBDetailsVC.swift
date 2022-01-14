
//

import UIKit
import SkyFloatingLabelTextField
import Lottie

class GetDOBDetailsVC: UIViewController,UITextFieldDelegate
{
    
    @IBOutlet var viewAnimation: UIView!
    @IBOutlet var heightConstant: NSLayoutConstraint!
    @IBOutlet var tfDOB: SkyFloatingLabelTextField!
    @IBOutlet var tfAnnivrsry: SkyFloatingLabelTextField!
    @IBOutlet var ivSingle: UIImageView!
    @IBOutlet var ivMarried: UIImageView!
    @IBOutlet var btnSubmit: CustomButton!
    
    let animationView = AnimationView(name: "cake")
    let datePicker = UIDatePicker()
    var single = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.hideTextField()
        self.showDatePicker()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        // animationView.center = self.viewLottie.center
        animationView.frame = viewAnimation.frame
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        viewAnimation.addSubview(animationView)
        animationView.play()
    }
    
    @IBAction func singleSelected(_ sender: Any)
    {
        single = true
        showDatePicker()
        self.ivSingle.image = UIImage(named: "radio_selected")
        self.ivMarried.image = UIImage(named: "radio_unselected")
        self.hideTextField()
    }
    
    @IBAction func MarriedSelected(_ sender: Any)
    {
        single = false
        showDatePicker()
        self.ivSingle.image = UIImage(named: "radio_unselected")
        self.ivMarried.image = UIImage(named: "radio_selected")
        self.showTextField()
    }
    
    @IBAction func actionSkip(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .DashboardHome) as! DashboardHome
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    @IBAction func actionSubmit(_ sender: UIButton)
    {
        if single == true
        {
            if(tfDOB.text?.count == 0)
            {
                self.showToastSwift(alrtType:.statusOrange,msg:"Please choose your DOB",title:"Oops!")
                sender.shake()
            }
            else
            {
                self.AddDetailsOnServer()
            }
        }
        else
        {
            if(tfAnnivrsry.text?.count == 0)
            {
                self.showToastSwift(alrtType:.statusOrange,msg:"Please choose your anniversery date",title:"Oops!")
                sender.shake()
            }
            else
            {
                self.AddDetailsOnServer()
            }
        }
    }
    
    func hideTextField()
    {
        self.heightConstant.constant = 0
        self.tfAnnivrsry.isHidden = true
    }
    
    func showTextField()
    {
        self.heightConstant.constant = 34
        self.tfAnnivrsry.isHidden = false
    }
    
    
    
    
    //MARK: DATE PICKER SETUP
    func showDatePicker()
    {
        datePicker.datePickerMode = .date
       // datePicker.minimumDate = Date()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        if(single == true)
        {
            self.tfDOB.inputAccessoryView = toolbar
            self.tfDOB.inputView = datePicker
        }
        else
        {
            self.tfAnnivrsry.inputAccessoryView = toolbar
            self.tfAnnivrsry.inputView = datePicker
        }
        
        
    }
    
    //MARK: DATE PICKER DONE BUTTON
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if(single == true)
        {
            self.tfDOB.text = formatter.string(from: datePicker.date)
        }
        else
        {
            self.tfAnnivrsry.text = formatter.string(from: datePicker.date)
        }
        
        self.view.endEditing(true)
    }
    
    //MARK: DATE PICKER CANCEL BUTTON
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    
    
    
    func AddDetailsOnServer()
    {
        var Status = "single"
        if(single == false)
        {
            Status = "married"
        }
        
        let obj : [String:Any] = ["dob":self.tfDOB.text ?? "","anniversaryDate":self.tfAnnivrsry.text ?? "","maritalStatus":Status]
        
        WebService.Shared.PostApi(url: APIAddress.ADD_BIRTHDAY, parameter: obj , Target: self, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: msg, Target: self)
                    {
                        AppDefaults.shared.userDOB = self.tfDOB.text ?? ""
                        AppDefaults.shared.showSplash = false
                        configs.kAppdelegate.setRootViewController()
                    }
                }
                else
                {
                    self.showToastSwift(alrtType:.statusRed,msg:msg,title:"")
                }
            }
            else
            {
                self.showToastSwift(alrtType:.statusRed,msg:kResponseNotCorrect,title:"")
            }
        }, completionnilResponse: {(error) in
            self.showToastSwift(alrtType:.statusRed,msg:error,title:"")
        })
        
    }
}
