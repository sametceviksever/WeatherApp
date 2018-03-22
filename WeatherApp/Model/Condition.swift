//
//  Condition.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Degree {
    var grnd_level: Double
    var temp_min: Double
    var temp_max: Double
    var temp: Double
    var sea_level: Double
    var pressure: Double
    var humidity : Double
    var temp_kf: Double
    
    init(with json:JSON) {
        grnd_level = json["grnd_level"].doubleValue
        temp_min = json["temp_min"].doubleValue
        temp_max = json["temp_max"].doubleValue
        temp = json["temp"].doubleValue
        sea_level = json["sea_level"].doubleValue
        pressure = json["pressure"].doubleValue
        humidity = json["humidity"].doubleValue
        temp_kf = json["temp_kf"].doubleValue
    }
}

struct Cloud{
    var all:Double
    
    init(with json:JSON) {
        all = json["all"].doubleValue
    }
}

struct Wind {
    var deg: Double
    var speed:Double
    
    init(with json:JSON) {
        deg = json["deg"].doubleValue
        speed = json["speed"].doubleValue
    }
}

struct Sys {
    var pod:String
    
    init(with json:JSON) {
        pod = json["pod"].stringValue
    }
}

struct Rain {
    var item:Double
    
    init(with json:JSON) {
        item = json["3h"].doubleValue
    }
}

struct Weather {
    var main:String?
    var icon:String?
    var description:String?
    var id:Int?
    
    init(with json:JSON) {
        main = json["main"].stringValue
        icon = json["icon"].stringValue
        description = json["description"].stringValue
        id = json["id"].intValue
    }
}

struct WeatherCondition {
    
    var main:Degree?
    var clouds:Cloud?
    var weathers:[Weather] = [Weather]()
    var wind:Wind?
    var rain:Rain?
    var sys:Sys?
    var dateText:String?
    var date:Int?
    
    init(with json:JSON) {
        main = Degree(with: json["main"])
        clouds = Cloud(with: json["clouds"])
        for dict in json["weather"].arrayValue{
            weathers.append(Weather(with: dict))
        }
        wind = Wind(with: json["wind"])
        rain = Rain(with: json["rain"])
        sys = Sys(with: json["sys"])
        dateText = json["dt_txt"].stringValue
        date = json["dt"].intValue
    }
}
