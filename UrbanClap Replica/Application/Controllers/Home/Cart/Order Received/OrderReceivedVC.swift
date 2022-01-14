//

//

import UIKit
import Lottie

protocol UpdateViewAfterSuccess_Delegate
{
    func refreshController(approach:String)
}

class OrderReceivedVC: UIViewController
{

    @IBOutlet var lblSuccss: UILabel!
    @IBOutlet var btnDone: CustomButton!
    @IBOutlet var viewLottie: UIView!
    
    let animationView = AnimationView(name: "nice")
    var delegateOrderRecvd: UpdateViewAfterSuccess_Delegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.btnDone.backgroundColor = Appcolor.get_category_theme()
        self.btnDone.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
       //self.lblSuccss.textColor = Appcolor.kTheme_ColorOrange
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //animationView.center = self.viewLottie.center
         animationView.frame = viewLottie.frame
         animationView.contentMode = .scaleAspectFit
         animationView.loopMode = .playOnce
         viewLottie.addSubview(animationView)
         animationView.play()
    }

    @IBAction func actionMove(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        self.delegateOrderRecvd?.refreshController(approach: "home")
    }
    

}
