//

//

import UIKit
import Cosmos

class OrderServiceListVC: UIViewController
{
    
    @IBOutlet var tableViewServices: UITableView!
    
    let cellID = "CellClass_OrderServices"
    var viewModel:OrderServices_ViewModel?
    
    var selectesRow = -1
    var isSkeleton = true
    var skeletonItems = 5
    var orderID = ""
    var apiDATA = NSArray()
    var driverDATA = NSMutableDictionary()
    
    @IBOutlet var btnSubmit: CustomButton!
    var uploadArray = NSMutableArray()
    var uploadArrayDriver = NSMutableArray()
    
    var isDriverRatings = false
    var userGivedRatingToDriver = false
    var driverAvailable = false
    // var uploadArray = [String:Any])
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.btnSubmit.backgroundColor = Appcolor.get_category_theme()
        self.btnSubmit.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        self.btnSubmit.isHidden = true
        
        self.viewModel = OrderServices_ViewModel.init(Delegate: self, viewMain: self, view: self)
        self.viewModel?.getServiceList(orderID:orderID)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionMoveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    func update_UploadArray(dicnry:NSMutableDictionary)
    {
        if(self.isDriverRatings == false)
        {
            let serviceID = dicnry.value(forKey: "id")as? String ?? ""
            let Rating = dicnry.value(forKey: "rating")as? Double ?? 0.0
            let Review = dicnry.value(forKey: "description")as? String ?? ""
            
            var objExist = false
            
            if self.uploadArray.count > 0
            {
                for i in 0...self.uploadArray.count-1
                {
                    let obj = self.uploadArray.object(at: i)as? NSMutableDictionary
                    let sID = obj?.value(forKey: "id")as? String ?? ""
                    
                    if(sID == serviceID)
                    {
                        objExist = true
                        
                        let dic = self.addValuesinAray(sid:serviceID,rating:Rating,review:Review, driver: false)
                        self.uploadArray.replaceObject(at: i, with: dic)
                        break
                    }
                }
                
                if (objExist == false)
                {
                    let dic = self.addValuesinAray(sid:serviceID,rating:Rating,review:Review, driver: false)
                    self.uploadArray.add(dic)
                    self.btnSubmit.isHidden = false
                }
            }
            else
            {
                let dic = self.addValuesinAray(sid:serviceID,rating:Rating,review:Review, driver: false)
                self.uploadArray.add(dic)
                self.btnSubmit.isHidden = false
            }
            
            self.tableViewServices.animateReload()
        }
        
    }
    
    func update_UploadArrayDriver()
    {
        if(self.userGivedRatingToDriver == true)
        {
            self.uploadArrayDriver = NSMutableArray()
            let driverData = self.apiDATA.lastObject as? NSDictionary
            let serviceID = driverData?.value(forKey: "id")as? String ?? ""
            let Rating = driverData?.value(forKey: "rating")as? Double ?? 0.0
            let Review = driverData?.value(forKey: "description")as? String ?? ""
            
            var objExist = false
            
            if self.uploadArrayDriver.count > 0
            {
                for i in 0...self.uploadArrayDriver.count-1
                {
                    let obj = self.uploadArrayDriver.object(at: i)as? NSMutableDictionary
                    let sID = obj?.value(forKey: "id")as? String ?? ""
                    
                    if(sID == serviceID)
                    {
                        objExist = true
                        
                        let dic = self.addValuesinAray(sid:serviceID,rating:Rating,review:Review, driver: true)
                        self.uploadArrayDriver.replaceObject(at: i, with: dic)
                        break
                    }
                }
                
                if (objExist == false)
                {
                    let dic = self.addValuesinAray(sid:serviceID,rating:Rating,review:Review, driver: true)
                    self.uploadArrayDriver.add(dic)
                    self.btnSubmit.isHidden = false
                }
            }
            else
            {
                let dic = self.addValuesinAray(sid:serviceID,rating:Rating,review:Review, driver: true)
                self.uploadArrayDriver.add(dic)
                self.btnSubmit.isHidden = false
            }
        }
    }
    
    func addValuesinAray(sid:String,rating:Double,review:String,driver:Bool) -> NSMutableDictionary
    {
        let dic = NSMutableDictionary()
        
        if(driver == true)
        {
            dic.setValue(sid, forKey: "empId")
            dic.setValue(rating, forKey: "rating")
            dic.setValue(review, forKey: "review")
        }
        else
        {
            dic.setValue(sid, forKey: "id")
            dic.setValue(sid, forKey: "serviceId")
            dic.setValue(rating, forKey: "rating")
            dic.setValue(review, forKey: "review")
        }
        
        return dic
    }
    
    @IBAction func actionSubmitRatings(_ sender: Any)
    {
        if(self.uploadArray.count > 0)
        {
            var fArray = [NSMutableDictionary]()
            
            for i in 0...self.uploadArray.count-1
            {
                
                let obj = self.uploadArray.object(at: i)as? NSMutableDictionary
                let sID = obj?.value(forKey: "id")as? String ?? ""
                let Rating = obj?.value(forKey: "rating")as? Double ?? 0.0
                let Review = obj?.value(forKey: "review")as? String ?? ""
                
                let dic = NSMutableDictionary()
                
                dic.setValue(sID, forKey: "serviceId")
                dic.setValue(Rating, forKey: "rating")
                dic.setValue(Review, forKey: "review")
                
                
                fArray.append(dic)
                
            }
            
            
            let driverInfo = self.uploadArrayDriver.object(at: 0) as? NSMutableDictionary ?? NSMutableDictionary()
            self.viewModel?.callAPI_ADD_REVIEWS(orderId:self.orderID,ratingArray:fArray,driverArray:[driverInfo])
        }
    }
    
    
    
}


