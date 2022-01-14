
//

import Foundation
import Alamofire

protocol HomeNewVCDelegate
{
    
    func getData (restOffers : [RESTOfferDEC],topPicks : [TopPickNEW] ,trendindServices:[TrendingNEW],offers:[OfferNEW],allData:BodyNEW, selected : [TopPickNEW])
    func nothingFound()
}

class HomeNew_ViewModel
{
    var delegate : HomeNewVCDelegate
    //  var view : HomeNewVC
    var view : DashboardHome
    
    init(Delegate : HomeNewVCDelegate, view : DashboardHome)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getCategoryList()
    {
        let status = self.view.getDeliveryTypeStatus()
        
        WebService.Shared.GetApi(url: APIAddress.NEW_HOME_API + "?deliveryType=\(status)&lat=\(AppDefaults.shared.app_LATITUDE)&lng=\(AppDefaults.shared.app_LONGITUDE)&itemType=\(self.view.vegOnly)" , Target: self.view, showLoader: false, completionResponse: { response in
           // Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(HomeNew_Response.self, from: jsonData)
                self.delegate.getData(restOffers: model.body.restOffers, topPicks: model.body.topPicks, trendindServices: model.body.trending,  offers: model.body.offers,allData:model.body, selected: model.body.suggested)
                self.view.recentORDER = model.body.recentOrder
                self.view.HandleRecentOrderBanner()
                
                AppDefaults.shared.currency = model.body.currency ?? "$"
                AppDefaults.shared.cartCount = model.body.cartCount ?? 0
                
                if(model.body.deliveryType == 0)
                {
                   AppDefaults.shared.deliveryType = "pickup"
                }
                else if(model.body.deliveryType == 1)
                {
                   AppDefaults.shared.deliveryType = "delivery"
                }
                else
                {
                   AppDefaults.shared.deliveryType = "both"
                }
                
                self.view.checkDeliveryTypeOption()
                
                
                //Ask for Survay
                if(model.body.detailsFilled == 0)
                {
                    let controller = Navigation.GetInstance(of: .FillSurveyVC)as! FillSurveyVC
                    self.view.present(controller, animated: true, completion: nil)
                }
                
                //Asking for driver rating for recent completed order
                let cmpltOrder = model.body.completedorder?.orderID
                if(cmpltOrder?.count ?? 0 > 0)
                {
                    let controller = Navigation.GetInstance(of: .AddDriverRatings) as! AddDriverRatings
                    controller.driverJSon = model.body.completedorder
                    self.view.present(controller, animated: true, completion: nil)
                }
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
                    self.view.showToastSwift(alrtType: .error, msg: msg, title: kOops)
                }
            }
            else
            {
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        })
        { (error) in
            self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        }
    }
    
    
}

