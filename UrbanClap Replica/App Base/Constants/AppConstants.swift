//
//  AppConstants.swift
//  Cabbies
//
//  Created by Techwin Labs on 03/04/19.
//  Copyright © 2019 Techwin Labs. All rights reserved.
//
//
import Foundation
import UIKit

let KDone                                           =         "Done"
let KChooseImage                                    =         "Choose Image"
let KChooseVideo                                    =         "Choose Video"
let KCamera                                         =         "Camera"
let KGallery                                        =         "Gallery"
let KYoudonthavecamera                              =         "You don't have camera"
let KSettings                                       =         "Settings"

let kvendorType = "0" //0 for multy type 1 for single vendor

//MARK: RAZORPAY KEYS

let RAZORPAY_KEY_ID = "rzp_test_oCGcDMHUvhIopO"
let RAZORPAY_KEY_SECRET = "h66PjdxgCVhxhbeNxWahYUmf"



@available(iOS 13.0, *)
let KappDelegate                                    =        UIApplication.shared.delegate as! AppDelegate
let KOpenSettingForPhotos                           =         "App does not have access to your photos. To enable access, tap Settings and turn on Photos."
let KOpenSettingForCamera                           =         "App does not have access to your camera. To enable access, tap Settings and turn on Camera."
let KOK                                             =         "OK"
let KCancel                                         =       "Cancel"
let KYes                                              =       "Yes"
let KNo                                         =       "No"

let KOngoing                                         =       "Ongoing"
let KCompleted                                         =       "Completed"

//let GoogleAPIKey = "AIzaSyC9XlPw-l_lY4ga__R5daHFQ8Aj4c8gqOU" //Home Services
//let GoogleAPIKey =  "AIzaSyBgzJUukER16CRjRdW9UyCp0yIbYAsW1g8" //Driver App
let GoogleAPIKey =  "AIzaSyAkJZ5P6u38Laomfb_t-HMH3Eg_xvJH3ec" //Food App IT TEam

//MARK:- iDevice detection code
struct Device_type
{
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH >= 812
}

//MARK : STATIC TEXT
let kAppName = "EatAwesome"
let kLoading = ""
let kVerifying = ""
let kLoading_Getting_OTP = ""

//let kLoading = "Loading..."
//let kVerifying = "Verifying..."
//let kLoading_Getting_OTP = "Requesting OTP..."

let kSuccess = "Success!"
let kDone = "Done"
let kSaved = "Saved"
let kError = "Error!"
let kFailed = "Failed!"
let kOops = "Oops!"
let kDataNotFound = "Data not found!"
let kDataNothingTOSHOW = "Sorry nothing to show!"
let kStoryBoard_Main = "Main"
let kResponseNotCorrect = "Data isn't in correct form!"
let kUserNotRegistered = "User is not registered yet!"
let kSomthingWrong = "Something went wrong, please try again!"
let kDataSavedInDatabase = "Data saved successfully in database"
let kDatabaseSuccess = "Database Success"
let kDatabaseFailure = "Database Failure"
let kDrift_ClientID = "LKPHJGMiuHYoUA9rs0qOWLiZf2MLXINw"
let kDrift_ClientSecret = "TWGqKCbMSHvqhoo62SokyIBN3mZC2Irc"

let kDrift_ClientToken = "dvaacsihrwad"//home services
//let kDrift_ClientToken = "mfHAjVUjZR5d4NbHfBphTtBrDOFIFGKi"
//vUdBaq6IyUNUuf58kICG3X935lNoGOvK



var kTermsConditions = ""
var kPrivacy = ""
var kAboutUs = ""

let kLottieEmpData = "empData"
let kLottieSearch = "searcher"


//MARK: DEFAULT IMAGES
let kplaceholderProfile = "dummy_user"

let kplaceholderImage = "ph"//defaultImage//bgFood
let kplaceholderFood = "ph"


let kPush_Approach_from_ForgotPassword = "coming_from_forgotPassword"
let kPush_Approach_from_SignUp = "coming_from_signup"


let mainID = "b21a7c8f-078f-4323-b914-8f59054c4467"//25cbf58b-46ba-4ba2-b25d-8f8f653e9f13
let loginMain = "89624900-a974-4849-9048-c32d6bed220a"
//MARK : KEYS FOR STORE DATA

