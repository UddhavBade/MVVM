//
//  Model.swift
//  MVVM
//
//  Created by Uddhav on 6/25/19.
//  Copyright © 2019 Uddhav. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    struct AMCModel: Decodable {
        
        let ArrayOfResponse : [ArrayOfResponse]
        
        enum CodingKeys: String, CodingKey {
            
            case ArrayOfResponse
        }
    }
    
    struct ArrayOfResponse: Decodable
    {
        let AMC:String?
        let AmcCode:String?
        
        enum CodingKeys: String, CodingKey {
            case AMC = "AMC"
            case AmcCode = "AmcCode"
        }
        
        init(AMC:String, AmcCode:String) {
            
            self.AMC = AMC
            self.AmcCode = AmcCode
        }
    }
    
    //
}
