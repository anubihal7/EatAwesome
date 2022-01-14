
//

import Foundation
import Alamofire

protocol MembershipVCDelegate
{
    func getData (list : [MemList])
    func nothingFound()
}

class MembershipViewModel
{
    var delegate : MembershipVCDelegate
    var view : MembershipVC
    
    init(Delegate : MembershipVCDelegate, view : MembershipVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getPlans()
    {
        WebService.Shared.GetApi(url: APIAddress.GetMembership, Target: self.view, showLoader: true, completionResponse:
            { (response) in
                
                do
                {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(MembershipDataModel.self, from: jsonData)
                    self.delegate.getData(list: model.body!)
                }
                catch
                {
                    self.delegate.nothingFound()
                    self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
                }
                
        })
        { (err) in
            self.delegate.nothingFound()
            if(err != "Details")
            {
                self.view.showToastSwift(alrtType: .error, msg: err, title: kFailed)
            }
            else
            {
                AppDefaults.shared.CartCompanyID = ""
                AppDefaults.shared.cartCount = 0
            }
        }
        
    }
    
    
    
}
    
