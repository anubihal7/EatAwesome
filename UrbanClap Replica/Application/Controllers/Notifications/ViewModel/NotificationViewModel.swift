//

//

import Foundation
import Alamofire

protocol NotificationVCDelegate
{
    func ShowResults(msg: String)
    func getData (model : [NotificationResult])
}

class NotificationListViewModel
{
    var delegate : NotificationVCDelegate
    var view : NotificationVC
    
    init(Delegate : NotificationVCDelegate, view : NotificationVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getNotificationList()
    {
        WebService.Shared.GetApi(url: APIAddress.GET_NOTIFICATIONS
            , Target: self.view, showLoader: true, completionResponse: { response in
                Commands.println(object: response)
                
                do
                {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(NotificationResponseModel.self, from: jsonData)
                    let list = model.body
                    if list != nil
                    {
                        self.delegate.getData(model: list!)
                    }
                }
                catch
                {
                    self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
                }
                
        }, completionnilResponse: {(error) in
           // self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
    
    func deleteNotificationList()
    {
        WebService.Shared.deleteApi(url: APIAddress.CLEAR_NOTIFICATIONS, parameter: [:]
            , Target: self.view, showLoader: true, completionResponse: { response in
                Commands.println(object: response)
                
                
                self.delegate.ShowResults(msg: "Notifications deleted successfully.")
                self.view.localModel = nil
                self.view.tblViewNotificationList.animateReload()
                self.view.tblViewNotificationList.setEmptyMessage("Notifications not available!")
                
                
        }, completionnilResponse: {(error) in
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
    
}
