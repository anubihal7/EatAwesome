
//

import Foundation

import Alamofire

protocol RatingVCDelegate
{
    func getData ()
    func nothingFound()
}

class RatingViewModel
{
    var delegate : RatingVCDelegate
    var view : RatingVC
    
    init(Delegate : RatingVCDelegate, view : RatingVC)
    {
        delegate = Delegate
        self.view = view
    }
    
   
    
    
    func addRating(companyId:String,rating:String,review:String,foodQuantity: String,foodQuality:String, packingPres :String )
     {
         let params = ["companyId":companyId,
        "rating":rating,"review":review,"foodQuantity":foodQuantity,"foodQuality":foodQuality,"packingPres":packingPres,
        ]
        
        
         WebService.Shared.PostApi(url: APIAddress.addRatingNew, parameter: params, Target: self.view, completionResponse:
         { (response) in
             
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    
                    self.view.AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Rating has been added successfully.", Target: self.view)
                    {
                         self.view.dismiss(animated: true, completion: nil)
                    }
                   
                }
                else
                {
                    self.view.showToastSwift(alrtType: .error, msg: msg, title: "")
                }
            }
            else
            {
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
             
         })
         { (err) in
             self.view.showToastSwift(alrtType: .error, msg: err, title: kFailed)
         }
     }
    
    
    
}
