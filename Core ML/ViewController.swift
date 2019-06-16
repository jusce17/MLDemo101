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
    




    
       
    
    picker.dismiss(animated: true)
    classifier.text = "Analyzing Image..."
    guard let image = info[.originalImage] as? UIImage else {
        return
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 227, height: 227), true, 2.0)
    image.draw(in: CGRect(x:0, y:0, width: 227, height: 227))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
    
    var pixelBuffer : CVPixelBuffer?
    let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
    guard (status == kCVReturnSuccess) else {
        return
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
    
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
    
    context?.translateBy(x: 0, y: newImage.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)
    
    UIGraphicsPushContext(context!)
    newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
    UIGraphicsPopContext()
    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
   // imageView.image = newImage  Allowing the image to remain its original size
    
    guard let prediction = try? model.prediction(image: pixelBuffer!) else{
        classifier.text = "Failed"
        return
    }
   
     classifier.text = " \(prediction.classLabel) "
    
    }
    
 
}

extension ViewController: UIImagePickerControllerDelegate { // extending the class
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
          // in case the use cancels, not working yet
    }
    
    
    
    
 
}


    

    