struct defaultKeys
{
    static let serviceType = "serviceType"
    static let userID = "userID"
    static let userName = "userName"
    static let userFirstName = "userFirstName"
    static let userImage = "userImage"
    static let userDOB = "userDOB"
    static let deliveryType = "deliveryType"
    static let userEmail = "userEmail"
    static let userDeviceToken = "userDeviceToken"
    static let userJWT_Token = "userJWT_Token"
    static let userPhoneNumber = "userPhoneNumber"
    
    static let userHomeAddress = "userHomeAddress"
    static let userAddressType = "userAddressType"
    static let userAddressID = "userAddressID"
    static let userAddressAdded = "userAddressAdded"
    
    
    
    static let firebaseVID = "firebaseVID"
    static let userTYPE = "userTYPE"
    static let userCountryCode = "userCountryCode"
    static let firebaseToken = "firebaseToken"
    static let userLastName = "userLastName"
}

struct database
{
    
    struct entityJobDetails
    {
        
    }
    
    struct entityJobSavedLocations
    {
        
    }
    
}



struct APIAddress
{
    // static let BASE_URL = "http://51.79.40.224:9075/" //Food App
    // static let BASE_URL = "http://10.8.14.242:9061/" //NEW Food App
    
    // static let BASE_URL = "http://stgcerb.cerebruminfotech.com:9061/" //NEW Food App
  //  static let BASE_URL =    "http://stgcerb.cerebruminfotech.com:9069/" //Single Vendor
  //  static let BASE_URL =    "http://stgcerb.cerebruminfotech.com:9063/"//Trial version
    static let BASE_URL =    "http://stgcerb.cerebruminfotech.com:9066/" //Single Vendor DEMO
    
    
    //"http://stgcerb.cerebruminfotech.com:9062/" //NEW Food App USA BASED
    
    static let FILL_SURVEY = BASE_URL + "api/mobile/collectDetails"
    
    static let LOGIN = BASE_URL + "api/mobile/auth/login"
    static let LOGIN_TRIAL = BASE_URL + "api/mobile/auth/loginTrial"
    static let USE_REFERRAL_CODE = BASE_URL + "api/mobile/auth/useReferral"
    static let UPDATE_PROFILE = BASE_URL + "api/mobile/profile/updateprofile"
    
    static let REGISTER = BASE_URL + "driver/auth/register"
    static let RESET_PASSWORD = BASE_URL + "driver/auth/resetpassword"
    static let CHANGE_PASSWORD = BASE_URL + "driver/auth/changepassword"
    
    static let ADD_ADDRESS = BASE_URL + "api/mobile/address/add"
    static let GET_ADDRESS = BASE_URL + "api/mobile/address/list"
    static let UPDATE_ADDRESS = BASE_URL + "api/mobile/address/update"
    static let DELETE_ADDRESS = BASE_URL + "api/mobile/address/delete"
    
    
    static let GET_ALLRESTAURANTS = BASE_URL + "api/mobile/company/getCompanies"
    
    static let SEARCH = BASE_URL + "api/mobile/services/search"
    static let ADD_BIRTHDAY = BASE_URL + "api/mobile/profile/updateDatesInfo"
    static let NEW_HOME_API = BASE_URL + "api/mobile/services/homeVendor"
    
    static let GET_HOME_CATEGORIES = BASE_URL + "api/mobile/services/getParentCategories"
    // static let GET_HOME_CATEGORIES = BASE_URL + "api/mobile/services/getCategories"
    static let GET_COMPANIES = BASE_URL + "api/mobile/services/getCompanies"
    
    static let GET_COMPANY_GALLERY = BASE_URL + "api/mobile/company/gallery"
    static let ADD_COMPANY_GALLERY = BASE_URL + "api/mobile/company/gallery/add"
    
    
    static let GET_COMPANIES_CATEGORIES = BASE_URL + "api/mobile/services/getSubcat"
    static let GET_HOME_SUBCATEGORIES = BASE_URL + "api/mobile/services/getSubcat"
    
    static let GET_HOME_SUBCAT_SERVICE = BASE_URL + "api/mobile/services/getServices"
    static let GET_SERVICE_DETAILS = BASE_URL + "api/mobile/services/detail?"
    
