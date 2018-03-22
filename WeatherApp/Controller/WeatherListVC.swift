//
//  DetailPage.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import UIKit

class WeatherListVC: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    
    var response:Response!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI(){
        title = response.city.name
        tableView.registerCell(type: WeatherTVC.self)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension WeatherListVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WeatherTVC = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.setContent(with: response.list[indexPath.row])
        
        return cell
    }
}

extension WeatherListVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WeatherDetailVC") as? WeatherDetailVC{
            let item = response.list[indexPath.row]
            vc.weather = item
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
