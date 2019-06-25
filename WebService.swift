//
//  WebService.swift
//  MVVM
//
//  Created by Uddhav on 6/25/19.
//  Copyright © 2019 Uddhav. All rights reserved.
//

import UIKit

class WebService: NSObject {

    public static let sharedInstance : WebService = {
        let instance = WebService()
        return instance
    }()
    
    //MARK : POST / GET with Header and body
    public func request(strSuburl:String,dictPostParameter:NSDictionary,header:[String:String],type:String, completionBlock: @escaping (Data , _ value : String) -> Void) -> Void {
        
        //Session Configure
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        //url
        let urlString = "baseUrl" + strSuburl
        var request = URLRequest(url: URL(string: urlString)!)
        request.timeoutInterval = 60.0
        
        print(urlString)
        //post data for body
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictPostParameter, options: [])
        
        //set request
        request.httpBody = postData
        request.allHTTPHeaderFields = header
        request.httpMethod = type
        
        //data task
        let task = session.dataTask(with: request) { data, response, error in
            
            
            guard let data = data, error == nil else {
                
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                completionBlock(data,"1");
            }else{
                completionBlock(data,"0");
            }
            DispatchQueue.main.async {
                // spinnerActivity.hide(animated: true);
            }
            let responseString = String(data: data, encoding: .utf8)
            //    print("responseString = \(responseString!)")
            
        }
        task.resume()
    }
    
    //MARK : GET/POST withOut Header and body
    public func request(strSuburl:String,type:String, completionBlock: @escaping (Data , _ value : String) -> Void) -> Void {
        
        //Session Configure
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        //url
        let urlString = "http://apptest.optimumfinsol.com/api/" + strSuburl
        var request = URLRequest(url: URL(string: urlString)!)
        request.timeoutInterval = 60.0
        
        print(urlString)
      
        //set request
        request.httpMethod = type
        
        //data task
        let task = session.dataTask(with: request) { data, response, error in
            
            
            guard let data = data, error == nil else {
                
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                completionBlock(data,"1");
            }else{
                completionBlock(data,"0");
            }
            DispatchQueue.main.async {
                // spinnerActivity.hide(animated: true);
            }
            let responseString = String(data: data, encoding: .utf8)
            //    print("responseString = \(responseString!)")
            
        }
        task.resume()
    }
    //
}