extension OrderServiceListVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (isSkeleton == false)
        {
            return self.apiDATA.count
        }
        return skeletonItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CellClass_OrderServices
        
        
        if (isSkeleton == false)
        {
            
            if let data =  self.apiDATA[indexPath.row] as? NSDictionary
            {
                cell.hideAnimation()
                let isRated = data.value(forKey: "rated")as? String ?? "0"
                
                if(self.driverAvailable == true)
                {
                    if(indexPath.row == self.apiDATA.count-1)
                    {
                        //adding driver data on last cell on table view
                        if(data.count > 0)
                        {
                            let name = "\(data.value(forKey: "firstName")as? String ?? "") \(data.value(forKey: "lastName")as? String ?? "")"
                            cell.lblName.text = name
                            cell.rateView.rating = data.value(forKey: "rating")as? Double ?? 0.0
                            let img = data.value(forKey: "image")as? String ?? ""
                            cell.ivService.setImage(with: img, placeholder: kplaceholderImage)
                            cell.ivService.CornerRadius(radius: 10.0)
                            cell.lblDesc.text = data.value(forKey: "description")as? String ?? "No reviews yet"
                            if (isRated == "0")
                            {
                                self.userGivedRatingToDriver = false
                            }
                            else
                            {
                                self.userGivedRatingToDriver = true
                                self.update_UploadArrayDriver()
                            }
                        }
                    }
                    else
                    {
                        cell = self.setData(cell:cell,data:data)
                    }
                }
                else
                {
                    cell = self.setData(cell:cell,data:data)
                }
            }
            else
            {
                cell.showAnimation()
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(self.driverAvailable == true)
        {
            if(indexPath.row == self.apiDATA.count-1)
            {
                self.isDriverRatings = true
            }
            else
            {
                self.isDriverRatings = false
            }
        }
        else
        {
            self.isDriverRatings = false
        }
        
        let dicnry = NSMutableDictionary(dictionary: self.apiDATA[indexPath.row] as? NSDictionary ?? NSDictionary())
        self.selectesRow = indexPath.row
        let controller = Navigation.GetInstance(of: .AddRatingsVC)as! AddRatingsVC
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegateAddRatings = self
        controller.data = dicnry
        controller.isDriver = self.isDriverRatings
        present(controller, animated: true, completion: nil)
    }
    
    
    func setData(cell:CellClass_OrderServices,data:NSDictionary) -> CellClass_OrderServices
    {
        let isRated = data.value(forKey: "rated")as? String ?? "0"
        
        cell.lblName.text = data.value(forKey: "name")as? String ?? ""
        cell.rateView.rating = data.value(forKey: "rating")as? Double ?? 0.0
        let img = data.value(forKey: "icon")as? String ?? ""
        cell.ivService.setImage(with: img, placeholder: kplaceholderImage)
        cell.ivService.CornerRadius(radius: 10.0)
        cell.lblDesc.text = data.value(forKey: "description")as? String ?? "No reviews yet"
        
        
        if (isRated == "0")
        {
            cell.viewTapToRate.backgroundColor = Appcolor.kTextColorWhite
            cell.lblRated.textColor = Appcolor.kTextColorGrayDark
            cell.lblRated.text = "Rate This \(DynamicTextHandler.RATE_ITEM)"
        }
        else
        {
            cell.viewTapToRate.backgroundColor = Appcolor.get_category_theme()
            cell.lblRated.textColor = Appcolor.kTextColorWhite
            cell.lblRated.text = "Rated Now"
        }
        
        return cell
    }
}

extension OrderServiceListVC : AddRatingVC_Delegate
{
    func ratingFound(updateData: NSMutableDictionary)
    {
        let arr = NSMutableArray(array: self.apiDATA)
        arr.replaceObject(at: self.selectesRow, with: updateData)
        self.apiDATA = NSArray(array: arr)
        self.tableViewServices.animateReload()
        self.update_UploadArray(dicnry: updateData)
    }
}


extension OrderServiceListVC : OrderServicesVCDelegate
{
    func getData(model: NSArray, orderID: String,hasDriver:Bool)
    {
        self.driverAvailable = hasDriver
        if (model.count > 0)
        {
            isSkeleton = false
            self.apiDATA = model
            
            //            if(driverDetail.count > 0)
            //            {
            //                self.driverDATA = driverDetail as? NSMutableDictionary ?? NSMutableDictionary()
            //            }
            
            self.tableViewServices.animateReload()
            self.tableViewServices.restore()
        }
        else
        {
            self.nothingFound()
        }
    }
    
    func nothingFound()
    {
        if (self.apiDATA.count == 0)
        {
            self.apiDATA = NSArray()
           // self.tableViewServices.setEmptyMessage(kDataNothingTOSHOW)
            self.tableViewServices.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
            self.isSkeleton = false
            self.tableViewServices.animateReload()
        }
    }
}
