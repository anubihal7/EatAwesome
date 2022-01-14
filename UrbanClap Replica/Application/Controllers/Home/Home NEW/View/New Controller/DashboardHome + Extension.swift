
//

import Foundation
import UIKit
import Drift




extension DashboardHome : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (collectionView == self.collBestOffers)
        {
            // return self.eventsDATA?.count ?? 0
            return self.bannersDATA?.count ?? 0
            
        }
        else if collectionView == self.collCoupons
        {
            return self.couponDATA?.count ?? 0
        }
        else if collectionView == self.collTopPicks
        {
            return self.topPicksDATA?.count ?? 0
        }
        else if collectionView == self.collTrendings
        {
            return self.trendingDATA?.count ?? 0
        }
        else if collectionView == self.collMenu
        {
            return  self.menus.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell = UICollectionViewCell()
        
        //Special Events
        if (collectionView == self.collBestOffers)
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_TopPicks, for: indexPath)as! CollectionTopPicks
            if let data = self.bannersDATA?[indexPath.row]
            {
                // cellnew.btnTapOnCell.tag = indexPath.row
                let imgPath = data.thumbnail ?? ""
                cellnew.ivTop.setImage(with: imgPath, placeholder: kplaceholderFood)
                cellnew.ivTop.CornerRadius(radius: 15)
                cellnew.lblName.text = data.name ?? "N/A"
            }
            cell = cellnew
        }
            
            
            //TOP PICKS FOR YOU
        else if collectionView == self.collTopPicks
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_TopPicks, for: indexPath)as! CollectionTopPicks
            
            if let data = self.topPicksDATA?[indexPath.row]
            {
                // cellnew.btnTapOnCell.tag = indexPath.row
                let imgPath = data.thumbnail ?? ""
                cellnew.ivTop.setImage(with: imgPath, placeholder: kplaceholderFood)
                cellnew.ivTop.CornerRadius(radius: 15)
                cellnew.lblName.text = data.name ?? "N/A"
            }
            
            cell = cellnew
        }
            
            //TRENDING SERVICES
        else if collectionView == self.collTrendings
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_Trending, for: indexPath)as! CollectionTrendings
            
            
            if let data = self.trendingDATA?[indexPath.row]
            {
                let imgPath = data.thumbnail ?? ""
                cellnew.ivTrendings.setImage(with: imgPath, placeholder: kplaceholderFood)
                cellnew.ivTrendings.CornerRadius(radius: 15)
                cellnew.lblName.text = data.name 
                
            }
            
            cell = cellnew
        }
            
            //Coupons
        else if collectionView == self.collCoupons
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_Coupons, for: indexPath)as! CollectionCoupons
            
            if let data = self.couponDATA?[indexPath.row]
            {
                let imgPath = data.thumbnail ?? ""
                cellnew.btnTap.tag = indexPath.row
                cellnew.ivCoupon.setImage(with: imgPath, placeholder: kplaceholderFood)
                // cellnew.ivBanners.roundCornersTopLEFTopRIGHT()
            }
            
            cell = cellnew
        }
            
            //Menus
        else if collectionView == self.collMenu
        {
            let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_Menu, for: indexPath)as! CollectionMenu
            let data = self.menus[indexPath.row]
            cellnew.lblName.text = data
            
            if (indexPath.row == 0)
            {
                cellnew.lblName.backgroundColor = kpurpleTheme
            }
            else if (indexPath.row == 1)
            {
                cellnew.lblName.backgroundColor = korangeTheme
            }
            else if (indexPath.row == 2)
            {
                cellnew.lblName.backgroundColor = kpinkTheme
            }
            
            cell = cellnew
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        if(collectionView == self.collBestOffers)
        {
            
            if (self.bannersDATA?.count ?? 0 > 0)
            {
                let obj = self.bannersDATA![indexPath.row]
                let controller = Navigation.GetInstance(of: .ServiceDetailVC)as! ServiceDetailVC
                controller.catID = obj.id ?? "0"
                controller.itmName = obj.name ?? "Details"
                self.push_To_Controller(from_controller: self, to_Controller: controller)
                
            }
            
        }
        
        if(collectionView == self.collTopPicks)
        {
            if(self.topPicksDATA?.count ?? 0 > 0)
            {
                //                let obj = self.topPicksDATA![indexPath.row]
                //                let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
                //              //  AppDefaults.shared.companyID = obj.id ?? ""
                //                controller.comId = obj.id ?? ""
                //                controller.categoryID = mainID
                //             //   controller.Tittle = obj.companyName ?? ""
                //                self.push_To_Controller(from_controller: self, to_Controller: controller)
                
                
                let obj = self.topPicksDATA![indexPath.row]
                let controller = Navigation.GetInstance(of: .ServiceDetailVC)as! ServiceDetailVC
                controller.catID = obj.id ?? "0"
                controller.itmName = obj.name ?? "Details"
                self.push_To_Controller(from_controller: self, to_Controller: controller)
            }
        }
        
        if (collectionView == self.collTrendings) {
            if(self.trendingDATA?.count ?? 0 > 0)
            {
                //                let obj = self.topPicksDATA![indexPath.row]
                //                let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
                //              //  AppDefaults.shared.companyID = obj.id ?? ""
                //                controller.comId = obj.id ?? ""
                //                controller.categoryID = mainID
                //             //   controller.Tittle = obj.companyName ?? ""
                //                self.push_To_Controller(from_controller: self, to_Controller: controller)
                
                
                let obj = self.trendingDATA![indexPath.row]
                let controller = Navigation.GetInstance(of: .ServiceDetailVC)as! ServiceDetailVC
                controller.catID = obj.id ?? ""
                controller.itmName = obj.name ?? ""
                self.push_To_Controller(from_controller: self, to_Controller: controller)
            }
            
        }
        
        
        if(collectionView == self.collMenu)
        {
            if (indexPath.row == 0)//best sellers
            {
                showingBestSellerData = true
                setTableLayoutVendors()
            }
            if (indexPath.row == 1)//nearby
            {
                showingBestSellerData = false
                setTableLayoutVendors()
            }
            if (indexPath.row == 2)//view all
            {
                //                 let obj = self.topPicksDATA![indexPath.row]
                let controller = Navigation.GetInstance(of: .SeeAllRestaurantsVC)as! SeeAllRestaurantsVC
                controller.discount = ""
                controller.bannersDATA = []
                self.push_To_Controller(from_controller: self, to_Controller: controller)
            }
        }
        
        
    }
    
    
    
    func checkVendorIsSameForCartVendoer(cmpnyID:String)
    {
        let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
        if (self.cartVendorID.count == 0)
        {
            // AppDefaults.shared.companyID = cmpnyID
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
        
        if (showingBestSellerData == true)
        {
            let height = 115*(self.bestSellerDATA?.count ?? 0)
            self.vendorsTableHeight.constant = CGFloat(height)
            vendorsTableHeight.constant = CGFloat(height+50)
        }
        else
        {
            let height = 115*(self.vendorsDATA?.count ?? 0)
            self.vendorsTableHeight.constant = CGFloat(height)
            vendorsTableHeight.constant = CGFloat(height+50)
        }
        
        self.tableVendors.animateReload()
        self.view.setNeedsLayout()
    }
    
    
    func checkDeliveryTypeOption()
    {
        if(AppDefaults.shared.deliveryType == "delivery")
        {
            btnDeliveryType.tag = 0
            self.btnDeliveryType.setBackgroundImage(UIImage(named: "delivery"), for: .normal)
        }
        if(AppDefaults.shared.deliveryType == "pickup")
        {
            btnDeliveryType.tag = 1
            self.btnDeliveryType.setBackgroundImage(UIImage(named: "pickup"), for: .normal)
           // self.viewModel?.getCategoryList()
        }
        else//both
        {
            if(AppDefaults.shared.deliveryTypeForBoth == "1")
            {
                btnDeliveryType.tag = 0
                self.btnDeliveryType.setBackgroundImage(UIImage(named: "delivery"), for: .normal)
            }
            else
            {
                btnDeliveryType.tag = 1
                self.btnDeliveryType.setBackgroundImage(UIImage(named: "pickup"), for: .normal)
            }
        }
    }
    
    func setUI()
    {
        self.viewSearch.layer.cornerRadius = 15
        self.viewSearch.layer.masksToBounds = true
        checkDeliveryTypeOption()
        
        self.viewTopPicks.backgroundColor = UIColor.clear
        self.viewFilter.backgroundColor = UIColor.clear
        self.viewBestOffers.backgroundColor = UIColor.clear
        self.viewTrendings.backgroundColor = UIColor.clear
        self.viewCoupons.backgroundColor = UIColor.clear
        self.viewMenu.backgroundColor = UIColor.clear
        
        
        if(AppDefaults.shared.userDOB.count == 0)
        {
            let controller = Navigation.GetInstance(of: .GetDOBDetailsVC)as! GetDOBDetailsVC
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
        
        
        //        self.btnViewAll.backgroundColor = Appcolor.get_category_theme()
        //        self.btnViewAll.updateLayerProperties()
        self.rcntOrderBlurView.layer.cornerRadius = 10
        self.rcntOrderBlurView.layer.masksToBounds = true
        //
        //        if (AppDefaults.shared.isVegOnly == true)
        //        {
        //            self.btnSwitch.setOn(true, animated: true)
        //            self.vegOnly = "0"
        //        }
        //        else
        //        {
        //            self.btnSwitch.setOn(false, animated: true)
        //            self.vegOnly = ""
        //        }
        
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
                                self.MenuViewBottomConstraint.constant = -90
                                self.CartViewBottomConstraint.constant = -90
            })
        }
        else
        {
            let sttsmsg = self.getAbbreviationForOrderStatus(status:self.recentORDER?.orderStatus.statusName ?? "")
            
            self.lblStatus.text = sttsmsg
            self.lblOrderStatus.text = "Sit back & relax, \(sttsmsg)"
            self.lblOrderAmout.text = "Amount: \(AppDefaults.shared.currency)\(self.recentORDER?.totalOrderPrice ?? "N/A")"
            self.lblOrderNumber.text = "Order No: \(self.recentORDER?.orderNo ?? "N/A")"
            self.animateRecentOrder()
            
            UIView.transition(with: self.bannerViewCustom, duration: 0.4,
                              options: .transitionFlipFromBottom,
                              animations: {
                                self.bannerViewCustom.isHidden = false
                                self.MenuViewBottomConstraint.constant = 8
                                self.CartViewBottomConstraint.constant = 8
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
    
    func checkCartBadge()
    {
        if(AppDefaults.shared.cartCount == 0)
        {
            // self.viewCart.isHidden = true
        }
        else
        {
            // self.viewCart.isHidden = false
        }
        self.lblCartCount.text = self.getCartCount()
    }
    
    
    func addSplash()
    {
        if AppDefaults.shared.showSplash == true
        {
            self.splashView.isHidden = false
            let controller = Navigation.GetInstance(of: .WelcomeHomeVC)as! WelcomeHomeVC
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: {
                self.splashView.isHidden = true
                self.hideNAV_BAR(controller: self)
            })
        }
        else
        {
            self.splashView.isHidden = true
            hideNAV_BAR(controller: self)
        }
    }
    
    
    func getAbbreviationForOrderStatus(status:String) -> String
    {
        if(self.recentORDER?.orderStatus.statusName == "Confirmed" )
        {
            return "Your order has \(self.recentORDER?.orderStatus.statusName ?? "N/A")"
        }
        else if(self.recentORDER?.orderStatus.statusName == "Pending" )
        {
            return "Your order is \(self.recentORDER?.orderStatus.statusName ?? "N/A")"
        }
        else if(self.recentORDER?.orderStatus.statusName == "Cancelled" )
        {
            return "Your order is \(self.recentORDER?.orderStatus.statusName ?? "N/A")"
        }
        else if(self.recentORDER?.orderStatus.statusName == "Processing" )
        {
            return "Your order is \(self.recentORDER?.orderStatus.statusName ?? "N/A")"
        }
        else if(self.recentORDER?.orderStatus.statusName == "Cancelled-Company" )
        {
            return "Your order is canceled by restaurant"
        }
        else if(self.recentORDER?.orderStatus.statusName == "Completed" )
        {
            return "Your order has \(self.recentORDER?.orderStatus.statusName ?? "N/A")"
        }
        else if(self.recentORDER?.orderStatus.statusName == "Cooking" )
        {
            return "Your order is \(self.recentORDER?.orderStatus.statusName ?? "N/A")"
        }
        else if(self.recentORDER?.orderStatus.statusName == "Packed" )
        {
            return "Your order is \(self.recentORDER?.orderStatus.statusName ?? "N/A")"
        }
        else if(self.recentORDER?.orderStatus.statusName == "Out for delivery" )
        {
            return "Your order is \(self.recentORDER?.orderStatus.statusName ?? "N/A")"
        }
        else if(self.recentORDER?.orderStatus.statusName == "Reached your doorstep\n")
        {
            return "Your order is reached"
        }
        else if(self.recentORDER?.orderStatus.statusName == "Waiting for Customer")
        {
            return "Your order is waiting for you"
        }
        
        return "N/A"
    }
}

extension DashboardHome : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if (collectionView == self.collBestOffers)
        {
           // let collectionViewWidth = self.collBestOffers.frame.size.width
            return CGSize(width: 100, height: 140)
        }
        else if (collectionView == self.collCoupons)
        {
            return CGSize(width: 150, height: 70)
        }
        else if (collectionView == self.collTopPicks)
        {
            return CGSize(width: 100, height: 140)
        }
        else if (collectionView == self.collTrendings)
        {
            return CGSize(width: 100, height: 140)
        }
        else if (collectionView == self.collMenu)
        {
            let label = UILabel(frame: CGRect.zero)
            label.text = self.menus[indexPath.item]
            label.sizeToFit()
            return CGSize(width: label.frame.size.width+10, height: 50)
        }
        
        return CGSize(width: 100, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
    
    
}

extension DashboardHome : HomeNewVCDelegate
{
    func getData(restOffers: [RESTOfferDEC], topPicks: [TopPickNEW], trendindServices: [TrendingNEW], offers: [OfferNEW], allData: BodyNEW, selected : [TopPickNEW]) {
        DispatchQueue.main.async
            {
                self.bannersDATA = selected
                //  self.eventsDATA = events
                self.couponDATA = restOffers
                self.topPicksDATA = topPicks
                self.vendorsDATA = [BestSellerNEW]()
                
                self.trendingDATA = trendindServices
                self.bestSellerDATA = [BestSellerNEW]()
                // self.offersDATA = offers
                
                self.cartVendorID = "" // allData.cartCompanyType ?? ""
                AppDefaults.shared.CartCompanyID = self.cartVendorID
                
                //TOP PICKES
                if (topPicks.count > 0)
                {
                    self.topPicksDATA = topPicks
                    self.collTopPicks.setEmptyMessage("")
                    self.collTopPicks.delegate = self
                    self.collTopPicks.dataSource = self
                    self.collTopPicks.reloadData()
                    self.adjustViewHeights(heightLayout: self.HeightTopPicks, constantValue: 195)
                }
                else
                {
                   // self.collTopPicks.setEmptyMessage(kDataNothingTOSHOW)
                    self.collTopPicks.delegate = self
                    self.collTopPicks.dataSource = self
                    self.collTopPicks.reloadData()
                    self.adjustViewHeights(heightLayout: self.HeightTopPicks, constantValue: 0)
                    // self.lblTopPicks.isHidden = true
                    // self.adjustViewHeights(heightLayout: self.topPickesView_Height, constantValue: 0)
                }
                
                
                //BEST OFFERS
                //                if (self.eventsDATA?.count ?? 0 > 0)
                //                {
                //                    self.collBestOffers.delegate = self
                //                    self.collBestOffers.dataSource = self
                //                    self.collBestOffers.reloadData()
                //                    self.collBestOffers.isHidden = false
                //                    // self.adjustViewHeights(heightLayout: self.BirthdayBannerView_Height, constantValue: 254)
                //                }
                //                else
                //                {
                //                    self.collBestOffers.delegate = self
                //                    self.collBestOffers.dataSource = self
                //                    self.collBestOffers.reloadData()
                //                    self.collBestOffers.isHidden = true
                //                    //  self.adjustViewHeights(heightLayout: self.BirthdayBannerView_Height, constantValue: 61)
                //                }
                
                //   BEST OFFERS - I am using banners here for now
                if (self.bannersDATA?.count ?? 0 > 0)
                {
                    self.collBestOffers.delegate = self
                    self.collBestOffers.dataSource = self
                    self.collBestOffers.reloadData()
                    self.collBestOffers.isHidden = false
                    self.adjustViewHeights(heightLayout: self.HeightBestOfferView, constantValue: 195)
                }
                else
                {
                    self.collBestOffers.delegate = self
                    self.collBestOffers.dataSource = self
                    self.collBestOffers.reloadData()
                    self.collBestOffers.isHidden = true
                    self.adjustViewHeights(heightLayout: self.HeightBestOfferView, constantValue: 0)
                    //  self.adjustViewHeights(heightLayout: self.BirthdayBannerView_Height, constantValue: 61)
                }
                
                
                //                       //VENDORS(REATAURANTS)
                //                       if (vendors.count > 0)
                //                       {
                //                           self.vendorsDATA = vendors
                //                           self.tableVendors.setEmptyMessage("")
                //                           self.tableVendors.delegate = self
                //                           self.tableVendors.dataSource = self
                //                           self.tableVendors.animateReload()
                //                           //  self.restauantView.isHidden = false
                //                           self.setTableLayoutVendors()
                //                       }
                //                       else
                //                       {
                //                           self.tableVendors.setEmptyMessage(kDataNothingTOSHOW)
                //                           self.tableVendors.delegate = self
                //                           self.tableVendors.dataSource = self
                //                           //  self.restauantView.isHidden = true
                //                           self.tableVendors.animateReload()
                //                           self.setTableLayoutVendors()
                //                       }
                
                //trending serivces
                if (self.trendingDATA?.count ?? 0 > 0)
                {
                    self.collTrendings.setEmptyMessage("")
                    self.collTrendings.delegate = self
                    self.collTrendings.dataSource = self
                    self.collTrendings.reloadData()
                    self.adjustViewHeights(heightLayout: self.HeightTrendingView, constantValue: 205)
                    // self.adjustViewHeights(heightLayout: self.trendingView_Height, constantValue: 290)
                }
                else
                {
                   // self.collTrendings.setEmptyMessage(kDataNothingTOSHOW)
                    self.collTrendings.delegate = self
                    self.collTrendings.dataSource = self
                    self.collTrendings.reloadData()
                    self.adjustViewHeights(heightLayout: self.HeightTrendingView, constantValue: 0)
                    //  self.adjustViewHeights(heightLayout: self.trendingView_Height, constantValue: 0)
                }
                
                
                //Coupons
                if (self.couponDATA?.count ?? 0 > 0)
                {
                    self.collCoupons.setEmptyMessage("")
                    self.collCoupons.delegate = self
                    self.collCoupons.dataSource = self
                    self.collCoupons.reloadData()
                    // self.adjustViewHeights(heightLayout: self.trendingView_Height, constantValue: 290)
                }
                else
                {
                  //  self.collCoupons.setEmptyMessage(kDataNothingTOSHOW)
                    self.collCoupons.delegate = self
                    self.collCoupons.dataSource = self
                    self.collCoupons.reloadData()
                    //  self.adjustViewHeights(heightLayout: self.trendingView_Height, constantValue: 0)
                }
                
                
                //MENUS
                self.collMenu.delegate = self
                self.collMenu.dataSource = self
                self.collMenu.reloadData()
                
                //BEST SELLERS
                //                if (bestSellers.count > 0)
                //                {
                //                    self.bestSellerTableView.setEmptyMessage("")
                //                    self.bestSellerTableView.delegate = self
                //                    self.bestSellerTableView.dataSource = self
                //                    self.bestSellerTableView.reloadData()
                //                    self.bestSellerView.isHidden = false
                //                    self.setTableLayoutBestSellar()
                //                }
                //                else
                //                {
                //                    self.bestSellerTableView.setEmptyMessage(kDataNothingTOSHOW)
                //                    self.bestSellerTableView.delegate = self
                //                    self.bestSellerTableView.dataSource = self
                //                    self.bestSellerTableView.reloadData()
                //                    self.bestSellerView.isHidden = true
                //                    self.setTableLayoutBestSellar()
                //                }
                
                
                //checking if cart is emoty or not
                self.updateCartBadge(target:self)
                self.checkCartBadge()
                
                
                
        }
    }
    
    
    
    func nothingFound()
    {
        
       // self.collTopPicks.setEmptyMessage(kDataNothingTOSHOW)
      //  self.collBestOffers.setEmptyMessage(kDataNothingTOSHOW)
      //  self.collTrendings.setEmptyMessage(kDataNothingTOSHOW)
      //  self.collCoupons.setEmptyMessage(kDataNothingTOSHOW)
      //  self.collMenu.setEmptyMessage(kDataNothingTOSHOW)
        
        self.collTopPicks.reloadData()
        self.collBestOffers.reloadData()
        self.collTrendings.reloadData()
        self.collCoupons.reloadData()
        self.collMenu.reloadData()
        
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


extension DashboardHome:UpdateViewAfterCouponDetails_Delegate
{
    func refreshController(text: String)
    {
        
    }
}

