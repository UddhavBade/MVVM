//
//  LoginViewController.swift
//  DocumentDemo
//
//  Created by Uddhav on 16/06/19.
//  Copyright © 2019 Uddhav. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
                UINavigationBar.appearance().tintColor = .white
                self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    @IBAction func loginAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("Ok")
            
            if self.isValid() == true {
            
                self.getRegisterDetails()
                
//               let vc: DashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
//               self.navigationController?.pushViewController(vc, animated: true)
              
                
           }
        default:
            print("reg")
            
            let vc: RegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.40
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false)
    }
    //validation
    fileprivate func isValid() -> Bool {
        if emailTextField.text?.trimWhiteSpaceAndNewLine() == "" {
            Validation.ShowAlert(vc: self, title: "", message:"Enter Email")
            return false
        }
        else if passwordTextField.text?.trimWhiteSpaceAndNewLine() == "" {
            Validation.ShowAlert(vc: self, title: "", message:"Enter Password")
            return false
        }
        else {
            return true
        }
    }
    
    
    func getRegisterDetails() {
        
    //    let subBrokerCode = UserDefaults.getDetails(key: "SubBrokerCode")
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        var context = NSManagedObjectContext()
        if #available(iOS 10.0, *) {
            context =
                appDelegate.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            
            context = appDelegate.managedObjectContext
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Register")
        let result = try? context.fetch(request)
        
        
        for u: Register? in result as? [Register?] ?? [] {
            //            let subCode = u?.subBrokerCode
            //            NSLog("subCode =\(String(describing: subCode))");
            
             print("email =\(u)")
            
            if (u?.email == self.emailTextField.text) {
                let email = u?.email
                let name = u?.name
                let mobile = u?.mobile
                let password = u?.password
                let userType = u?.userType
                
                print("email =\(email ?? "")")
                print("name =\(name ?? "")")
                print("mobile =\(mobile ?? "")")
                print("password =\(password ?? "")")
                print("userType =\(userType ?? "")")
                
                UserDefaults.standard.set(email, forKey: "USER_EMAIL")
                UserDefaults.standard.set(name, forKey: "USER_NAME")
                UserDefaults.standard.set(mobile, forKey: "USER_MOBILE")
                UserDefaults.standard.set(userType, forKey: "USER_TYPE")
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                
                let DashBoardViewController = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                
                self.presentDetail(SWRevealViewController)
               
            }
        }
        
    }
}

