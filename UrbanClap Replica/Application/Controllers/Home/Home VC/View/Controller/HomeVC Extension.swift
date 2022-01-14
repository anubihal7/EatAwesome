//
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == self.bannerCollection
        {
            return compnyBanners?.count ?? 0
        }
        else if collectionView == self.catCollection
        {
            if isSkeleton_Cats == true
            {
                return skeletonItems_Cats
            }
            return trendingServicesList?.count ?? 0
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell = UICollectionViewCell()
        
        //BANNERS
        if collectionView == self.bannerCollection
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_banners, for: indexPath)as! CellClass_CompnyBanners
            
            if let data = compnyBanners?[indexPath.row]
            {
                cellnew.hideAnimation()
                let img = data.url ?? ""
                cellnew.ivBanners.setImage(with: img, placeholder: kplaceholderImage)
                cellnew.ivBanners.CornerRadius(radius: 15.0)
            }
            else
            {
                cellnew.showAnimation()
            }
            
            cell = cellnew
        }
            
            //MAIN CATEGORIES
        else if collectionView == self.catCollection
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_cats, for: indexPath)as! CellClass_Categories
            
            if let data = trendingServicesList?[indexPath.row]
            {
                cellnew.hideAnimation()
                let img = data.mediaHttpUrl ?? ""
                cellnew.ivCat.setImage(with: img, placeholder: kplaceholderImage)
                cellnew.ivCat.CornerRadius(radius: 15.0)
                
                if(trendingServicesList?.count ?? 0 > 3)
                {
                    if (indexPath.row == (trendingServicesList?.count ?? 0)-1 )
                    {
                        cellnew.lblViewAll.isHidden = false
                    }
                    else
                    {
                        cellnew.lblViewAll.isHidden = true
                    }
                }
                else
                {
                    cellnew.lblViewAll.isHidden = true
                }
            }
            else
            {
                cellnew.showAnimation()
            }
            
            cell = cellnew
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(collectionView == self.catCollection)
        {
            let controller = Navigation.GetInstance(of: .GalleryVC) as! GalleryVC
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            controller.compnyID = self.comId ?? ""
            controller.index = indexPath.row
            self.present(controller, animated: true, completion: nil)
        }
        //  let controller = Navigation.GetInstance(of: .SubCatsVC)as! SubCatsVC
        //  self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
}

