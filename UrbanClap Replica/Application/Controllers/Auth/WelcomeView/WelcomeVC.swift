
//

import UIKit
import Lottie

class WelcomeVC: UIViewController
{
    
    @IBOutlet var viewBG: UIView!
    //let animationView = AnimationView(name: "pan")
    let animationView = AnimationView(name: "food")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        //view did load is good here
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        // animationView.center = self.viewLottie.center
        animationView.frame = viewBG.frame
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        viewBG.addSubview(animationView)
        animationView.play()
        
        let seconds = 3.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds)
        {
            let controller = Navigation.GetInstance(of: .LoginWithPhoneVC)as! LoginWithPhoneVC
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
    }
    
    
    
}
