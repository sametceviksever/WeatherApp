//
//  Reusable.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier:String{get}
}

extension Reusable{
    static var reuseIdentifier:String{return String(describing:self)}
}

extension UITableView{
    
    func registerCell<T:UITableViewCell>(type:T.Type) where T:Reusable{
        register(UINib(nibName: T.reuseIdentifier, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T:UITableViewCell>(indexPath:IndexPath) -> T where T:Reusable{
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

extension UICollectionView{
    
    func registerCell<T:UICollectionViewCell>(type:T.Type) where T:Reusable{
        register(UINib(nibName: T.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T:UICollectionViewCell>(indexPath:IndexPath) -> T where T:Reusable{
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
