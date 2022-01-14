//

//

import Foundation
import UIKit

extension AddOrderRatings
{
    
    func getServiceList(orderID:String)
    {
        let url = APIAddress.GET_ORDER_SERVICES + "/\(orderID)"
        WebService.Shared.GetApi(url: url , Target: self, showLoader: true, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.arrayItems = NSMutableArray()
                    guard let data = responseData.value(forKey: "body")as? NSDictionary else {return}
                    guard let services = data.value(forKey: "suborders")as? NSArray else {return}
                    guard let restaurant = data.value(forKey: "company")as? NSDictionary else {return}
                    self.vendorID = data.value(forKey: "companyId")as? String ?? ""
                    self.restaurantData = restaurant
                  //  let orderid = responseData.value(forKey: "id")as? String ?? ""
                    
                    if (services.count > 0)
                    {
                        for i in 0...services.count-1
                        {
                            let servcObj = services.object(at: i)as? NSDictionary
                            let objNew = servcObj?.value(forKey: "service") as? NSDictionary
                            self.arrayItems.add(objNew ?? NSDictionary())
                        }
                        
                        self.handleTableHeight()
                        self.setData()
                        self.tblView.animateReload()
                    }
                }
                else
                {
                    self.showToastSwift(alrtType: .error, msg: msg, title: "")
                }
            }
            else
            {
                self.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
                self.nothingFound()
            }
            
        }, completionnilResponse: {(error) in
            self.nothingFound()
            self.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
    
    func nothingFound()
    {
        
    }
    
    func handleTableHeight()
    {
        self.tblHeight.constant = CGFloat(self.arrayItems.count*90)
        self.viewDidLayoutSubviews()
    }
    
    func setData()
    {
        self.lblVendorName.text = self.restaurantData.value(forKey: "companyName")as? String ?? ""
        let img = self.restaurantData.value(forKey: "logo1") as? String ?? ""
        self.ivVendor.setImage(with: img, placeholder: kplaceholderImage)
        self.ivVendor.CornerRadius(radius: 10.0)
    }
    
    func setProfileData()
    {
        self.lblVendorName.text = self.rstrntName
        let img = self.rstrntImage
        self.ivVendor.setImage(with: img, placeholder: kplaceholderImage)
        self.ivVendor.CornerRadius(radius: 10.0)
        
        self.VendorRate.rating = Double(self.rstrntDetailJson?.rating ?? "0.0")!
        
        self.rateViewValueMoney.rating = Double(self.rstrntDetailJson?.foodQuantity ?? "0.0")!
        self.rateViewPackage.rating = Double(self.rstrntDetailJson?.packingPres ?? "0.0")!
        self.rateViewQuality.rating = Double(self.rstrntDetailJson?.foodQuality ?? "0.0")!
        
        self.txtView.text = self.rstrntDetailJson?.review ?? ""
    }
    
    func hideOrderItemsView()
    {
        self.itemViewHeight.constant = 0
        self.rstrntViewTop.constant = -170
        self.lblItemHeader.isHidden = true
        self.tblView.isHidden = true
        self.viewDidLayoutSubviews()
    }
}


extension AddOrderRatings:UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.arrayGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellClassGallery", for: indexPath) as! cellClassGallery
        
        let dic = self.arrayGallery.object(at: indexPath.row) as! NSDictionary
        
        let dummy = dic.value(forKey: "dummy")as! Int
        if (dummy == 1)
        {
            cell.collGallery.backgroundColor = kpinkTheme
            cell.lblAdd.isHidden = false
            cell.btnDelete.isHidden = true
            cell.collGallery.image = nil
        }
        else
        {
            cell.collGallery.backgroundColor = UIColor.clear
            cell.collGallery.image = dic.value(forKey: "data")as? UIImage
            cell.lblAdd.isHidden = true
            cell.btnDelete.isHidden = false
        }
        
        cell.collGallery.CornerRadius(radius: 15)
        cell.collGallery.layer.borderColor = kpurpleTheme.cgColor
        cell.collGallery.layer.borderWidth = 0.5
        cell.btnDelete.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dic = self.arrayGallery.object(at: indexPath.row) as! NSDictionary
        
        let dummy = dic.value(forKey: "dummy")as! Int
        if (dummy == 1)
        {
            if (self.arrayGallery.count > 4)
            {
                self.showToastSwift(alrtType: .statusOrange, msg: "You can not add more than 4 images", title: "")
            }
            else
            {
                selectedPicker = ImagePickers.gallery
                OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
            }
        }
        else
        {
            
        }
    }
    
}

extension AddOrderRatings : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
}




extension AddOrderRatings : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrayItems.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderItems", for: indexPath) as! cellOrderItems
        cell.selectionStyle = .none

        let dic = self.arrayItems.object(at: indexPath.row) as? NSDictionary
        
        cell.lblPrice.text = "\(AppDefaults.shared.currency)\(dic?.value(forKey: "price") as? Int ?? 0)"
        cell.lblName.text = dic?.value(forKey: "name") as? String ?? ""
        let img = dic?.value(forKey: "thumbnail") as? String ?? ""
        cell.ivVendor.setImage(with: img, placeholder: kplaceholderImage)
        cell.ivVendor.CornerRadius(radius: 10.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}


//MARK:- UIImagePickerDelegate
extension AddOrderRatings: UIImagePickerDelegate
{
    func SelectedMedia(image: UIImage?, imageURL: URL?, videoURL: URL?)
    {
        switch selectedPicker
        {
        case .gallery:
            
            let dic = NSMutableDictionary()
            dic.setValue(image, forKey: "data")
            dic.setValue(imageURL, forKey: "url")
            dic.setValue(0, forKey: "dummy")
            
            self.arrayGallery.add(dic)
            self.collGallery.reloadData()
            
        default: break
            
        }
    }
    
    func selectedImageUrl(url: URL)
    {
        
    }
    
    func cancelSelectionOfImg()
    {
        
    }
}
