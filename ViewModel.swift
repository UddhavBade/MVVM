//
//  ViewModel.swift
//  MVVM
//
//  Created by Uddhav on 6/25/19.
//  Copyright © 2019 Uddhav. All rights reserved.
//

import UIKit

class ViewModel: NSObject {

    var amcName: String?
    var amcCode: String?
    
    //is called Dependancy Injection
    
    init(amc:Model.ArrayOfResponse){
        
        self.amcName = amc.AMC
        self.amcCode = amc.AmcCode
        
    }
}
