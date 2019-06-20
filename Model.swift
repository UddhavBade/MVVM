//
//  Model.swift
//  WebServiceCommonClass
//
//  Created by Uddhav on 10/12/18.
//  Copyright © 2018 Uddhav. All rights reserved.
//

import UIKit

class Model: NSObject {

    //MARK : Forgot Password
    struct ForgotPasswordModel:Decodable {
        let LoginMode:String
        let SecurityCode:String
        let Userid:String
        
        enum CodingKeys:String,CodingKey{
            case LoginMode = "LoginMode"
            case SecurityCode = "SecurityCode"
            case Userid = "Userid"
            
        }
    }
}
