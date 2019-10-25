//
//  ViewController.swift
//  SeeFood
//
//  Created by umer hamid on 10/24/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    
    @IBOutlet weak var textView: UITextView!
    
    let image = UIImagePickerController()
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        image.delegate = self
        image.sourceType = .camera
        image.allowsEditing = false
        
        self.textView.isEditable = false
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            // print(UIImagePickerController.InfoKey.originalImage.rawValue)
            
            guard  let ciImage = CIImage(image: imagePicked) else {
                fatalError("could not covert UIImage into CIImage")
            }
            
            detect(image: ciImage)
            
            imageView.image = imagePicked
            
            
        
            }
        
      //  detect(image: ciImage)
         //
        
      
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func detect(image : CIImage)
    {
     
       
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
               fatalError("loading coreML Model fail")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")
            }
            print(result)
            
            if let firstResult = result.first {
                
             // its for specific sear
//                if firstResult.identifier.contains("dog") {
//                    // here is somethin
//                }
                // end
                
                
                let percentage = Double(round(firstResult.confidence * 100))
                
                let name = firstResult.identifier
                
                self.textView.text = "\(name) (\(percentage) %)"
                
           
              //00  let top5 = firstResult.identifier
              //  print("here is top5 : \(top5)")
                // Double($0.confidence)) }

            }
        }
      
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        present(image, animated: true, completion: nil)
    }
    

}

