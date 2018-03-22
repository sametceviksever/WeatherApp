//
//  Response.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Response {
    var city:ResponseCity
    var cod:String
    var cnt:Int
    var message:String
    var list:[WeatherCondition] = [WeatherCondition]()
    
    init(with json:JSON) {
        
        for dict in json["list"].arrayValue{
            let item = WeatherCondition(with: dict)
            list.append(item)
        }
        
        cod = json["cod"].stringValue
        cnt = json["cnt"].intValue
        message = json["message"].stringValue
        city = ResponseCity(with: json["city"])
        
    }
}
