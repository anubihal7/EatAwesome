
//

import UIKit
import WebKit

class OpenPdfFileVC: UIViewController {
//MARK :- variables
    var pdffile:String?
    
    //MARK:- life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openWebView()
    }
    
    //MARK:- open WebView
    func openWebView()
    {
        if let fileUrl = pdffile
        {
        let url: URL! = URL(string: fileUrl)
        let webView = WKWebView(frame: CGRect(x:0,y:0,width:view.frame.size.width, height:view.frame.size.height))
      //  let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        //webView.addGestureRecognizer(tap)
        webView.load(URLRequest(url: url))
        view.addSubview(webView)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
