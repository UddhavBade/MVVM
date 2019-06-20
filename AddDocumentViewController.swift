//
//  AddDocumentViewController.swift
//  DocumentDemo
//
//  Created by Uddhav on 16/06/19.
//  Copyright © 2019 Uddhav. All rights reserved.
//

import UIKit
import CoreData

class AddDocumentViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var uploadImage: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var selectedImg = UIImage()
    
    var mobileNo = ""
    var userTpe = ""
    var imgStr = ""
    
    var imgName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    @IBAction func addDocumentAction(_ sender: UIButton) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
        
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                self.openCamera(UIImagePickerController.SourceType.camera)
                
//                imagePicker.delegate = self
//                imagePicker.sourceType = .camera;
//                imagePicker.allowsEditing = false
//                self.present(imagePicker, animated: true, completion: nil)
            }else{
                Validation.ShowAlert(vc: self, title: "", message: "Camera not available")
            }
            
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.openCamera(UIImagePickerController.SourceType.photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editDocumentAction(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteDocumentAction(_ sender: UIButton) {
        uploadImage.image = nil
    }
    
    @IBAction func submitDocumentAction(_ sender: UIButton) {
        
        if uploadImage.image == nil{
            Validation.ShowAlert(vc: self, title: "Error", message: "Upload Documnet")
        }else{

            self.saveDocuments()
            self.createFolderPath()
        }
        
        
    }
    
    func openCamera(_ sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)

    }
    
    //MARK:UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        uploadImage.image = img
        print(img!)
        imagePicker.dismiss(animated: true, completion: nil)
      //  let myImage = img!.resizeWithWidth(width: 100)!
      //  let newImg = convertImageToBase64(image: myImage)
      //  print(newImg)
        // save to core data
        
        let reSizedImg:UIImage = img!.resized(withPercentage: 0.1)!
        let imageData: Data = reSizedImg.jpegData(compressionQuality: 1)!
        let base64:String = imageData.base64EncodedString()
        
        imgStr = base64
        
        //get filename
        if #available(iOS 11.0, *) {
            guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
            
            print(fileUrl.lastPathComponent)
            
            imgName = fileUrl.lastPathComponent
            
        } else {
            // Fallback on earlier versions
        }
        
//        if let asset = info["UIImagePickerControllerPHAsset"] as? PHAsset{
//            if let fileName = asset.value(forKey: "filename") as? String{
//                print(fileName)
//            }
//        }
        
        
      //  print(base64)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerController cancel")
    }
    
    
    func saveDocuments() {
        
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
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Document")
        //     fetchRequest.predicate = NSPredicate(format: "subBrokerCode = %@", subBrokerCode)
        
        
        let fetchResults = try? context.execute(fetchRequest)
        print("fetchResults = \(String(describing: fetchResults))")
        let count = try! context.count(for: fetchRequest)
        print("count = \(count)")
        
        //  var result:NSArray = try! context.fetch(fetchRequest) as NSArray
        //
        var temp1: Document?
        
        for u: Document? in fetchResults as? [Document?] ?? [] {
            
            if (u?.mobileNo == mobileNo) {
                temp1 = u
                break
            }
            
        }
        if (temp1 != nil) {
            
            for u: Document? in fetchResults as? [Document?] ?? [] {
                
                if (u?.mobileNo == mobileNo) {
                    //    u?.imageString = _value
                    
                                            do {
                                                try context.save()
                    
                                            } catch {
                    
                                                print("Failed saving")
                                            }
                    
                 //   Validation.ShowAlert(vc: self, title: "", message:"Email already Register")
                    
                    print("Update Sucess")
                    break
                }
            }
            
        }
        else{
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Document", into: context)//entity(forEntityName: "Users", in: context)
            let imageName = "\(imgName).png"
            
            newUser.setValue(imageName, forKey: "imageString")
            newUser.setValue(mobileNo, forKey: "mobileNo")
            newUser.setValue(userTpe, forKey: "userType")
            
            print("newUser = \(newUser)")
            do {
                
                try context.save()
                
                let vc: LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            } catch {
                
                print("Failed saving")
            }
        }
    }
    
    //
    func createFolderPath(){
        
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(mainPath)
        
        let documentDirectoryPath = mainPath + "/Create Folder/"
        
        print(documentDirectoryPath)
        
        var objCtBool:ObjCBool = true
        
        let isExist = FileManager.default.fileExists(atPath: documentDirectoryPath, isDirectory: &objCtBool)
        
        if isExist == false{
            do{
        
                try FileManager.default.createDirectory(atPath: documentDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                
            }catch
            {
                print("error")
            }
        }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageName = "\(imgName).png"
        let imageUrl = documentDirectory.appendingPathComponent("Create Folder/\(imageName)")
        if let data = uploadImage.image!.jpegData(compressionQuality: 1.0){
            do {
                try data.write(to: imageUrl)
            } catch {
                print("error saving", error)
            }
        }

    }
    
    
//    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
//        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
//        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//        if let dirPath = paths.first{
//            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("Create Folder/\(nameOfImage)")
//            guard let image = UIImage(contentsOfFile: imageURL.path) else { return  UIImage.init(named: "fulcrumPlaceholder")!}
//            return image
//        }
//        return UIImage.init(named: "imageDefaultPlaceholder")!
//    }
    
  
    
    //

}
