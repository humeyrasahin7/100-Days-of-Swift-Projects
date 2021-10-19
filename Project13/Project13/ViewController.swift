//
//  ViewController.swift
//  Project13
//
//  Created by Hümeyra Şahin on 19.10.2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var intensityLabel: UILabel!
    
    @IBOutlet var radius: UISlider!
    
    @IBOutlet var radiusLabel: UILabel!
    
    @IBOutlet var changeButton: UIButton!
    
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Filters ^"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    
    @objc func addPhoto(){
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        currentImage = image
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        
    }
    

    @IBAction func changeFilter(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "choose filter", message: nil, preferredStyle: .actionSheet)
        //ac.addAction(UIAlertAction(title: "CIBumpDisdortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
        
    }
    
    func setFilter(action: UIAlertAction){
        
        guard currentImage != nil else {return}
        guard let actionTitle = action.title else {return}
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        let buttonName = actionTitle
        changeButton.titleLabel?.text = buttonName
        
        
        
        applyProcessing()
                
        
    }
                     
                     
    @IBAction func save(_ sender: Any) {
        
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "there is no image!!", message: "please select an image to edit", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)),nil)
        
    }
    @IBAction func intensityChange(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func radiusChange(_ sender: Any) {
        
        applyProcessing()
    }
    
    
    func applyProcessing(){
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            radius.isHidden = true
            radiusLabel.isHidden = true
            intensity.isHidden = false
            intensityLabel.isHidden = false
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey){
            radiusLabel.isHidden = false
            radius.isHidden = false
            intensity.isHidden = true
            intensityLabel.isHidden = true
            currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey){
            radius.isHidden = true
            radiusLabel.isHidden = true
            intensity.isHidden = false
            intensityLabel.isHidden = false
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey){
            radius.isHidden = true
            radiusLabel.isHidden = true
            intensity.isHidden = false
            intensityLabel.isHidden = false
            currentFilter.setValue(CIVector(x: currentImage.size.width/2, y: currentImage.size.height/2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            let ac = UIAlertController(title: "save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "your filtered image has been saved", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
}

