
//

import UIKit
import Lottie

class ReferAndEarnVC: CustomController
{
    
    @IBOutlet var btnShare: ButtonWithShadowAndRadious!
    @IBOutlet var btnSideBar: UIButton!
    @IBOutlet var lblReferalCode: UILabel!
    @IBOutlet var animView: UIView!
    let animationView = AnimationView(name: "refer")
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setStatusBarColor(view: self.view, color: kpurpleTheme)
        self.btnShare.updateLayerProperties()
        btnSideBar.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool)
    {
         animationView.frame = animView.bounds
         animationView.contentMode = .scaleAspectFit
         animationView.loopMode = .playOnce
         animView.addSubview(animationView)
         animationView.play()
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func acnShare(_ sender: Any)
    {
        // text to share
        let text = "Hey!! join me on \(kAppName) app and get delicious food and exciting offers. Use this referral code \(AppDefaults.shared.MyReferralCode) for login"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    

}
