//
//  Network.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias requestWithHandler = (request: URLRequest, completionHandler: ((Data?, WeatherError?) -> ())?)
class Network:NetworkBase{
    #if TEST
    static var isMock:Bool = true
    #else
    static var isMock:Bool = false
    #endif
    
    var requests: [(request: URLRequest, completionHandler: ((Data?, WeatherError?) -> ())?)] = [requestWithHandler]()
    
    static let shared = Network()
    
    private func request(url:String,
              parameters:[String:Any]? = nil,
              timeoutInterval:TimeInterval = 45,
              methodType:MethodType = .get,
              contentType:ContentType = .none,
              header:[String:String]? = nil,
              complationHandler:@escaping (_ data:Data?,_ error:WeatherError?)->()){
        
        if Network.isMock,let data = Network.readDataFromFile(with: url){
            complationHandler(data,nil)
        }
        
        if let url = URL(string:url){
            let request = createReuqest(path: url, paramters: parameters, timeoutInterval: timeoutInterval, methodType: methodType, contentType: contentType, header: header)
            startSession(request: request, completionHandler: complationHandler)
        }
    }
    
    func getCodableForTest<T:Codable>(codableType:T.Type,url:String) -> T?{
        if let data = Network.readDataFromFile(with: url){
            if let item = try? JSONDecoder().decode(codableType, from: data){
                return item
            }
        }
        return nil
    }
    
    func getJSONForTest(url:String) -> JSON?{
        if let data = Network.readDataFromFile(with: url){
            return JSON(data)
        }
        return nil
    }
    
    func JSONPost(url:String,
                  parameters:[String:Any]? = nil,
                  timeoutInterval:TimeInterval = 45,
                  contentType:ContentType = .none,
                  header:[String:String]? = nil,
                  complationHandler:@escaping (_ data:JSON?,_ error:WeatherError?)->()){
        
        request(url: url, parameters: parameters, timeoutInterval: timeoutInterval, methodType: .post, contentType: contentType, header: header) { (data, error) in
            if let error = error{
                complationHandler(nil, error)
            } else if let data = data{
                let json = JSON(data)
                complationHandler(json, nil)
            } else {
                complationHandler(nil,nil)
            }
        }
    }
    
    func JSONGet(url:String,
                 parameters:[String:Any]? = nil,
                 timeoutInterval:TimeInterval = 45,
                 header:[String:String]? = nil,
                 complationHandler:@escaping (_ data:JSON?,_ error:WeatherError?)->()){
        
        request(url: url, parameters: parameters, timeoutInterval: timeoutInterval, methodType: .get, contentType: .none, header: header) { (data, error) in
            if let error = error{
                complationHandler(nil, error)
            } else if let data = data{
                let response = JSON(data)
                print("--------------\(url.split(separator: "/").last ?? "") Response---------------")
                print(response)
                complationHandler(response, nil)
                print("-----------------------------------------------")
            } else {
                complationHandler(nil,nil)
            }
        }
    }
    
    func codableGet<T:Codable>(codableType:T.Type,
                               url:String,
                               parameters:[String:Any]? = nil,
                               timeoutInterval:TimeInterval = 45,
                               header:[String:String]? = nil,
                               complationHandler:@escaping (_ item:T?,_ error:WeatherError?)->()){
        request(url: url, parameters: parameters, timeoutInterval: timeoutInterval, methodType: .get, contentType: .none, header: header) { (data, error) in
            if let error = error{
                complationHandler(nil, error)
            } else if let data = data{
                    if let item = try? JSONDecoder().decode(codableType, from: data){
                        complationHandler(item, nil)
                    } else {
                        complationHandler(nil,nil)
                    }
            } else {
                complationHandler(nil,nil)
            }
        }
        
    }
    
    static func readDataFromFile(with url:String?) -> Data?
    {
        if let fileName = url?.components(separatedBy: "/").last{
            if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                do {
                    
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    return data
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                print("Invalid filename/path.")
            }
        }
        return nil
    }
}
