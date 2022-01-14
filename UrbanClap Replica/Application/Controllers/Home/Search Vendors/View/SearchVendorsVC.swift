
//

import UIKit
import Cosmos

class SearchVendorsVC: UIViewController,UISearchBarDelegate
{
    
    @IBOutlet var segmentType: UISegmentedControl!
    @IBOutlet var segmentDlvryType: UISegmentedControl!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblView: UITableView!
    var searchType = "food"
    var pageCount = 1
    var apiDATA: [Service2]? = nil
    var apiDATA_Vendor: [ServiceVendors]? = nil
    var dlvryType = 0
    var isShown = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.segmentType.backgroundColor = Appcolor.get_category_theme()
        
        self.segmentDlvryType.backgroundColor = Appcolor.get_category_theme()
        
        searchBar.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        // self.searchBar.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if(isShown == false)
        {
            isShown = true
            self.tblView.setAnimatingImage(fileName: kLottieSearch ,msg :"")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func movebAck(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func chooseType(_ sender: UISegmentedControl)
    {
        if(sender.selectedSegmentIndex == 0)
        {
            searchType = "restaurants"
        }
        else
        {
            searchType = "food"
        }
        
        if(self.searchBar.text?.count ?? 0 > 0)
        {
            self.apiDATA = nil
            self.apiDATA_Vendor = nil
            self.pageCount = 1
            self.tblView.animateReload()
            self.tblView.restore()
            self.callAPI()
        }
    }
    
    @IBAction func chooseDeliveryType(_ sender: UISegmentedControl)
    {
        if(sender.selectedSegmentIndex == 0)
        {
            dlvryType = 0
        }
        else
        {
            dlvryType = 1
        }
        
        if(self.searchBar.text?.count ?? 0 > 0)
        {
            self.apiDATA = nil
            self.apiDATA_Vendor = nil
            self.pageCount = 1
            self.tblView.animateReload()
            self.tblView.restore()
            self.callAPI()
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.text = ""
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        if(self.searchBar.text?.count == 0)
        {
            self.showToastSwift(alrtType: .statusOrange, msg: "Type your favorite dish name or restaurant", title: "")
        }
        else
        {
            self.apiDATA = nil
            self.apiDATA_Vendor = nil
            self.pageCount = 1
            self.tblView.animateReload()
            self.tblView.restore()
            self.callAPI()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
    }
    
    
    @IBAction func actionTapOnCell(_ sender: UIButton)
    {
        if(self.apiDATA_Vendor?.count ?? 0 > 0)
        {
            let obj = self.apiDATA_Vendor![sender.tag]
            let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
            AppDefaults.shared.companyID = obj.id ?? ""
            controller.categoryID = mainID
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
    }
    
    
    @IBAction func actionTapOnCellDish(_ sender: UIButton)
    {
        if(self.apiDATA?.count ?? 0 > 0)
        {
            let obj = apiDATA?[sender.tag]
            let controller = Navigation.GetInstance(of: .ServiceDetailVC)as! ServiceDetailVC
            controller.catID = obj?.id ?? "0"
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
    }
    
    func callAPI()
    {
        self.view.endEditing(true)
        if(pageCount < 0)
        {
            pageCount = 0
        }
        let obj : [String:Any] = ["search":self.searchBar.text!,"type":searchType,"deliveryType":dlvryType,"page":pageCount,"limit":"20","lat":AppDefaults.shared.app_LATITUDE,"lng":AppDefaults.shared.app_LONGITUDE]
        
        WebService.Shared.PostApi(url: APIAddress.SEARCH, parameter: obj , Target: self, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                
                if (self.searchType == "food")
                {
                    let model = try JSONDecoder().decode(searchResults.self, from: jsonData)
                    if (self.apiDATA?.count == nil || self.apiDATA?.count == 0)
                    {
                        self.apiDATA = model.body.services
                    }
                    else
                    {
                        self.apiDATA = self.apiDATA! + model.body.services
                    }
                    
                    if(model.body.services.count == 0)
                    {
                        self.pageCount = self.pageCount-1
                    }
                    else
                    {
                        self.tblView.animateReload()
                        self.tblView.restore()
                    }
                }
                else
                {
                    let model = try JSONDecoder().decode(searchResultsVendors.self, from: jsonData)
                    if (self.apiDATA_Vendor?.count == nil || self.apiDATA_Vendor?.count == 0)
                    {
                        self.apiDATA_Vendor = model.body.services
                    }
                    else
                    {
                        self.apiDATA_Vendor = self.apiDATA_Vendor! + model.body.services
                    }
                    
                    if(model.body.services.count == 0)
                    {
                        self.pageCount = self.pageCount-1
                    }
                    else
                    {
                        self.tblView.animateReload()
                        self.tblView.restore()
                    }
                }
                
            }
            catch
            {
                self.tblView.animateReload()
                self.tblView.restore()
                self.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
        }, completionnilResponse: {(error) in
            self.tblView.animateReload()
            self.tblView.restore()
            self.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
    }
    
    
}

extension SearchVendorsVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (searchType == "food")
        {
            return self.apiDATA?.count ?? 0
        }
        else
        {
            return self.apiDATA_Vendor?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        
        if(searchType == "food")
        {
            let cellN = tableView.dequeueReusableCell(withIdentifier: "cellClassSearchDish", for: indexPath)as! cellClassSearchDish
            
            if let obj = apiDATA?[indexPath.row]
            {
                cellN.hideAnimation()
                
                cellN.btnTapOnCell.tag = indexPath.row
                let img = obj.thumbnail ?? ""
                cellN.ivDish.setImage(with: img, placeholder: kplaceholderImage)
                
                
                cellN.lblName.text! = obj.name ?? "N/A"
                cellN.lblDuration.text! = "Duration : \(obj.duration ?? "N/A")"
                cellN.lblRatingas.text = obj.company.rating ?? "0.0"
                
                cellN.lblVendorName.text = obj.company.companyName ?? "0.0"
                cellN.lblPrice.text = "\(AppDefaults.shared.currency)\(obj.price ?? 0)"
                
                
                cellN.ivDish.roundCornersTopLEFTBottomLEFT()
            }
            else
            {
                cellN.showAnimation()
            }
            
            
            cell = cellN
        }
        else
        {
            let cellN = tableView.dequeueReusableCell(withIdentifier: "TableVendors", for: indexPath)as! TableVendors
            
            let obj = self.apiDATA_Vendor?[indexPath.row]
            
            let img = obj?.logo1 ?? ""
            cellN.ivVendor.setImage(with: img, placeholder: kplaceholderImage)
            cellN.ivVendor.CornerRadius(radius: 15)
            
            
            cellN.lblName.text! = obj?.companyName ?? "N/A"
            cellN.lblPastOrders.text = ""
            // cellN.lblPastOrders.text = "Orders in past 24 hrs: \(obj?.totalOrders24 ?? "")"
            
            
            let rateD = Double(obj?.rating ?? "0.0") ?? 0.0
            let rate = CGFloat(rateD)
            cellN.lblRate.text = "\(Double(rate.cleanValue) ?? 0.0)"
            
            let distanec = CGFloat(obj?.distance ?? 0.0)
            let time = self.convertDistanceIntoMinuts(distance: distanec)
            cellN.lblTime.text = time
            
            let offer = obj?.coupan?.discount ?? "0"
            if(offer != "0")
            {
                cellN.lblOff.text = "\(offer)% off"
            }
            else
            {
                cellN.lblOff.text = ""
            }
            
            //            let txt = obj?.tags
            //            if(txt?.count ?? 0 > 0)
            //            {
            //                cellN.lblTags.text = txt?.joined(separator: ", #")
            //                cellN.lblTags.restartLabel()
            //            }
            //            else
            //            {
            //                cellN.lblTags.text = ""
            //            }
            
            cell = cellN
            
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if (searchType == "food")
        {
            if indexPath.row+1 == self.apiDATA?.count
            {
                pageCount = pageCount+1
                self.callAPI()
            }
        }
        else
        {
            if indexPath.row+1 == self.apiDATA_Vendor?.count
            {
                pageCount = pageCount+1
                self.callAPI()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (searchType == "food")
        {
            return 144.0
        }
        else
        {
            return 115.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(self.apiDATA_Vendor?.count ?? 0 > 0)
        {
            let obj = self.apiDATA_Vendor![indexPath.row]
            let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
            AppDefaults.shared.companyID = obj.id ?? ""
            controller.categoryID = mainID
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
    }
    
    
}

class cellClassSearchDish: UITableViewCell
{
    @IBOutlet var btnTapOnCell: UIButton!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblRatingas: UILabel!
    @IBOutlet var ivDish: UIImageView!
    @IBOutlet var ivVeg: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblVendorName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var viewRate: CosmosView!
    
    
    
    func hideAnimation()
    {
        [self.lblDuration,self.ivDish,lblDuration,lblName,lblVendorName,lblPrice].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.lblDuration,self.ivDish,lblDuration,lblName,lblVendorName,lblPrice].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }
    
}