    static let ADD_TO_CART = BASE_URL + "api/mobile/cart/add"
    static let UPDATE_TO_CART = BASE_URL + "api/mobile/cart/update"
    static let GET_CART_LIST = BASE_URL + "api/mobile/cart/list"
    static let DELETE_CART_ITEM = BASE_URL + "api/mobile/cart/remove"
    static let CLEAR_CART_ITEMS = BASE_URL + "api/mobile/cart/clear"
    
    static let GET_PROMOCODES = BASE_URL + "api/mobile/coupan/getPromoList"
    static let ADD_PROMOCODE = BASE_URL + "api/mobile/coupan/applyCoupan"
    static let REMOVE_PROMOCODE = BASE_URL + "api/mobile/coupan/removeCoupan"
    
    static let CREATE_ORDER = BASE_URL + "api/mobile/orders/create"
    static let UPATE_PAYEMENT_STATUS = BASE_URL + "api/mobile/orders/paymentStatus"
    static let GET_ORDER_LIST = BASE_URL + "api/mobile/orders/list?"
    static let CANCEL_ORDER = BASE_URL + "api/mobile/orders/cancel"
    static let GET_ORDER_SERVICES = BASE_URL + "api/mobile/orders/detail"
    static let ORDER_COMPLETE = BASE_URL + "api/mobile/orders/status"
    
    static let ORDER_AGAIN = BASE_URL + "api/mobile/orders/reorder"
    
    static let GET_NOTIFICATIONS = BASE_URL + "api/mobile/notification/"
    static let CLEAR_NOTIFICATIONS = BASE_URL + "api/mobile/notification/clearAll"
    
    static let GET_ADDRESS_CHARGES = BASE_URL + "api/mobile/company/shipmentCharges"
    
    static let GET_FAVORITES = BASE_URL + "api/mobile/favourite/list"
    static let ADD_TO_FAVORITES = BASE_URL + "api/mobile/favourite/add"
    static let REMOVE_FROM_FAVORITES = BASE_URL + "api/mobile/favourite/remove"
    
    static let GET_SLOTS = BASE_URL + "api/mobile/schedule/getSchedule?"
    static let GET_SLOTS_DATES = BASE_URL + "api/mobile/schedule/getSchedule?"
    
    static let GET_INSTRUCTIONS = BASE_URL + "api/mobile/orders/instructions"
    
    static let GET_DOCUMENTS = BASE_URL + "api/mobile/document"
    static let GET_CONTACT_US = BASE_URL + "api/mobile/contactus"
    
    static let GET_RATINGS = BASE_URL + "api/mobile/rating/serviceRatings"
    
    static let ADD_NEW_RATINGS = BASE_URL + "api/mobile/rating/addRating"
    static let ADD_DRIVER_RATINGS = BASE_URL + "api/mobile/rating/addStaffRating"
    static let ADD_ORDER_RATING = BASE_URL + "api/mobile/rating/addRating"
    
    static let GET_FAQ = BASE_URL + "api/mobile/getFaq?"
    
    //Tiffine Service
    static let GettiffinHome = BASE_URL + "api/mobile/tiffin/home"
    
    static let GetProfile = BASE_URL + "api/mobile/profile/getprofile"
    static let LOGOUT = BASE_URL + "api/mobile/auth/logout"
    
    static let GetOrderDetail = BASE_URL + "api/mobile/orders/detail/"
    static let addRatingNew = BASE_URL + "api/mobile/rating/addCompanyRating"
    
    
    
    //http://stgcerb.cerebruminfotech.com:9061/  FOOD
    static let Socket_Url = "http://stgcerb.cerebruminfotech.com:9066/"     //DEMO
    static let GetMembership = BASE_URL + "api/mobile/subscription"
    static let PaymentMem = BASE_URL + "api/mobile/subscription/purchasePlan"
    
}

let kHeader_app_json = ["Accept" : "application/json"]


enum Parameter_Keys_All : String
{
    
    case deviceToken = "deviceToken"
    case deviceType = "deviceType"
    case voipDeviceToken = "voipDeviceToken"
    case appVersion = "appVersion"
    
    //User LoginProcess Keys signUp keys
    case language = "language"
    case countryCode = "countryCode"
    case phoneNumber = "phoneNumber"
    case otp = "otp"
    case email = "email"
    case signupBy = "signupBy"
    case firstName = "firstName"
    case lastName = "lastName"
    case socialId = "socialId"
    case loginBy = "loginBy"
    
