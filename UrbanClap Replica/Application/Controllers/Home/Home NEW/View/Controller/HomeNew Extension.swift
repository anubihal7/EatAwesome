
//

import Foundation
import UIKit
import Drift

extension HomeNewVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (collectionView == self.SpclEventsCollection)
        {
            if isSkeleton_Events == true
            {
                return skeletonItems
            }
            return self.eventsDATA?.count ?? 0
        }
        else if collectionView == self.bannerCollection
        {
            return self.restOffersDATA?.count ?? 0
        }
        else if collectionView == self.topPickesCollection
        {
            if isSkeleton_TopPicks == true
            {
                return skeletonItems
            }
            return self.topPicksDATA?.count ?? 0
        }
        else if collectionView == self.trendingCollection
        {
            if isSkeleton_Trending == true
            {
                return skeletonItems
            }
            return self.trendingDATA?.count ?? 0
        }
        else if collectionView == self.offerCollection
        {
            if isSkeleton_Offer == true
            {
                return skeletonItems
            }
            return self.offersDATA?.count ?? 0
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell = UICollectionViewCell()
        
        //EVENTS
        if (collectionView == self.SpclEventsCollection)
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_Events, for: indexPath)as! EventsCollectionCell
            
            if let data = self.eventsDATA?[indexPath.row]
            {
                cellnew.hideAnimation()
                let imgPath = data.thumbnail ?? ""
                cellnew.ivBannerBG.setImage(with: imgPath, placeholder: kplaceholderFood)
               // cellnew.lblEventName.text = data.dealName ?? ""
               // cellnew.lblDesc.text = "Use code \(data.code ?? "") to get \(data.discount ?? "")% off"
            }
            else
            {
                cellnew.showAnimation()
            }
            
            cell = cellnew
        }
        
        //BANNERS
        if collectionView == self.bannerCollection
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_Banners, for: indexPath)as! BannersCollectionCell
            
            if let data = self.restOffersDATA?[indexPath.row]
            {
                cellnew.hideAnimation()
                let imgPath = data.icon ?? ""
                cellnew.ivBanners.setImage(with: imgPath, placeholder: kplaceholderFood)
                // cellnew.ivBanners.roundCornersTopLEFTopRIGHT()
            }
            else
            {
                cellnew.showAnimation()
            }
            
            cell = cellnew
        }
            
            //TOP PICKS FOR YOU
        else if collectionView == self.topPickesCollection
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_TopPicks, for: indexPath)as! TopPicksCollcnCell
            
            if let data = self.topPicksDATA?[indexPath.row]
            {
                cellnew.hideAnimation()
                cellnew.btnTapOnCell.tag = indexPath.row
                let imgPath = data.icon ?? ""
                cellnew.ivDish.setImage(with: imgPath, placeholder: kplaceholderFood)
               // cellnew.ivDish.roundCornersTopLEFTopRIGHT()
                cellnew.lblName.text = data.name ?? "N/A"
            }
            else
            {
                cellnew.showAnimation()
            }
            
            cell = cellnew
        }
            
            //TRENDING SERVICES
        else if collectionView == self.trendingCollection
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_Trending, for: indexPath)as! TrendingCollcnCell
            
            
            if let data = self.trendingDATA?[indexPath.row]
            {
                cellnew.hideAnimation()
                let imgPath = data.icon ?? ""
                cellnew.iv.setImage(with: imgPath, placeholder: kplaceholderFood)
                // cellnew.iv.roundCornersTopLEFTopRIGHT()
                cellnew.lblName.text = data.name ?? "N/A"
                
            }
            else
            {
                cellnew.showAnimation()
            }
            
            cell = cellnew
        }
            
            //OFFERS
        else if collectionView == self.offerCollection
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_offer, for: indexPath)as! OffersCollecnCell
            
            
            if let data = self.offersDATA?[indexPath.row]
            {
                cellnew.hideAnimation()
                cellnew.btnTapOnCell.tag = indexPath.row
                let imgPath = data.icon ?? ""
                cellnew.ivOffer.setImage(with: imgPath, placeholder: kplaceholderFood)
                
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
        //  let controller = Navigation.GetInstance(of: .SubCatsVC)as! SubCatsVC
        //  self.push_To_Controller(from_controller: self, to_Controller: controller)
        
        
        
        if(collectionView == self.bannerCollection)
        {
            if(self.restOffersDATA?.count ?? 0 > 0)
            {
                let obj = self.restOffersDATA?[indexPath.row]
                let controller = Navigation.GetInstance(of: .SeeAllRestaurantsVC)as! SeeAllRestaurantsVC
                controller.discount = obj?.discount ?? ""
                controller.bannersDATA = [obj!]
                self.push_To_Controller(from_controller: self, to_Controller: controller)
            }
            
        }
        
    }
    
    
    
    func checkVendorIsSameForCartVendoer(cmpnyID:String)
    {
        let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
        if (self.cartVendorID.count == 0)
        {
            AppDefaults.shared.companyID = cmpnyID
            controller.categoryID = mainID
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
        else
        {
            if(self.cartVendorID == cmpnyID)
            {
                AppDefaults.shared.companyID = cmpnyID
                controller.categoryID = mainID
                self.push_To_Controller(from_controller: self, to_Controller: controller)
            }
            else
            {
                self.AlertMessageWithOkCancelAction(titleStr: "Items already in cart", messageStr: "Your cart contains items from a different restaurant. Would you like to reset your cart before browsing this restaurant?", Target: self)
                { (actn) in
                    if (actn == KYes)
                    {
                        self.viewModel?.clearCart(compID:cmpnyID)
                    }
                }
            }
        }
    }
    
    func setTableLayoutVendors()
    {
        let height = 154*(self.vendorsDATA?.count ?? 0)
        self.VendorTBL_Height.constant = CGFloat(height)
        vendorView_Height.constant = CGFloat(height+72)
        self.view.setNeedsLayout()
    }
    
    func setTableLayoutBestSellar()
    {
        let height = 154*(self.bestSellerDATA?.count ?? 0)
        self.bestSellerTBL_Height.constant = CGFloat(height)
        bestSellerView_Height.constant = CGFloat(height)
        self.view.setNeedsLayout()
    }
    
    func checkDeliveryTypeOption()
    {
        if(AppDefaults.shared.deliveryType == "delivery")
        {
            segmentControl.selectedSegmentIndex = 0
            self.newSegmntBtn.curState = .R
        }
        else
        {
            segmentControl.selectedSegmentIndex = 1
            self.newSegmntBtn.curState = .L
        }
    }
    
    func setUI()
    {
        self.btnViewAll.backgroundColor = Appcolor.get_category_theme()
        self.btnViewAll.updateLayerProperties()
        self.rcntOrderBlurView.layer.cornerRadius = 10
        self.rcntOrderBlurView.layer.masksToBounds = true
       // self.bannerViewCustom.backgroundColor = Appcolor.get_category_theme()
        
        if (AppDefaults.shared.isVegOnly == true)
        {
            self.btnSwitch.setOn(true, animated: true)
            self.vegOnly = "0"
        }
        else
        {
            self.btnSwitch.setOn(false, animated: true)
            self.vegOnly = ""
        }
        
        if(AppDefaults.shared.driftLogin == false)
        {
            Drift.setup(kDrift_ClientToken)
            Drift.registerUser(AppDefaults.shared.userID, email: AppDefaults.shared.userEmail, userJwt: AppDefaults.shared.userName)
            AppDefaults.shared.driftLogin = true
        }
    }
    
    func HandleRecentOrderBanner()
    {
        if(self.recentORDER == nil)
        {
            UIView.transition(with: self.bannerViewCustom, duration: 0.8,
                options: .transitionCrossDissolve,
                animations: {
                    self.bannerViewCustom.isHidden = true
            })
        }
        else
        {
            self.lblLogo.text = "Your order has \(self.recentORDER?.orderStatus.statusName ?? "N/A")"
            self.lblOrderStatus.text = "Sit back & relax as your order has \(self.recentORDER?.orderStatus.statusName ?? "N/A")"
            self.lblOrderAmout.text = "Amount: \(AppDefaults.shared.currency)\(self.recentORDER?.totalOrderPrice ?? "N/A")"
            self.lblOrderNumber.text = "Order No: \(self.recentORDER?.orderNo ?? "N/A")"
            self.animateRecentOrder()
            
            UIView.transition(with: self.bannerViewCustom, duration: 0.4,
                options: .transitionFlipFromBottom,
                animations: {
                    self.bannerViewCustom.isHidden = false
            })
        }
        
        self.viewDidLayoutSubviews()
    }
    
    func animateRecentOrder()
    {
        anim.frame = self.animViewRecentOrder.frame
        anim.contentMode = .scaleAspectFit
        anim.loopMode = .loop
        self.animViewRecentOrder.addSubview(anim)
        anim.play()
    }
    
    func disposeAnimView()
    {
       // self.bannerViewCustom = nil
      //  self.animViewRecentOrder = nil
    }
}

