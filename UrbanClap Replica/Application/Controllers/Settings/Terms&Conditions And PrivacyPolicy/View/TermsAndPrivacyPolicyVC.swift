
//

import UIKit
import WebKit

class TermsAndPrivacyPolicyVC: CustomController,UIWebViewDelegate
{
    
    @IBOutlet var myWebView: WKWebView!
    
    var approach = "terms"
    var docs:Docs?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getFAQList()
        showNAV_BAR(controller: self)
        // Do any additional setup after loading the view.
    }
    
    func loadWebView()
    {
       // let url = URL(string: "www.cerebruminfotech.com")
        if(self.approach == "terms")
        {
            self.title = "TERMS & CONDITIONS"
            let url = URL(string: self.docs?.termsLink ?? "www.cerebruminfotech.com")
           // myWebView.load(URLRequest(url: url!))
            myWebView.load(URLRequest(url: url!))
        }
        else if(self.approach == "aboutUs")
        {
            self.title = "ABOUT US"
            let url = URL(string: self.docs?.aboutusLink ?? "www.cerebruminfotech.com")
          //  myWebView.load(URLRequest(url: url!))
           myWebView.load(URLRequest(url: url!))
            
        }
            
             else if(self.approach == "order")
                                       {
                                        let url = URL(string: self.docs?.cancellationLink ?? "www.cerebruminfotech.com")
                                           self.title = "ORDER CANCEL POLICY"
                                          // let url = URL(string: kAboutUs)
                                         myWebView.load(URLRequest(url: url!))
                                       }
        else
        {
            self.title = "PRIVACY POLICY"
            let url = URL(string: self.docs?.privacyLink ?? "www.cerebruminfotech.com")
           // myWebView.load(URLRequest(url: url!))
            myWebView.load(URLRequest(url: url!))
        }
        
        
//              let url = URL(string: "https://www.cerebruminfotech.com")
//              if(self.approach == "terms")
//              {
//                  self.title = "TERMS & CONDITIONS"
//                 // let url = URL(string: kTermsConditions)
//                myWebView.load(URLRequest(url: url!))
//              }
//              else if(self.approach == "aboutUs")
//              {
//                  self.title = "ABOUT US"
//                 // let url = URL(string: kAboutUs)
//                myWebView.load(URLRequest(url: url!))
//              }
//
//                else if(self.approach == "order")
//                           {
//                               self.title = "ORDER CANCEL POLICY"
//                              // let url = URL(string: kAboutUs)
//                             myWebView.load(URLRequest(url: url!))
//                           }
//              else
//              {
//                  self.title = "PRIVACY POLICY"
//                 // let url = URL(string: kPrivacy)
//                myWebView.load(URLRequest(url: url!))
//              }
              
    }
    
    @IBAction func movBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
    func getFAQList()
    {
        WebService.Shared.GetApi(url: APIAddress.GET_DOCUMENTS
            , Target: self, showLoader: true, completionResponse: { response in
                Commands.println(object: response)
                
                do
                {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(documentsResult.self, from: jsonData)
                    self.docs = model.body
                    self.loadWebView()
                }
                catch
                {
                    self.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
                }
                
        }, completionnilResponse: {(error) in
            self.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
}
