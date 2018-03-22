//
//  NetworkBase.swift
//  BayindirApp
//
//  Created by Samet Çeviksever on 05/01/2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import Foundation

struct WeatherError{
    let statusCode:String?
    let desc:String?
    
    init(error:Error){
        statusCode = "404"
        desc = error.localizedDescription
    }
    
    init(error:HTTPError) {
        statusCode = error.rawValue
        desc = "Request Wrong"
    }
}

enum ContentType:String{
    case json = "application/json; charset=utf-8"
    case urlencoded = "application/x-www-form-urlencoded"
    case none = ""
}

enum MethodType:String{
    case post = "POST"
    case get = "GET"
}

enum HTTPError:String{
    case unAuthorized = "401"
    case wrong = "404"
    case serverNotAvaible = "500"
}

protocol NetworkBase:class{
    var requests:[requestWithHandler] {get set}
    func createRequest(path:URL,paramters:[String:Any]?,timeoutInterval:TimeInterval,methodType:MethodType,contentType:ContentType,header:[String:String]?) -> URLRequest
    func startSession(request:URLRequest,completionHandler:((Data?,WeatherError?)->())?)
}

extension NetworkBase{
    
    func startSession(request:URLRequest,completionHandler:((Data?,WeatherError?)->())?){
        
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: request) { [unowned self](data, urlResponse, error) in
                if let error = error{
                    let wError = WeatherError(error: error)
                    DispatchQueue.main.async {
                        completionHandler?(nil,wError)
                    }
                    return
                }
                
                if let httpError = self.responseHasHTMLError(urlResponse: urlResponse){
                    let error = WeatherError(error: httpError)
                    completionHandler?(nil,error)
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completionHandler?(nil,nil)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completionHandler?(data,nil)
                }
                }.resume()
        }
    }
    
    func createReuqest(path:URL,paramters:[String:Any]? = nil,timeoutInterval:TimeInterval = 45,methodType:MethodType = .get,contentType:ContentType = .none,header:[String:String]? = nil) -> URLRequest{
        return createRequest(path: path, paramters: paramters, timeoutInterval: timeoutInterval, methodType: methodType, contentType: contentType, header: header)
    }
    
    func createRequest(path:URL,paramters:[String:Any]?,timeoutInterval:TimeInterval,methodType:MethodType,contentType:ContentType,header:[String:String]?) -> URLRequest{
        var urlPath = path
        if methodType == .get{
            let str = String(format:"%@%@",urlPath.absoluteString,createGetRequestBody(parameters: paramters))
            if let url = URL(string: str){
                urlPath = url
            }
        }
        var request = URLRequest(url: urlPath, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        request.allHTTPHeaderFields = header
        if contentType != .none{
            request.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        request.httpMethod = methodType.rawValue
        if let paramters = paramters{
            request.httpBody = httpBodyWithParamtersFor(contentType: contentType, parameters: paramters)
        }
        
        return request
    }
    
    fileprivate func createGetRequestBody(parameters:[String:Any]?) -> String{
        if let parameters = parameters{
            var str = "?"
            parameters.forEach({ (key,value) in
                str = String(format:"%@%@=\(value)&",str,key)
            })
            str = String(format:"%@APPID=%@",str,AppConfig.APIKey)
            return str
        }
        
        return ""
    }
    
    fileprivate func httpBodyWithParamtersFor(contentType:ContentType,parameters:[String:Any]) -> Data?{
        switch contentType {
        case .json:
            do{
                return try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            }catch _{
                return nil
            }
        case .urlencoded:
            var str = ""
            parameters.forEach({ (key:String,value:Any) in
                str = String(format:"%@%@=\(value)&",str,key)
            })
            _ = str.removeLast()
            
            return str.data(using: .ascii)
        default:
            return nil
        }
    }
    
    private func responseHasHTMLError(urlResponse: URLResponse?) -> HTTPError? {
        
        if let httpUrlResponse = urlResponse as? HTTPURLResponse {
            let errorCode = String(format: "%d", httpUrlResponse.statusCode)
            if let error = HTTPError(rawValue: errorCode){
                return error
            }
        }
        return nil
    }
    
    private func getFieldFromHeader(fields: [AnyHashable : Any], key: String) -> String? {
        
        if let value = fields[key] as? String {
            
            if !value.isEmpty {
                return value
            } else {
                return nil
            }
            
        } else {
            return nil
        }
    }
}

