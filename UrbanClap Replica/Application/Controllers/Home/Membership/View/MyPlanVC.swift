//

//

import UIKit

class MyPlanVC: CustomController {
    
      var user_Subscription: UserSubscription?
    @IBOutlet weak var tblViewList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewList.animateReload()
        tblViewList.tableFooterView = UIView()
        tblViewList.separatorColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
  
}
extension MyPlanVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! MyPlanCell
        cell.lblPrice.text = user_Subscription?.amount
        //cell.lblPlanName.text = user_Subscription?.duration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 175
    }
    

}
