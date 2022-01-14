
//

import UIKit
import Lottie

class WelcomeHomeVC: UIViewController
{
    
    @IBOutlet var viewBG: UIView!
   // let animationView = AnimationView(name: "pan")
    let animationView = AnimationView(name: "food")
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
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
            AppDefaults.shared.showSplash = false
            self.dismiss(animated: true, completion: nil)
        }
    }
}
