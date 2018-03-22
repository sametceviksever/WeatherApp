//
//  StringExtension.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import Foundation

extension String{
    func formatby(_ toString: String, fromString: String) -> String {
        
        if self == "" {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = fromString
        let date = dateFormatter.date(from: self)
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateFormatter.dateFormat = toString
        let str = date != nil ? dateFormatter.string(from: date!) : ""
        
        return str
        
    }
}
