//
//  ViewController.swift
//  MVVM
//
//  Created by Uddhav on 6/24/19.
//  Copyright © 2019 Uddhav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var arrAMCVM = [ViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getData()
    }
    
    func getData() {
        
        //        let authStr = String(format:"%@","NXL1uD4w1kgSAENNsMVoSpcgMHFq64m9")
        //        let authData: Data? = authStr.data(using: .utf8)
        //        let authValue = String(format:"Basic %@",(authData?.base64EncodedString())!)
        
        ////For header
//        var headers = [String:String]()
//        headers = [
//            "Authorization": "",
//            "Content-Type": "application/json",
//            "Accept":"application/json"
//        ]
//
//
//        let body : NSDictionary = ["LoginMode":"",
//                                   "SecurityCode":"",
//                                   "Userid":""
//        ]
//
//        print(body)
       
        
     //  String(format:"%@","abc")
        WebService.sharedInstance.request(strSuburl:"SubUrl", type: "POST") { (Data,String) in
            
            DispatchQueue.main.async {
                //   CommonMethods.stopLoading(view:self.view)
                
                do{
                  
                    var arrAMCData = [Model.ArrayOfResponse]()
                    let dic = try JSONDecoder().decode(Model.AMCModel.self, from: Data)
                    print("dic: \(dic)")

                    for str in dic.ArrayOfResponse {

                        arrAMCData.append(Model.ArrayOfResponse(AMC: str.AMC!, AmcCode: str.AmcCode!))
                    }

                    print("arrAMCData : \(arrAMCData)")
                    
                    
                    self.arrAMCVM = arrAMCData.map({ return ViewModel(amc: $0)})
                    
                    self.tableView.reloadData()
                    
                }
                catch let jsonErr{
                    print("json Error: \(jsonErr.localizedDescription)")
                }
                
            }
        }
        //
    }
    
    
    //
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrAMCVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AMCTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AMCTableViewCell
        let MVM = arrAMCVM[indexPath.row]
        cell.amcNamelb.text = MVM.amcName ?? ""
        cell.amcCodelb.text = MVM.amcCode ?? ""
        
        return cell
    }
    
}
