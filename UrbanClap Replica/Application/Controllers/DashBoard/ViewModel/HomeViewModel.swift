
import Foundation
import Alamofire

protocol HomeServiceDelegate:class
{
    func Show(msg: String)
    func didError(error:String)
}

class HomeViewModel
{
    typealias successHandler = (HomeModel) -> Void
    var delegate : HomeServiceDelegate
    var view : HomeDashboardVC
    
    init(Delegate : HomeServiceDelegate, view : HomeDashboardVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    //MARK:- GetHomeServiceApi
    func getHomeServicesApi(completion: @escaping successHandler)
    {
        WebService.Shared.GetApi(url: APIAddress.GET_HOME_CATEGORIES , Target: self.view, showLoader: true, completionResponse: { (response) in
            print(response)
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let getAllListResponse = try JSONDecoder().decode(HomeModel.self, from: jsonData)
                completion(getAllListResponse)
            }
            catch
            {
                self.view.showToastSwift(alrtType: .error, msg: error.localizedDescription, title: kOops)
            }
            
        }, completionnilResponse: {(error) in
            self.view.showToastSwift(alrtType: .error, msg: error, title: kOops)
            self.delegate.didError(error: error)
        })
    }
    
    
    func clearCart()
    {
        let obj : [String:Any] = [:]
        
        WebService.Shared.deleteApi(url: APIAddress.CLEAR_CART_ITEMS, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.view.selctedCartID = ""
                    self.view.showAlertMessage(titleStr: kAppName, messageStr: "Your cart is cleared successfully. Now you can choose your service vendor.")
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
    
    func jsonToString(json: [String:Any]) -> String
    {
        do
        {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
            return convertedString ?? ""
        }
        catch let myJSONError
        {
            print(myJSONError)
            return ""
        }
        
    }
}

//MARK:- HomeDelegate
extension HomeDashboardVC : HomeServiceDelegate
{
    func Show(msg: String)
    {
        
    }
    
    func didError(error: String)
    {
        
    }
    
    
}
