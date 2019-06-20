//
//  RegisterViewController.swift
//  DocumentDemo
//
//  Created by Uddhav on 16/06/19.
//  Copyright © 2019 Uddhav. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var segmentOutlet: UISegmentedControl!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var mobileTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!

    var userType = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.mobileTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
    }
    

    @IBAction func registerAction(_ sender: Any) {
        
        if self.isValid() == true {
        
        self.saveDetails()
        }
    }
    
    @IBAction func segmentaction(_ sender: Any) {
       
        if segmentOutlet.selectedSegmentIndex == 0 {
            
            userType = "1"
        }
        else{
            userType = "2"
        }
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        if textField == mobileTextField {
            return newLength <= 10 // Bool
        }
        
        return true
    }
    
    //MARK : Validation
   fileprivate func isValid() -> Bool {
        self.view.endEditing(true)
        if nameTextField.text?.trimWhiteSpaceAndNewLine() == "" {
            Validation.ShowAlert(vc: self, title: "", message:"Enter Name")
            return false
        }
        else if emailTextField.text?.trimWhiteSpaceAndNewLine() == "" {
            Validation.ShowAlert(vc: self, title: "", message:"Enter Email Id")
            return false
        }
        else if Validation.isValidEmail(emailStr: (emailTextField.text?.trimWhiteSpaceAndNewLine())!)  == false{
            Validation.ShowAlert(vc: self, title: "", message:"Enter valid Email")
            return false
        }
        else if mobileTextField.text?.trimWhiteSpaceAndNewLine() == "" {
            Validation.ShowAlert(vc: self, title: "", message:"Enter Mobile Number")
            return false
        }
        else if (mobileTextField.text?.trimWhiteSpaceAndNewLine().count)!<10 {
            Validation.ShowAlert(vc: self, title: "", message:"Enter valid mobile number")
            return false
        }
        else if passwordTextField.text?.trimWhiteSpaceAndNewLine() == "" {
            Validation.ShowAlert(vc: self, title: "", message:"Enter Password")
            return false
        }
        else if confirmPasswordTextField.text?.trimWhiteSpaceAndNewLine() == "" {
            Validation.ShowAlert(vc: self, title: "", message:"Enter confirm password")
            return false
        }
        else if passwordTextField.text?.trimWhiteSpaceAndNewLine() != confirmPasswordTextField.text?.trimWhiteSpaceAndNewLine() {
            Validation.ShowAlert(vc: self, title: "", message:"Password Mismatch")
            return false
        }
        else {
            return true
        }
    }
    
    
    func saveDetails() {
        
//        if (_value != ""){
//
//            let data = Data(base64Encoded: _value!, options: [])
//            if let aData = data {
//                self.profileImgView.image = UIImage(data: aData)
//            }
        
            //insert
        //    let subBrokerCode = UserDefaults.getDetails(key: "SubBrokerCode")
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            // 1
            //   let context =
            //     appDelegate.persistentContainer.viewContext
            
            var context = NSManagedObjectContext()
            if #available(iOS 10.0, *) {
                context =
                    appDelegate.persistentContainer.viewContext
            } else {
                // Fallback on earlier versions
                
                context = appDelegate.managedObjectContext
            }
            
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Register")
            //     fetchRequest.predicate = NSPredicate(format: "subBrokerCode = %@", subBrokerCode)
            
            
            let fetchResults = try? context.execute(fetchRequest)
            print("fetchResults = \(String(describing: fetchResults))")
            let count = try! context.count(for: fetchRequest)
            print("count = \(count)")
            
            //  var result:NSArray = try! context.fetch(fetchRequest) as NSArray
            //
            var temp1: Register?
            
            for u: Register? in fetchResults as? [Register?] ?? [] {

                if (u?.email == self.emailTextField.text) {
                    temp1 = u
                    break
                }

            }
            if (temp1 != nil) {

                for u: Register? in fetchResults as? [Register?] ?? [] {

                    if (u?.email == self.emailTextField.text) {
                    //    u?.imageString = _value

//                        do {
//                            try context.save()
//
//                        } catch {
//
//                            print("Failed saving")
//                        }
                        
                       Validation.ShowAlert(vc: self, title: "", message:"Email already Register")
                        
                        print("Update Sucess")
                        break
                    }
                }

            }
            else{
                let newUser = NSEntityDescription.insertNewObject(forEntityName: "Register", into: context)//entity(forEntityName: "Users", in: context)
                newUser.setValue(self.nameTextField.text, forKey: "name")
                newUser.setValue(self.emailTextField.text, forKey: "email")
                newUser.setValue(self.mobileTextField.text, forKey: "mobile")
                newUser.setValue(self.passwordTextField.text, forKey: "password")
                newUser.setValue(userType, forKey: "userType")
        
              print("newUser = \(newUser)")
                do {
                    
                    try context.save()
                    
                    
                    
                    let vc: AddDocumentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddDocumentViewController") as! AddDocumentViewController
                    vc.userTpe = userType
                    vc.mobileNo = self.mobileTextField.text!
                    self.navigationController?.pushViewController(vc, animated: true)
              
                  //  self.navigationController?.popViewController(animated: true)
                    
                } catch {
                    
                    print("Failed saving")
                }
            }
        }
    
//        else{
//            let img:String = "ic_profile_large"
//            self.profileImgView.image = UIImage(named: img)
//        }
    }
