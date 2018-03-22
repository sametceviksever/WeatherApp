//
//  WeatherTVC.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import UIKit

class WeatherTVC: UITableViewCell,Reusable {

    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblDegree:UILabel!
    @IBOutlet weak var lblHumidity:UILabel!
    @IBOutlet weak var imgWeather:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setContent(with weather:WeatherCondition){
        let main = weather.main
        lblDegree.text = String(format:"Degree: %.2f°",main?.temp ?? 0.0)
        lblDate.text = weather.dateText?.formatby("dd MMM HH:mm", fromString: "yyyy-MM-dd HH:mm:ss")
        lblHumidity.text = String(format:"Humidity: %.2f%",main?.humidity ?? 0.0)
        if let firstWeather = weather.weathers.first{
            let urlString = String(format:AppConfig.baseIconUrl,firstWeather.icon ?? "")
            imgWeather.setImage(urlString: urlString)
        }
    }
}
