
//

import Foundation
import Alamofire

protocol SeeAllRestaurantsVCDelegate
{
    func getData (vendors : [BestSellerNEW])
    func nothingFound()
}

class SeeAllRestaurantsViewModel
{
    var delegate : SeeAllRestaurantsVCDelegate
    var view : SeeAllRestaurantsVC
    
    init(Delegate : SeeAllRestaurantsVCDelegate, view : SeeAllRestaurantsVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getRestaurantsList()
    {
        let status = self.view.getDeliveryTypeStatus()
        
        WebService.Shared.GetApi(url: APIAddress.GET_ALLRESTAURANTS + "?deliveryType=\(status)&page=1&limit=1000&itemType=\(self.view.vegOnly)&lat=\(AppDefaults.shared.app_LATITUDE)&lng=\(AppDefaults.shared.app_LONGITUDE)&discount=\(self.view.discount)" , Target: self.view, showLoader: false, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(AllRestuarants_Response.self, from: jsonData)
                self.delegate.getData(vendors: model.body)
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
    
    
    func clearCart(compID:String)
    {
        let obj : [String:Any] = [:]
        
        WebService.Shared.deleteApi(url: APIAddress.CLEAR_CART_ITEMS, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.view.addBadge(itemvalue: "0")
                    let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
                    AppDefaults.shared.companyID = compID
                    controller.categoryID = mainID
                    self.view.push_To_Controller(from_controller: self.view, to_Controller: controller)
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
        { (error) in
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        }
    }
    
    
}
