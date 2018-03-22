//
//  WeatherDetailVC.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import UIKit

class WeatherDetailVC: UIViewController {

    enum DayStatus:String{
        case day = "d"
        case night = "n"
        
        var backgroundColor:UIColor{
            switch self {
            case .day:
                return UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
            case .night:
                return UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.9)
            }
        }
    }
    @IBOutlet weak var imgWeather:UIImageView!
    @IBOutlet weak var lblDegree:UILabel!
    @IBOutlet weak var lblHumidity:UILabel!
    @IBOutlet weak var lblSeaLevel:UILabel!
    @IBOutlet weak var lblPressure:UILabel!
    @IBOutlet weak var lblDegreeMin:UILabel!
    @IBOutlet weak var lblDegreeMax:UILabel!
    @IBOutlet weak var lblWindSpeed:UILabel!
    
    var weather:WeatherCondition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI(){
        if let dayStatus = DayStatus(rawValue: weather.sys?.pod ?? "d"){
            view.backgroundColor = dayStatus.backgroundColor
        }
        title = weather.dateText?.formatby("dd MMM HH:mm", fromString: "yyyy-MM-dd HH:mm:ss")
        if let firstWeather = weather.weathers.first{
            let urlString = String(format:AppConfig.baseIconUrl,firstWeather.icon ?? "03d")
            imgWeather.setImage(urlString: urlString)
        }
        lblDegree.text = String(format:"%.0f°",weather.main?.temp ?? "")
        lblHumidity.text = String(format:"Humidity: %.2f%",weather.main?.humidity ?? "")
        lblSeaLevel.text = String(format:"Sea Level: %.0f",weather.main?.sea_level ?? "")
        lblPressure.text = String(format:"Pressure: %.0f",weather.main?.pressure ?? "")
        lblDegreeMin.text = String(format:"Temp Min: %.0f°",weather.main?.temp_min ?? "")
        lblDegreeMax.text = String(format:"Temp Max: %.0f°",weather.main?.temp_max ?? "")
        lblWindSpeed.text = String(format:"Wind Speed: %.0f",weather.wind?.speed ?? "")
    }
}
