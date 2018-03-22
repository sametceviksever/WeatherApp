//
//  City.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Coordinator {
    var lat:Double?
    var lon:Double?
    
    init(with json:JSON) {
        lat = json["lat"].doubleValue
        lon = json["lon"].doubleValue
    }
}
struct ResponseCity {
    var name:String
    var id:Int
    var coordinator:Coordinator?
    var population:Double
    var country:String
    
    init(with json:JSON) {
        coordinator = Coordinator(with: json["coord"])
        country = json["country"].stringValue
        population = json[""].doubleValue
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}