extension HomeVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if (collectionView == self.bannerCollection)
        {
            let collectionViewWidth = self.bannerCollection.frame.size.width
            return CGSize(width: collectionViewWidth-5, height: 175)
        }
        else
        {
            // let collectionViewWidth = self.catCollection.frame.size.width
            // return CGSize(width: collectionViewWidth/4, height: collectionViewWidth/3)
            return CGSize(width: 80, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
}

extension HomeVC : HomeCatVCDelegate
{
    func getData(banners: [Offer], services: [subcats], trendingService: [galleryDec],compBanners:[compnyBanners])
    {
        
        DispatchQueue.main.async {
            
            self.bannersList = banners
            self.servicesList = services
            self.trendingServicesList = trendingService
            
            self.str_rating1 = self.profileDetails?.foodQualityRating ?? "0"
            self.str_rating2 = self.profileDetails?.packingPresRating ?? "0"
            self.str_rating3 = self.profileDetails?.foodQuantityRating ?? "0"
            
           
            
            //
            //Company Banners
            if (compBanners.count > 0)
            {
                self.compnyBanners = compBanners
                self.isSkeleton_Offers = false
                self.bannerCollection.setEmptyMessage("")
                self.bannerCollection.delegate = self
                self.bannerCollection.dataSource = self
                self.bannerCollection.reloadData()
                // self.adjustViewHeights(heightLayout: self.BannerView_Height, constantValue: 190)
            }
            else
            {
                self.isSkeleton_Offers = true
                self.bannerCollection.delegate = self
                self.bannerCollection.dataSource = self
                self.bannerCollection.reloadData()
                // self.adjustViewHeights(heightLayout: self.BannerView_Height, constantValue: 0)
            }
            
            
            //Gallery
            if (self.trendingServicesList?.count ?? 0 > 0)
            {
                self.isSkeleton_Cats = false
                self.catCollection.setEmptyMessage("")
                self.catCollection.delegate = self
                self.catCollection.dataSource = self
                self.catCollection.reloadData()
            }
            else
            {
                self.isSkeleton_Cats = true
                self.skeletonItems_Cats = 0
                self.catCollection.setEmptyMessage(kDataNothingTOSHOW)
                self.catCollection.delegate = self
                self.catCollection.dataSource = self
                self.catCollection.reloadData()
            }
            
            
            
            let img = self.profileDetails?.logo1 ?? ""
            self.ivVendor.setImage(with: img, placeholder: kplaceholderImage)
            self.ivVendor.CornerRadius(radius: 20)
            self.ivAlpha.CornerRadius(radius: 20)
            self.lblPhone.text = "\(self.profileDetails?.countryCode ?? "")-\(self.profileDetails?.phoneNumber ?? "")"
            self.lblRstrntName.text = self.profileDetails?.companyName ?? ""
            self.lblAbtTitle.text = "About \(self.profileDetails?.companyName ?? "")"
            
            
            let rateD = Double(self.profileDetails?.rating ?? "0.0") ?? 0.0
            let rate = CGFloat(rateD)
            self.lblRatings.text = "\(rate.cleanValue)"
            
            self.lblLocation.text = self.profileDetails?.address1 ?? ""
            self.lblTimings.text = "\(self.profileDetails?.startTime ?? "N/A") To \(self.profileDetails?.endTime ?? "N/A")"
            
            self.addPinOnMap(lat: self.profileDetails?.latitude ?? 0.0, lng: self.profileDetails?.longitude ?? 0.0)
            
            let abt = self.profileDetails?.document?.aboutUs ?? ""
            let data = Data(abt.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            {
                self.lblAbtDesc.attributedText = attributedString
            }
            else
            {
                self.lblAbtDesc.text = kDataNothingTOSHOW
            }
        }
    }
    
    func nothingFound()
    {
        isSkeleton_Cats = false
        isSkeleton_Trending = false
        isSkeleton_Offers = false
        
        self.catCollection.setEmptyMessage(kDataNothingTOSHOW)
        
        self.catCollection.reloadData()
        
        // self.adjustViewHeights(heightLayout: self.BannerView_Height, constantValue: 0)
        
    }
    
    
    func adjustViewHeights(heightLayout:NSLayoutConstraint,constantValue:CGFloat)
    {
        heightLayout.constant = constantValue
        self.view.layoutSubviews()
    }
    
    
    func setUI()
    {
        self.DetailViewHeight.constant = 190
        self.lblAbtDesc.isHidden = true
        self.btnOrder.backgroundColor = kpurpleTheme
        self.btnRate.backgroundColor = korangeTheme
        
        self.btnOrder.updateLayerProperties()
        self.btnRate.updateLayerProperties()
        
        self.mapVIEW.layer.cornerRadius = 20
        self.mapVIEW.layer.masksToBounds = true
    }
    
    func addPinOnMap(lat:Double,lng:Double)
    {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        DispatchQueue.main.async
            {
                self.mapVIEW.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.title = self.lblRstrntName.text
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                self.mapVIEW.addAnnotation(annotation)
        }
    }
}


//extension HomeVC : AutoCompleteAddress_Protocol 
//{
//
//    func getAddressFromAPI(address: String)
//    {
//        Commands.println(object: address)
//    }
//
//    func foundError(err:String)
//    {
//       // self.showAlertMessage(titleStr: "Error in getting address", messageStr: err)
//    }
//}






// func activateGoogeAutocomplete()
// {
//     self.GooglePlaceDelegate = AutoCompleteAddress_Google()
//     self.GooglePlaceDelegate?.initializeAndGetAddress(dlgate: self,contrllr:self)
// }
extension String
{
    func deletingPrefix(_ prefix: String) -> String
    {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
