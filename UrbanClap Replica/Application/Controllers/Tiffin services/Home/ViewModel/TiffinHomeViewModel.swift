
//

import Foundation

protocol TiffinHomeDelegate:class
{
    func Show(msg: String)
    func didError(error:String)
}

class TiffinHomeViewModel
{
    typealias successHandler = (TiffinHomeModel) -> Void
    var delegate : TiffinHomeDelegate
    var view : UIViewController
    var isSearching : Bool?
     var showLoader:Bool?
    
    init(Delegate : TiffinHomeDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }
    
    //MARK:- GetHomeServiceApi
    func getTiffinServiceApi(itemType:String?,page:Int,lat:String?,limit:Int,lng:String?,packages:String?,search:String?,orderByInfo:[String:Any]?,completion: @escaping successHandler)
    {
        let params:[String:Any] = ["itemType":itemType ?? "","lat":lat ?? "","lng":lng ?? "" ,"packages":packages ?? "","search":search ?? "","orderByInfo": orderByInfo ?? [String:Any]()]
       
        if isSearching == true{
         showLoader = false
        }
        else{
         showLoader = true
        }
        
        WebService.Shared.SearchPostApi(url: APIAddress.GettiffinHome, parameter: params, showLoader: showLoader ?? false, Target: self.view, completionResponse: { (response) in
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let getAllListResponse = try JSONDecoder().decode(TiffinHomeModel.self, from: jsonData)
                completion(getAllListResponse)
            }
            catch
            {
                self.delegate.didError(error: kResponseNotCorrect)
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
        }) { (error) in
            self.delegate.didError(error: error)
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        }
        
        
    }
    
    
}

//MARK:- TiffinHomeVCDelegate
extension TiffinHomeVC : TiffinHomeDelegate
{
    func Show(msg: String) {
    }
    
    func didError(error: String) {
        
        if isScroll == true{
            
        }
        else{
            apiData.removeAll()
            tableView.setEmptyMessage(kDataNothingTOSHOW)
        }
    }
    
    
}
