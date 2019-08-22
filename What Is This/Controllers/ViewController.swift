//
//  ViewController.swift
//  SeaFood
//
//  Created by Destiny Sopha on 8/22/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import CoreML
import Vision // will help process images more easily and work with CoreML without writing lots of code

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var imageView: UIImageView!
  
  let cameraImagePicker = UIImagePickerController()
  let photosImagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    photosImagePicker.delegate = self
    photosImagePicker.sourceType = .photoLibrary
    photosImagePicker.allowsEditing = false
    
    cameraImagePicker.delegate = self
    cameraImagePicker.sourceType = .camera // use .photoLibrary in plave of .camera to choose photos instead of the camera
    cameraImagePicker.allowsEditing = false
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      imageView.image = userPickedImage
      
      guard let ciimage = CIImage(image: userPickedImage) else {
        fatalError("Could not convert to CIImage")
        
      }
      
      detect(image: ciimage)
      
    }
    
    cameraImagePicker.dismiss(animated: true, completion: nil)
    photosImagePicker.dismiss(animated: true, completion: nil)
    
  }
  
  
  func detect(image: CIImage) {
    
    guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
      fatalError("Loading the CoreML model failed.")
    }
    
    let request = VNCoreMLRequest(model: model) { (request, error) in
      guard let results = request.results as? [VNClassificationObservation] else {
        fatalError("Model failed to process the image.")
      }
      
//      if let firstResult = results.first {
//        if firstResult.identifier.contains("hotdog") {
//          self.navigationItem.title = "Hotdog!"
//        } else {
//          self.navigationItem.title = "Not Hotdog!"
          
      
        if let firstResult = results.first {                     // This line checks to see that the first results we get back definitely has a value
//          if firstResult.identifier. {                           // Is there a way to use this line to check for a level of confidence over 50% ?
            self.navigationItem.title = firstResult.identifier   // Prints the first result (highest confidence) in the Navigator Title Bar
//        } else {
//          self.navigationItem.title = "Unidentified Object"    // Would print "Unidentified Oject" if the confidence level is below 50%
          
//      }
        
      }
      
    }
    
    let handler = VNImageRequestHandler(ciImage: image)
    
    do {
      try handler.perform([request])
    }
    catch {
      print(error)
    }
    
  }
  
  
  @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
    
    present(cameraImagePicker, animated: true, completion: nil)
    
  }
  
  @IBAction func photoButtonTapped(_ sender: UIBarButtonItem) {
    
    present(photosImagePicker, animated: true, completion: nil)
    
  }
}

