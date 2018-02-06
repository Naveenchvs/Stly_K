//
//  FAServiceHelper.swift
//  Fashion180
//
//  Created by Srinivas Peddinti on 5/8/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

class FAServiceHelper: NSObject,URLSessionDelegate
{

    typealias FAPostCompletionHandler = (Bool?, String?, AnyObject?) -> Swift.Void
    
    typealias FAGetCompletionHandler = (Bool?, String?, AnyObject?) -> Swift.Void


    func initialPost(url:String, parameters:NSDictionary, completion: @escaping FAPostCompletionHandler)
    {
        
        let request = NSMutableURLRequest(url: NSURL(string:url)! as URL)
        
        let session = URLSession.shared
       
        request.httpMethod = "POST"
       
        request.allHTTPHeaderFields = ["Content-Type":"application/json; charset=utf-8", Urls.AccessToken: Urls.AccessTokenValue]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard data != nil else
            {
                ///print("no data found: \(error)")
                return
            }
            
            do
            {
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? AnyObject
                {
                    DispatchQueue.main.async
                    {
                    completion(true, nil, json)
                    }
                }
                else
                {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    ///print("Error could not parse JSON: \(jsonStr)")
                    ///failed
                    completion(false, jsonStr as String?, nil)

                }
            }
            catch let parseError
            {
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                ///print("Error could not parse JSON: '\(jsonStr)'")
                completion(false, jsonStr as String?, nil)

            }
        }
        
        task.resume()
    }
   
    func post(url:String, parameters:NSDictionary, completion: @escaping FAPostCompletionHandler)
    {
        
        let request = NSMutableURLRequest(url: NSURL(string:url)! as URL)
        
        let session = URLSession.shared
        
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = ["Content-Type":"application/json; charset=utf-8", Urls.AccessToken: Wardrober.shared().serviceAccessToken!]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard data != nil else
            {
                ///print("no data found: \(error)")
                return
            }
            
            do
            {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? AnyObject
                {
                    DispatchQueue.main.async
                    {
                       completion(true, nil, json)
                    }
                }
                else
                {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    ///print("Error could not parse JSON: \(jsonStr)")
                    ///failed
                    completion(false, jsonStr as String?, nil)
                    
                }
            }
            catch let parseError
            {
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                ///print("Error could not parse JSON: '\(jsonStr)'")
                completion(false, jsonStr as String?, nil)
                
            }
        }
        
        task.resume()
    }

    func get(url:String, completion: @escaping FAGetCompletionHandler)
    {
        
        let request = NSMutableURLRequest(url: NSURL(string:url)! as URL)
        
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = ["Content-Type":"application/json; charset=utf-8", Urls.AccessToken: Wardrober.shared().serviceAccessToken!]
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard data != nil else
            {
                //print("no data found: \(error)")
                return
            }
            
            do
            {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? AnyObject
                {
                    DispatchQueue.main.async
                    {
                       completion(true, nil, json)
                    }
                }
                else
                {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    //No error thrown, but not NSDictionary
                    //print("Error could not parse JSON: \(jsonStr)")
                    //failed
                    completion(false, jsonStr as String?, nil)
                }
            }
            catch let parseError
            {
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("Error could not parse JSON: '\(jsonStr)'")
                completion(false, jsonStr as String?, nil)
            }
        }
        
        task.resume()
    }
}
