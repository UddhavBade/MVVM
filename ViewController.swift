//
//  ViewController.swift
//  WebServiceCommonClass
//
//  Created by Amit Bachhawat on 10/12/18.
//  Copyright © 2018 Amit Bachhawat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      //  self.forgotAuthenticate()
        
      //  self.apiCall()
        self.getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func forgotAuthenticate() {
        
        let authStr = String(format:"%@","NXL1uD4w1kgSAENNsMVoSpcgMHFq64m9")
        let authData: Data? = authStr.data(using: .utf8)
        let authValue = String(format:"Basic %@",(authData?.base64EncodedString())!)
        
        ////For header
        var headers = [String:String]()
        headers = [
            "Authorization": authValue,
            "Content-Type": "application/json",
            "Accept":"application/json"
        ]
        
        
        let body : NSDictionary = ["LoginMode":"subbroker",
                                   "SecurityCode":"",
                                   "Userid":"1506"
        ]
        
        print(body)
        
     //strSubUrl //  String(format:"%@%@",SUBBROKER_DETAILS,subBrokerId)
        
        WebService.sharedInstance.request(strSuburl: "", dictPostParameter: body, header: headers, type: "POST") { (Data,String) in
            
            DispatchQueue.main.async {
             //   CommonMethods.stopLoading(view:self.view)
                
                do {
                    let dic = try JSONDecoder().decode(Model.ForgotPasswordModel.self, from: Data)
                    print("dic:\(dic)")
                    
                   
                    
                }catch let err{
                    print(err)
                }
            }
        }
    }
    
    //
    //
    
    func getData()
    {
        //base64 string
        
        //        let authStr = String(format:"%@","onpg8Y2x1UhFz5MJRs32RJjTrE/1b7Gc")
        //        let authStr = String(format:"%@",userLoginData.TokenId?.description ?? "")
        //        let authData: Data? = authStr.data(using: .utf8)
        //        let authValue = String(format:"Basic %@",(authData?.base64EncodedString())!)
        
        ////For header
        var headers = [String:String]()
        headers = [
            "Authorization": "",
            "Content-Type": "application/json",
            "Accept":"application/json"
        ]
        
        //        //For body
        //        let body = [
        //            "Action": "a",
        //            "ClientBasicInfoId": "b",
        //            "Password": "c"
        //            ] as [String : Any]
        
        
        //Session Configure
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        //url
        let url = URL(string: "baseUrl")
        
        //request
        var request: NSMutableURLRequest? = nil
        if let anUrl = url {
            request = NSMutableURLRequest(url: anUrl)
        }
        
        //post data for body
        //        print(body)
        //        let postData: Data? = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        
        //  set request
        // request?.httpBody = postData
        request?.allHTTPHeaderFields = headers
        request?.httpMethod = "POST"
        
        //data task
        let dataTask = session.dataTask(with: request! as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async(execute: {() -> Void in
                if error == nil
                {
                    let dict = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print("dict:\(dict)")
//                self.arrayOfResponse = dict.object(forKey: "ArrayOfResponse") as! NSArray
//
//                for item in arrayOfResponse {
//
//                }
//                    self.myTableView.reloadData()
                }
                else
                {
                    print("error:\(String(describing: error))")
                }
            }) //end dispath main queue
        })
        dataTask.resume()
    }
    //
}