extension HomeNewVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if (collectionView == self.SpclEventsCollection)
        {
            let collectionViewWidth = self.SpclEventsCollection.frame.size.width
            return CGSize(width: collectionViewWidth, height: 190)
        }
        else if (collectionView == self.bannerCollection)
        {
            //let collectionViewWidth = self.bannerCollection.frame.size.width
            return CGSize(width: 250, height: 120)
        }
        else if (collectionView == self.topPickesCollection)
        {
            return CGSize(width: 140, height: 140)
        }
        else if (collectionView == self.trendingCollection)
        {
            let collectionViewWidth = self.bannerCollection.frame.size.width
            return CGSize(width: collectionViewWidth, height: 227)
        }
        else
        {
            let collectionViewWidth = self.view.frame.size.width
            return CGSize(width: collectionViewWidth-10, height: 175)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
}

extension HomeNewVC : HomeNewVCDelegate
{
    func getData(restOffers: [RESTOfferDEC], topPicks: [TopPickNEW], trendindServices: [TrendingNEW], offers: [OfferNEW], allData: BodyNEW, selected : [TopPickNEW]) {
        
        DispatchQueue.main.async
            {
               // self.eventsDATA = events
                self.restOffersDATA = restOffers
                self.topPicksDATA = topPicks
                self.vendorsDATA = [BestSellerNEW]()
                
                self.trendingDATA = trendindServices
                self.bestSellerDATA = [BestSellerNEW]()
                self.offersDATA = offers
                
                self.cartVendorID = "" //allData.cartCompanyType ?? ""
                AppDefaults.shared.CartCompanyID = self.cartVendorID
                
                //EVENTS
                if (self.eventsDATA?.count ?? 0 > 0)
                {
                    self.isSkeleton_Events = false
                    self.SpclEventsCollection.delegate = self
                    self.SpclEventsCollection.dataSource = self
                    self.SpclEventsCollection.reloadData()
                    self.SpclEventsCollection.isHidden = false
                    self.adjustViewHeights(heightLayout: self.BirthdayBannerView_Height, constantValue: 254)
                }
                else
                {
                    self.isSkeleton_Events = true
                    self.SpclEventsCollection.delegate = self
                    self.SpclEventsCollection.dataSource = self
                    self.SpclEventsCollection.reloadData()
                    self.SpclEventsCollection.isHidden = true
                    self.adjustViewHeights(heightLayout: self.BirthdayBannerView_Height, constantValue: 61)
                }
                
                
                //Company Banners
                if (restOffers.count > 0)
                {
                    self.restOffersDATA = restOffers
                    self.isSkeleton_Banners = false
                    self.bannerCollection.setEmptyMessage("")
                    self.bannerCollection.delegate = self
                    self.bannerCollection.dataSource = self
                    self.bannerCollection.reloadData()
                    self.adjustViewHeights(heightLayout: self.BannerView_Height, constantValue: 172)
                }
                else
                {
                    self.isSkeleton_Banners = true
                    self.bannerCollection.setEmptyMessage("Offers Not Available!")
                    self.bannerCollection.delegate = self
                    self.bannerCollection.dataSource = self
                    self.bannerCollection.reloadData()
                    self.adjustViewHeights(heightLayout: self.BannerView_Height, constantValue: 0)
                }
                
                
                //TOP PICKES
                if (topPicks.count > 0)
                {
                    self.topPicksDATA = topPicks
                    self.isSkeleton_TopPicks = false
                    self.topPickesCollection.setEmptyMessage("")
                    self.topPickesCollection.delegate = self
                    self.topPickesCollection.dataSource = self
                    self.topPickesCollection.reloadData()
                    self.lblTopPicks.isHidden = false
                    self.adjustViewHeights(heightLayout: self.topPickesView_Height, constantValue: 186)
                }
                else
                {
                    self.isSkeleton_TopPicks = true
                    self.topPickesCollection.setEmptyMessage(kDataNothingTOSHOW)
                    self.topPickesCollection.delegate = self
                    self.topPickesCollection.dataSource = self
                    self.topPickesCollection.reloadData()
                    self.lblTopPicks.isHidden = true
                    self.adjustViewHeights(heightLayout: self.topPickesView_Height, constantValue: 0)
                }
                
                
//                //VENDORS(REATAURANTS)
//                if (vendors.count > 0)
//                {
//                    self.vendorsDATA = vendors
//                    self.isSkeleton_Vendors = false
//                    self.vendorsTableView.setEmptyMessage("")
//                    self.vendorsTableView.delegate = self
//                    self.vendorsTableView.dataSource = self
//                    self.vendorsTableView.animateReload()
//                    self.restauantView.isHidden = false
//                    self.setTableLayoutVendors()
//                }
//                else
//                {
//                    self.isSkeleton_Vendors = true
//                    self.vendorsTableView.setEmptyMessage(kDataNothingTOSHOW)
//                    self.vendorsTableView.delegate = self
//                    self.vendorsTableView.dataSource = self
//                    self.restauantView.isHidden = true
//                    self.vendorsTableView.animateReload()
//                    self.setTableLayoutVendors()
//                }
                
                //trending serivces
                if (self.trendingDATA?.count ?? 0 > 0)
                {
                    self.isSkeleton_Trending = false
                    self.trendingCollection.setEmptyMessage("")
                    self.trendingCollection.delegate = self
                    self.trendingCollection.dataSource = self
                    self.trendingCollection.reloadData()
                    self.adjustViewHeights(heightLayout: self.trendingView_Height, constantValue: 290)
                }
                else
                {
                    self.isSkeleton_Trending = true
                    self.trendingCollection.setEmptyMessage(kDataNothingTOSHOW)
                    self.trendingCollection.delegate = self
                    self.trendingCollection.dataSource = self
                    self.trendingCollection.reloadData()
                    self.adjustViewHeights(heightLayout: self.trendingView_Height, constantValue: 0)
                }
                
                
//                //BEST SELLERS
//                if (bestSellers.count > 0)
//                {
//                    self.isSkeleton_BestSeller = false
//                    self.bestSellerTableView.setEmptyMessage("")
//                    self.bestSellerTableView.delegate = self
//                    self.bestSellerTableView.dataSource = self
//                    self.bestSellerTableView.animateReload()
//                    self.bestSellerView.isHidden = false
//                    self.setTableLayoutBestSellar()
//                }
//                else
//                {
//                    self.isSkeleton_BestSeller = true
//                    self.bestSellerTableView.setEmptyMessage(kDataNothingTOSHOW)
//                    self.bestSellerTableView.delegate = self
//                    self.bestSellerTableView.dataSource = self
//                    self.bestSellerTableView.animateReload()
//                    self.bestSellerView.isHidden = true
//                    self.setTableLayoutBestSellar()
//                }
                
                
                //Offers
                if (offers.count > 0)
                {
                    self.isSkeleton_Offer = false
                    self.offerCollection.setEmptyMessage("")
                    self.offerCollection.delegate = self
                    self.offerCollection.dataSource = self
                    self.offerCollection.reloadData()
                    self.offersView.isHidden = false
                    self.adjustViewHeights(heightLayout: self.offerView_Height, constantValue: 223)
                }
                else
                {
                    self.isSkeleton_Offer = true
                    self.offerCollection.setEmptyMessage("Offers Not Available!")
                    self.offerCollection.delegate = self
                    self.offerCollection.dataSource = self
                    self.offerCollection.reloadData()
                    self.offersView.isHidden = true
                    self.adjustViewHeights(heightLayout: self.offerView_Height, constantValue: 0)
                }
                
                //checking if cart is emoty or not
                self.updateCartBadge(target:self)
                
                
        }
    }
 
    
    func nothingFound()
    {
        isSkeleton_Banners = false
        isSkeleton_TopPicks = false
        isSkeleton_Vendors = false
        isSkeleton_Trending = false
        isSkeleton_BestSeller = false
        isSkeleton_Offer = false
        
        self.bannerCollection.setEmptyMessage(kDataNothingTOSHOW)
        self.topPickesCollection.setEmptyMessage(kDataNothingTOSHOW)
        self.trendingCollection.setEmptyMessage(kDataNothingTOSHOW)
        self.offerCollection.setEmptyMessage("Offers Not Available!")
        
        self.bannerCollection.reloadData()
        self.topPickesCollection.reloadData()
        self.trendingCollection.reloadData()
        self.offerCollection.reloadData()
        
        //  self.adjustViewHeights(heightLayout: self.trendingView_Height, constantValue: 0)
        //  self.adjustViewHeights(heightLayout: self.BannerView_Height, constantValue: 0)
        
    }
    
    
    func adjustViewHeights(heightLayout:NSLayoutConstraint,constantValue:CGFloat)
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: .curveEaseInOut, animations:
            {
                heightLayout.constant = constantValue
                self.view.layoutIfNeeded()
        })
        { _ in}
    }
    
}


extension HomeNewVC:UpdateViewAfterCouponDetails_Delegate
{
    func refreshController(text: String)
    {
        
    }
}

