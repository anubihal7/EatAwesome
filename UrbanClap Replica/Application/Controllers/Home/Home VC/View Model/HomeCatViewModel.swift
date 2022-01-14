
//

import Foundation
import Alamofire

protocol HomeCatVCDelegate
{
    func getData (banners : [Offer],services : [subcats], trendingService : [galleryDec],compBanners:[compnyBanners])
    func nothingFound()
}

class HomeCat_ViewModel
{
    var delegate : HomeCatVCDelegate
    var view : HomeVC
    
    init(Delegate : HomeCatVCDelegate, view : HomeVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getCategoryList()
    {
        WebService.Shared.GetApi(url: APIAddress.GET_COMPANIES_CATEGORIES + "/?category=\(self.view.categoryID)&itemType=" , Target: self.view, showLoader: false, completionResponse: { response in
            Commands.println(object: response)
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(HomeCat_ResponseModel.self, from: jsonData)
                
                self.view.profileDetails = model.body?.details
                self.view.profileRatings = model.body?.ratingInfo
                
                
                self.delegate.getData(banners: model.body?.offers ?? [Offer](), services:model.body?.subcat ?? [subcats](), trendingService: model.body?.gallery ?? [galleryDec](), compBanners: model.body?.banners ?? [compnyBanners]())
            }
            catch
            {
                self.delegate.nothingFound()
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        }, completionnilResponse: {(error) in
            self.delegate.nothingFound()
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
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
                    self.view.dismiss(animated: true, completion: nil)
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
