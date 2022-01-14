
//

import UIKit

class DynamicTextHandler: UIViewController
{
    //screen titles
    static var HOMESCREEN_TITLE = "Home"
    static var COMPNYLIST_TITLE = "Vendors"
    static var SERVICELIST_TITLE = "Items"
    static var SERVICDETAIL_TITLE = "Item Details"
    static var ORDERS_TITLE = "Orders"
    static var ORDERS_HISTORY_TITLE = "History"
    
    //button add or but for service list
    static var BUYorADD_BUTTON = "ADD"
    static var BUY_AGAIN = "Order again"
    
    //checkout view
    static var CHOOSE_AVAIL_DATE = "Choose delivery date"
    static var CHOOSE_AVAIL_TIME = "Choose delivery time"
    
    //service detail screen
    static var ITEM_DURATION_TEXT = "Preperation Time"
    static var INCLUDE_EXCLUDE_ITEMS = "Items"
    static var TURNAROUND_TIME = "Turnaround time"
    
    //Main category home
    static var HOME_TRENDING_SERVICE = "Trending"
    static var HOME_BOOKED_SERVICE = "Most ordered items this week"
    
    //order screen
    static var BOOKED_ON = "Ordered on"
    static var SERVICE_DATE = "Item date"
    static var ORDER_TYPE = "Items"
    static var RATE_ITEM = "Item"
    
    
    
    class func restoreData()
    {
        HOMESCREEN_TITLE = "HOME"
        COMPNYLIST_TITLE = "VENDOR LIST"
        SERVICELIST_TITLE = "SERVICES"
        SERVICDETAIL_TITLE = "SERVICE DETAILS"
        ORDERS_TITLE = "ORDERS"
        ORDERS_HISTORY_TITLE = "BOOKING HISTORY"
        
        BUYorADD_BUTTON = "Buy"
        
        CHOOSE_AVAIL_DATE = "Choose delivery date"
        CHOOSE_AVAIL_TIME = "Choose delivery time"
        
        ITEM_DURATION_TEXT = "Duration"
        INCLUDE_EXCLUDE_ITEMS = "Items"
        TURNAROUND_TIME = "Turnaround Time"
        
        HOME_TRENDING_SERVICE = "Trending Services"
        HOME_BOOKED_SERVICE = "Most booked sevices in this week"
        
        BOOKED_ON = "Booked On"
        SERVICE_DATE = "Service Date"
        ORDER_TYPE = "Services"
    }
    
}
