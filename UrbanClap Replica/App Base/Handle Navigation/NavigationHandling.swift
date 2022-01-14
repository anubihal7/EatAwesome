//
//  Enums.swift
//  UnionGoods
//
//  Created by Rakesh Kumar on 11/22/19.
//  Copyright © 2019 UnionGoods. All rights reserved.
//

import Foundation
import UIKit

class Navigation
{
    enum type
    {
        case root
        case push
        case present
        case pop
    }
    
    enum Controller
    {
        //AUTH
        case CheckOTPVC
        case LoginWithPhoneVC
        case SignUPVC
        case SignInVC
        case ResetPasswordVC
        case ChangePasswdVC
        case GetDOBDetailsVC
        case CommonCartVC
        
        //HOME
        case DashboardHome
        case HomeDashboardVC
        case HomeVC
        case EditProfileVC
        case AddressListVC
        case AddNewAddressVC
        case SideMenuVC
        case HomeCategoryVC
        case SubCatsVC
        case CatServiceListVC
        case ServiceDetailVC
        case CartListVC
        case CartDetailsVC
        case FavoriteListVC
        case PromocodesVC
        case HomeServiceCheckOutVC
        case ChooseAddressVC
        case OrderReceivedVC
        case OrderListVC
        case PaymentVC
        case CheckAvailabilityVC
        case CompanyListVC
        case HomeNewVC
        case WelcomeHomeVC
        case NewOrderListVC
        
        //Ratings
        case RatingListVC
        case OrderServiceListVC
        case AddRatingsVC
        case TermsAndPrivacyPolicyVC
        case TrackOrderVC
        case NotificationVC
        case SettingsVC
        case FAQVC
        case SearchVendorsVC
        case SeeAllRestaurantsVC
        case AddCookingInstructions
        case AddToCartVC
        case CouponDetailsVC
        case ContactusVC
        case RecordAudioViewController
        case FAQDetailsVC
        case AddDriverRatings
        case AddOrderRatings
        case GalleryVC
        case UploadGalleryVC
        case ReferAndEarnVC
        
        //Tiffin Service
        case TiffinHomeVC
        case RecipeList
        
        case OrderDetailVC
        case ChatVC
        case MembershipVC
        case FillSurveyVC
        
        
        var obj: UIViewController?
        {
            switch self
            {
                
            //AUTH
            case .CheckOTPVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "CheckOTPVC")
                
            case .LoginWithPhoneVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "LoginWithPhoneVC")
                
            case .SignUPVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "SignUPVC")
                
            case .SignInVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "SignInVC")
                
            case .ResetPasswordVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "ResetPasswordVC")
                
            case .ChangePasswdVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "ChangePasswdVC")
                
            case .EditProfileVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "EditProfileVC")
                
            case .GetDOBDetailsVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "GetDOBDetailsVC")
            case .CommonCartVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "CommonCartVC")
                
                
            //HOME
            case .DashboardHome:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "DashboardHome")
            case .HomeDashboardVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "HomeDashboardVC")
            case .HomeVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "HomeVC")
            case .AddressListVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "AddressListVC")
            case .AddNewAddressVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "AddNewAddressVC")
            case .SideMenuVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "SideMenuVC")
            case .HomeCategoryVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "HomeCategoryVC")
            case .SubCatsVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "SubCatsVC")
            case .CatServiceListVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "CatServiceListVC")
            case .ServiceDetailVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "ServiceDetailVC")
            case .CartListVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "CartListVC")
            case .CartDetailsVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "CartDetailsVC")
            case .FavoriteListVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "FavoriteListVC")
            case .PromocodesVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "PromocodesVC")
            case .HomeServiceCheckOutVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "HomeServiceCheckOutVC")
            case .ChooseAddressVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "ChooseAddressVC")
            case .OrderReceivedVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "OrderReceivedVC")
            case .OrderListVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "OrderListVC")
            case .PaymentVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "PaymentVC")
            case .CheckAvailabilityVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "CheckAvailabilityVC")
            case .CompanyListVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "CompanyListVC")
            case .HomeNewVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "HomeNewVC")
            case .WelcomeHomeVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "WelcomeHomeVC")
                
            case .NewOrderListVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "NewOrderListVC")
                
                
                
            //Ratings
            case .RatingListVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "RatingListVC")
            case .OrderServiceListVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "OrderServiceListVC")
            case .AddRatingsVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "AddRatingsVC")
            case .TermsAndPrivacyPolicyVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "TermsAndPrivacyPolicyVC")
            case .TrackOrderVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "TrackOrderVC")
            case .NotificationVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "NotificationVC")
            case .SettingsVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "SettingsVC")
            case .FAQVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "FAQVC")
            case .SearchVendorsVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "SearchVendorsVC")
            case .SeeAllRestaurantsVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "SeeAllRestaurantsVC")
            case .AddCookingInstructions:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "AddCookingInstructions")
            case .AddToCartVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "AddToCartVC")
            case .CouponDetailsVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "CouponDetailsVC")
                
            case .ContactusVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "ContactusVC")
            case .RecordAudioViewController:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "RecordAudioViewController")
            case .FAQDetailsVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "FAQDetailsVC")
                
            case .AddDriverRatings:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "AddDriverRatings")
            
            case .AddOrderRatings:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "AddOrderRatings")
                
            case .GalleryVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "GalleryVC")
                
            case .UploadGalleryVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "UploadGalleryVC")
                
            case .ReferAndEarnVC:
                return StoryBoards.Ratings.obj?.instantiateViewController(withIdentifier: "ReferAndEarnVC")
                
                
                
            //TiffinServices
            case .TiffinHomeVC:
                return StoryBoards.TiffinServices.obj?.instantiateViewController(withIdentifier: "TiffinHomeVC")
                
                case .RecipeList:
                               return StoryBoards.TiffinServices.obj?.instantiateViewController(withIdentifier: "RecipeList")
                
                //tiffin
                case .OrderDetailVC:
                               return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "OrderDetailVC")
                               
            case .ChatVC:
                return StoryBoards.Chat.obj?.instantiateViewController(withIdentifier: "ChatVC")
                
                case .MembershipVC:
                return StoryBoards.Chat.obj?.instantiateViewController(withIdentifier: "MembershipVC")
            case .FillSurveyVC:
                return StoryBoards.Chat.obj?.instantiateViewController(withIdentifier: "FillSurveyVC")
            }
        }
    }
    enum StoryBoards
    {
        case Main
        case Home
        case Ratings
        case TiffinServices
        case Recipe
        case Chat
        
        var obj: UIStoryboard?
        {
            switch self
            {
            case .Main:
                return UIStoryboard(name: "Main", bundle: nil)
            case .Home:
                return UIStoryboard(name: "Home", bundle: nil)
            case .Ratings:
                return UIStoryboard(name: "Ratings", bundle: nil)
            case .TiffinServices:
                return UIStoryboard(name: "TiffinServices", bundle: nil)
                case .Recipe:
                return UIStoryboard(name: "Recipe", bundle: nil)
                case .Chat:
                return UIStoryboard(name: "Chat", bundle: nil)
            }
        }
        
    }
    
    static func GetInstance(of controller : Controller) -> UIViewController
    {
        return controller.obj!
    }
    
}

