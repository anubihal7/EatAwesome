
//

import Foundation
import Alamofire

protocol FAQVCDelegate
{
    func getData (model : [FAQResult],cats:[catDEC])
    func nothingFound()
}

class FAQViewModel
{
    var delegate : FAQVCDelegate
    var view : FAQVC
    
    init(Delegate : FAQVCDelegate, view : FAQVC)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getFAQList()
    {
       // http://51.79.40.224:9075/api/mobile/getFaq?limit=10&page=1&category=16
        WebService.Shared.GetApi(url: APIAddress.GET_FAQ + "limit=100&page=1&category=\(self.view.selectdCat)"
            , Target: self.view, showLoader: true, completionResponse: { response in
                Commands.println(object: response)
                
                do
                {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(FAQResponseModel.self, from: jsonData)
                    let list = model.body.data
                    self.delegate.getData(model: list,cats:model.body.category)
                }
                catch
                {
                    self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
                }
                
        }, completionnilResponse: {(error) in
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
}

