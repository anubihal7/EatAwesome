//

//

import UIKit

class SettingsVC: CustomController
{
    
    
    @IBOutlet var viewNav: UIView!
    @IBOutlet var btnDrawer: UIBarButtonItem!
    @IBOutlet var tblViw: UITableView!
    
    var Menu:[String]?
    var MenuImg:[String]?
    
    override func viewDidLoad()//feedback
    {
        super.viewDidLoad()
        self.viewNav.backgroundColor = kpurpleTheme
        self.setStatusBarColor(view:self.view,color:kpurpleTheme)
        self.hideNAV_BAR(controller: self)
        Menu = ["Terms & Conditions","Privacy Policy","FAQ","Cancel Order Policy","Contact Us" ,"Rate Us", "Share App"]
        MenuImg = ["terms","policy","faq","policy","cntct","sstar", "share"]
        self.tblViw.animateReload()
        
        btnDrawer.target = self.revealViewController()
        btnDrawer.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.hideNAV_BAR(controller: self)
    }
    
    
    @IBAction func cellAction(_ sender: UIButton)
    {
        switch sender.tag
        {
        case 0:
            
            let controller = Navigation.GetInstance(of: .TermsAndPrivacyPolicyVC) as! TermsAndPrivacyPolicyVC
            controller.approach = "terms"
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            
            break
        case 1:
            
            let controller = Navigation.GetInstance(of: .TermsAndPrivacyPolicyVC) as! TermsAndPrivacyPolicyVC
            controller.approach = "privacy"
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            
            break
        case 2:
            
            let controller = Navigation.GetInstance(of: .FAQVC) as! FAQVC
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            
            break
            
        case 3:
            let controller = Navigation.GetInstance(of: .TermsAndPrivacyPolicyVC) as! TermsAndPrivacyPolicyVC
                       controller.approach = "order"
                       self.push_To_Controller(from_controller: self, to_Controller: controller)
           // self.showAlertMessage(titleStr: kAppName, messageStr: "Coming Soon!")

            break
            
        case 4:
            
            let contrller = Navigation.GetInstance(of: .ContactusVC)as! ContactusVC
            self.push_To_Controller(from_controller: self, to_Controller: contrller)
            
            break
            
            case 5:
                     
                    if let url = URL(string: "https://apps.apple.com/in/app/afterlight-photo-editor/id1293122457") {
                         UIApplication.shared.open(url)
                     }
                     
                     break
            
        case 6:
                           let shareAll = ["https://apps.apple.com/in/app/afterlight-photo-editor/id1293122457"] as [Any]
                           let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                           activityViewController.popoverPresentationController?.sourceView = self.view
                           self.present(activityViewController, animated: true, completion: nil)
            break
            
        default: break
            
        }
    }
    
    
}

//MARK:- UITableViewDelegate
extension SettingsVC : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.Menu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellClass_Settings", for: indexPath)as! CellClass_Settings
        cell.lblText.text = self.Menu![indexPath.row]
        cell.btnTapOnCell.tag = indexPath.row
        cell.iv.image = UIImage(named:"\(self.MenuImg![indexPath.row])")
        return cell
    }
    
}
