//
//  ViewController.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtCity:UITextField!
    @IBOutlet weak var tableView:UITableView!
    
    var cities:[CoreCity] = [CoreCity](){
        didSet{
            tableView.reloadData()
        }
    }
    
    var item:Response?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI(){
        cities = CoreData.shared.getCityData()
    }

    @IBAction func getWeatherByCityName(){
        let name = txtCity.text ?? ""
        if name != ""{
            let locale = Locale(identifier: "en_US")
            let elementLower = name.lowercased(with: locale)
            let engName = convertTurkishCharacters(string: elementLower)
            
            getWeather(cityName: engName, then: {[weak self] (cityName) in
                if let city = CoreData.shared.saveCity(cityName: cityName){
                    self?.cities.insert(city, at: 0)
                }
            })
        }
    }
    
    fileprivate func getWeather(cityName:String,then:((String)->())?){
        let parameters = ["q":cityName,"units":"metric"]
        Network.shared.JSONGet(url: AppConfig.baseUrl, parameters: parameters, header: nil, complationHandler: { [weak self] (json, error) in
            if let _ = error{
                
            } else if let json = json {
                let item = Response(with: json)
                self?.item = item
                then?(item.city.name)
                self?.navigateDetail()
            }
        })
    }
    
    fileprivate func navigateDetail(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailPage") as? WeatherListVC{
            vc.response = item
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func convertTurkishCharacters(string:String) -> String{
        let turkishCharacters = ["ı","i̇","ş","ü","ğ","ö","ç"]
        let englishCharacters = ["i","i","s","u","g","o","c"]
        var str = ""
        for char in string{
            if let index = turkishCharacters.index(of: String(char)){
                str += englishCharacters[index]
            } else {
                str += String(char)
            }
        }
        
        return str
    }
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].cityName
        
        return cell
        
    }
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        getWeather(cityName: city.cityName) { [weak self](_) in
            CoreData.shared.updateCity(uuid: city.uuid, cityName: city.cityName)
        }
    }
}