    case password = "password"
    case address = "address"
    case city = "city"
    case country = "country"
    case latitude = "latitude"
    case longitude = "longitude"
    case socialPic = "socialPic"
    case profilePic = "profilePic"
    case emailPhone = "emailPhone"
    case DOB = "DOB"
    case gender = "gender"
    
}

enum Validate : String
{
    
    case none
    case success = "200"
    case failure = "400"
    case invalidAccessToken = "401"
    case fbLogin = "3"
    case fbLoginError = "405"
    
    func map(response message : String?) -> String?
    {
        
        switch self
        {
        case .success : return message
        case .failure :return message
        case .invalidAccessToken :return message
        case .fbLoginError : return Validate.fbLoginError.rawValue
        default :return nil
        }
    }
}



enum configs
{
    static let mainscreen = UIScreen.main.bounds
    static let kAppdelegate = UIApplication.shared.delegate as! AppDelegate
}


struct AlertTitles
{
    static let Ok:String = "OK"
    static let Cancel:String = "CANCEL"
    static let Yes:String = "Yes"
    static let No:String = "No"
    static let Alert:String = "Alert"
    
    static let Internet_not_available = "Please check your internet connection"
    static let Success = "Success"
    static let Error = "Error"
    static let InternalError = "Internal Error"
    static let Enter_UserName = "Please enter username"
    static let Enter_Password = "Please enter password"
    static let Phone_digits_exceeded = "Phone number digists are exceeded, make sure you are entering correct phone number"
    static let Enter_phone_number = "Please enter phone number"
    static let EnterValid_phone_number = "Please enter a valid phone number"
    static let PasswordEmpty = "Password is empty"
    static let EnterNewPassword = "Please enter new password"
    static let PasswordEmpty_OLD = "Old Password is empty"
    static let PasswordLength8 = "Password length should be of 8-20 characters"
    static let Password_ShudHave_SpclCharacter = "Your password should contain one numeric,one special character,one upper and lower case character"
    static let PasswordCnfrmEmpty = "Confirm password is empty"
    static let Passwordmismatch = "New password and confirm password does not match"
    
    
    
    
}


enum DateFormat
{
    
    case dd_MMMM_yyyy
    case dd_MM_yyyy
    case dd_MM_yyyy2
    case yyyy_MM_dd
    case hh_mm_a
    case yyyy_MM_dd_hh_mm_a
    case yyyy_MM_dd_hh_mm_a2
    case dateWithTimeZone
    case dd_MMM_yyyy
    case yyyy_mm_dd
    
    func get() -> String
    {
        
        switch self
        {
            
        case .dd_MMMM_yyyy : return "dd MMMM, yyyy"
        case .dd_MM_yyyy : return "dd-MM-yyyy"
        case .dd_MM_yyyy2 : return "dd/MM/yyyy"
        case .yyyy_MM_dd : return "yyyy-MM-dd"
        case .hh_mm_a : return "hh:mm a"
        case .yyyy_MM_dd_hh_mm_a : return  "yyyy-MM-dd hh:mm a"
        case .yyyy_MM_dd_hh_mm_a2 : return  "dd MMM yyyy, hh:mm a"
        case .dateWithTimeZone : return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case .dd_MMM_yyyy : return "dd MMM yyyy"
        case .yyyy_mm_dd : return "yyyy-mm-dd"
            
        }
    }
}

extension String
{
    func capitalizingFirstLetter() -> String
    {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter()
    {
        self = self.capitalizingFirstLetter()
    }
}


struct HomeIdentifiers
{
    static let HomeVC = "HomeDashboardVC"
    static let ShowAdvertismentCell = "ShowAdvertismentCell"
    static let TrendingServiceListCell = "TrendingServiceListCell"
    static let HelpServicesListCell = "HelpServicesListCell"
    static let SubCategoriesListVC = "SubCategoriesListVC"
    static let AdvertismentCollectionCell = "AdvertismentCollectionCell"
    static let TrendingServiceCollectionCell = "TrendingServiceCollectionCell"
    static let ServiceHelpCollectionCell = "ServiceHelpCollectionCell"
    static let SubCategoriesListCell = "SubCategoriesListCell"
}
