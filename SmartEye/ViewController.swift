//
//  ViewController.swift
//  SmartEye
//
//  Created by Sultan Sidhu on 2018-10-26.
//  Copyright © 2018 Sultan Sidhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var chosenImage: UIImageView!
    
    @IBAction func browseLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            var imagePicker = UIImagePickerController();
            imagePicker.delegate = self;
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true;
            print("This boi works!");
            
        }
    }
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            var imagePicker = UIImagePickerController();
            imagePicker.delegate = self;
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false;
            print("This works!");
            //self.presentedViewController(imagePicker, animated: true, completion: nil);
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage;
        chosenImage.image = image;
        dismiss(animated: true, completion: nil);
        
    }
    
    func getChosenImage() -> UIImage?{
        if (chosenImage.image != nil){
            return chosenImage.image
            // returns a UIImage object.
        } else {
            print("The image has not been chosen");
            return nil;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    


}

