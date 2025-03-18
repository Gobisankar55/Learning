//
//  Utilities.swift
//  MyCoreDataTwo
//
//  Created by Gobisankar M M on 15/03/25.
//

import UIKit


class Utilities {
    
    static let shared = Utilities()
    
    private init() {}
    
    
    func getDateFromString(from dateString: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.locale = Locale(identifier: "en-us")
        let dobDate = dateFormatter.date(from: dateString)
        return dobDate
    }
    
    func getStringFromDate(from date: Date?) -> String? {
        
        guard let date = date else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.locale = Locale(identifier: "en-us")
        let dobDateString = dateFormatter.string(from: date)
        return dobDateString
    }
    
    
    
}
