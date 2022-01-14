
//

import UIKit

class FAQDetailsVC: UIViewController
{

    @IBOutlet var lblQsn: UILabel!
    @IBOutlet var lblAnswr: UILabel!
    
    var qsn = ""
    var ansr = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideNAV_BAR(controller: self)
        
        self.lblQsn.text = qsn
        self.lblAnswr.text = ansr
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func acnNo(_ sender: Any)
    {
        
    }
    
    @IBAction func acnYes(_ sender: Any)
    {
        
    }
}
