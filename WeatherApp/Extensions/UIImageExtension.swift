//
//  UIImageExtension.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(url: URL?, placeholder: UIImage? = nil) {
        
        if let _url = url {
            self.kf.setImage(with: _url, placeholder:placeholder)
        }
        
    }
    
    func setImage(urlString: String?, placeholder: UIImage? = nil) {
        guard let _urlString = urlString else {
            image = placeholder
            return
        }
        setImage(url: URL(string: _urlString), placeholder:placeholder)
    }
}
