//
//  ViewController.swift
//  Core ML
//
//  Created by Eden Juscelino on 16/06/2019.
//  Copyright © 2019 Eden Juscelino. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classifier: UILabel!
    
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var photoLibrary: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func camera(_ sender: Any) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        present(cameraPicker, animated: true)
        
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate =  self
        picker.sourceType = .photoLibrary
       // present(picker, animated: true)
        present(picker, animated: true, completion: nil)
        
        
        
    }
    
    var model: SqueezeNet!
    
    override func viewWillAppear(_ animated: Bool) {
        model = SqueezeNet()
    }
    
    /*
     *   advanced Core Image
     *   Converting the Image in a way the data model can read
     */
    
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        imageView.isHidden = false
        imageView.image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage; dismiss(animated: true, completion: nil)
    
       
    

    
    }
    
 
}

extension ViewController: UIImagePickerControllerDelegate { // extending the class
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
          // in case the use cancels, not working yet
    }
    
    
    
    
 
}

