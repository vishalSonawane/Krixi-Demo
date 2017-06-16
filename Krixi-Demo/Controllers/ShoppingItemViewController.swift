//
//  ShoppingITemViewController.swift
//  Krixi-Demo
//
//  Created by Vishal Sonawane on 14/06/17.
//  Copyright © 2017 Vishal Sonawane. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Floaty
import CoreData


class ShoppingItemViewController: UIViewController {

   var addBarButton = UIBarButtonItem()
    @IBOutlet weak var tableView: UITableView!
    let picker = UIImagePickerController()
    var pantShirtImages = [Images]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //remove all items if any to avoid duplications
        Floaty.global.button.items.removeAll()
        Floaty.global.button.buttonColor = UIColor.green
        Floaty.global.button.addItem("Add Pant/Shirt Picture", icon: UIImage(named: "iconCamera")) { (item) in
            self.uploadImage()
            Floaty.global.hide()
            
        }
        Floaty.global.button.addItem("Logout", icon: UIImage(named: "iconLogout")) { (item) in
            let loginSignUpNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginSignupNavigationController") as! UINavigationController
            let window = (UIApplication.shared.delegate as! AppDelegate).window
                window?.rootViewController = loginSignUpNVC
            window?.makeKeyAndVisible()
            Floaty.global.hide()
        }
     
       
        self.title = "Arrivals"
        self.navigationController?.navigationBar.isHidden = false
        picker.delegate = self
        //Remove unnecessary footer view
        tableView.tableFooterView  = UIView()
        
    }
  
}

extension ShoppingItemViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if pantShirtImages.isEmpty {
            Floaty.global.hide()
        }else{
            Floaty.global.show()
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pantShirtImages.isEmpty ? 0 : 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        let titleTextAttributedString = [NSFontAttributeName: UIFont.systemFont(ofSize: 18),
                                         NSForegroundColorAttributeName: UIColor.black]
        
        switch indexPath.row {
        case 0:
            
            let titleText = NSAttributedString(string: "Browse collection of Shirt/Pant", attributes: titleTextAttributedString)
            cell.textLabel?.attributedText = titleText
            let detailsTextAttributedString = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                                               NSForegroundColorAttributeName: UIColor.black]
            let detailsText = NSAttributedString(string: "\(pantShirtImages.count) items", attributes: detailsTextAttributedString)
            cell.detailTextLabel?.attributedText = detailsText
        case 1:
            let titleText = NSAttributedString(string: "Your saved collection", attributes: titleTextAttributedString)
            cell.textLabel?.attributedText = titleText
            
        default:
            break
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 0:
            let shoppingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BackgroundAnimationViewController") as! BackgroundAnimationViewController
            shoppingVC.shirtPantsImages = pantShirtImages
            self.navigationController?.show(shoppingVC, sender: nil)
        case 1:
            //check for registered user
            let context = (UIApplication.shared.delegate as! AppDelegate).getContext()
            var favoriteImages = [Images]()
            var allImages = [Images]()
            //Get users
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
            do {
                allImages = try context.fetch(fetchRequest) as! [Images]
                for image in allImages {
                    if image.isFavorite{
                        favoriteImages.append(image)
                    }
                }
                if favoriteImages.isEmpty {
                    Utils.showError(MESSAGE_NO_FAVORITES_FOUND, viewController: self)
                    return
                }

            } catch  {
                print("Error while fetching images")
            }
            
            let favoritesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavouritesTableViewController") as! FavouritesTableViewController
            favoritesVC.imagesDataSource = favoriteImages
            self.navigationController?.show(favoritesVC, sender: nil)
            
        default:
            break
        }
        
    }
}

extension ShoppingItemViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "iconEmptyData")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let msg = MESSAGE_EMPTY_DATA
        
        let attributedString = [NSFontAttributeName: UIFont.systemFont(ofSize: 18),
                                NSForegroundColorAttributeName: UIColor.darkGray]
        
        return NSAttributedString(string: msg, attributes: attributedString)
        
    }
  
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let textColor =  state == .normal ? UIColor(red: 0, green: 122/255, blue: 1, alpha: 1.0) : UIColor(red: 198/255, green: 222/255, blue: 249/255, alpha: 1.0)
        
        let attributedString = [NSFontAttributeName: UIFont.systemFont(ofSize: 18),
                                NSForegroundColorAttributeName: textColor]
        
        return NSAttributedString(string: "Add Pant/Shirt", attributes: attributedString)
    }
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        print("Add Pant/Shirt tapped....")
        uploadImage()
    }
    
}

extension ShoppingItemViewController :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    //Show alert to pick image from
    func uploadImage() {
        //let user choose to upload from libarry or camera
        let alert = UIAlertController(title: nil, message: MESSAGE_TAKE_PHOTO_FROM, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Camera selected")
            //Code for Camera
            self.openCamera()
            
        })
        alert.addAction(UIAlertAction(title: "Photo library", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Photo Library selected")
            //Code for Photo library
            self.openPhotoLibrary()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            Floaty.global.show()
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    //Open camera to click photo
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }}
    //Open photo library to choose photo
    func openPhotoLibrary(){
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
       
        present(picker, animated: true, completion: nil)
        
    }
    
    //Show alert for devices which dont have camera
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    //Operate on the selected image here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.getContext()
        
        //Create new Images object and then save image
        let imageToAdd = Images(context: context)
        imageToAdd.id = UUID().uuidString
        imageToAdd.userId = currentUser?.id
        imageToAdd.imageValue = UIImagePNGRepresentation(chosenImage) as NSData?
        
        do {
            currentUser?.addToClothsPair(imageToAdd)
            try context.save()
            
        } catch  {
            print(error.localizedDescription)
        }
        
        pantShirtImages.append(imageToAdd)
        picker.dismiss(animated: true, completion: nil)
        tableView.reloadData()
        
        //post notification to reload data on backgroundAnimationVc
        NotificationCenter.default.post(name: Notification.Name(rawValue: "imageAdded"), object: imageToAdd)
        Floaty.global.show()
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        Floaty.global.show()
    }
    
}
