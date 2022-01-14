//
//  Date.swift
//  GoodsDelivery
//
//  Created by Rakesh Kumar on 16/01/20.
//  Copyright © 2020 UnionGoods. All rights reserved.
//

import Foundation

extension Date
{
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String
    {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}


class Custom_Date_Formatter
{
    class func returnDate_from_Formatter(myDate:String) -> String
    {
        if (myDate.count > 0)
        {
            let formatter = DateFormatter()
            let dateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = formatter.date(from:myDate)
            {
                dateFormatter.dateFormat = "dd-MMM, yyyy | hh:mm a"
                //27 feb, 2020 | 06:09 pm
                let fdate = dateFormatter.string(from: date)
                
                if (fdate.count > 0)
                {
                    return fdate
                }
                return "N/A"
            }
            else
            {
                return "N/A"
            }
        }
        else
        {
            return "N/A"
        }
    }
    
    class func getDate_difference(strDate:String) -> String
    {
        if (strDate.count > 0)
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = formatter.date(from:strDate)
            {
                var nDate = ""
                formatter.dateFormat = "dd-MMM-yyyy"
                nDate = formatter.string(from: date)
                let fdate = formatter.date(from: nDate)
                
                if fdate == Date()
                {
                    return "1"
                }
                if (fdate?.timeIntervalSinceNow.sign == .plus)
                {
                    // date is in future
                    return "0"
                }
                if (fdate?.timeIntervalSinceNow.sign == .minus)
                {
                    // date is in past
                    return "1"
                }
            }
            else
            {
                return "0"
            }
        }
        else
        {
            return "0"
        }
        
        return "0"
    }
    
    class func return_current_date() -> String
    {
        let formatter = DateFormatter()
        let fdate = formatter.string(from: Date())
        if (fdate.count > 0)
        {
            return fdate
        }
        return "N/A"
    }
    
}
