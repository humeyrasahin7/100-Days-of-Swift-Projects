//
//  ViewController.swift
//  Milestone 9
//
//  Created by Hümeyra Şahin on 18.11.2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    var isBottomText = true
    var text = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create Meme"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
    }
    
    @objc func shareTapped(){
        guard let image = imageView.image?.jpegData(compressionQuality: 1) else {
            print("No Image Found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        
    }
    
    @objc func addTapped(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        self.imageView.image = image
        self.dismiss(animated: true)
    }
    @IBAction func addTop(_ sender: Any) {
        isBottomText = false
        let ac = UIAlertController(title: "Add Text to Top", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "ADD", style: .default, handler: { [weak self, weak ac] action in
            
            self!.text = (ac?.textFields![0].text!)!
            print(self!.text)
            self!.addText(action: action)
            
            
        }))
       
        
        present(ac, animated: true)
    }
    
    @IBAction func addBottom(_ sender: Any) {
        isBottomText = true
        let ac = UIAlertController(title: "Add Text to Bottom", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "ADD", style: .default, handler: { [weak self, weak ac] action in
            
            self!.text = (ac?.textFields![0].text!)!
            print(self!.text)
            self!.addText(action: action)
        
        }))
        
        present(ac, animated: true)
    }
    
    func addText(action: UIAlertAction){
        let image = imageView.image!
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let renderedImage = renderer.image { [weak self] ctx in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            if isBottomText {
                drawText(text: self!.text, rendererSize: image.size, isBottomText: isBottomText)
            } else if isBottomText == false{
                drawText(text: self!.text, rendererSize: image.size, isBottomText: isBottomText)
            }
            
            
        }

        imageView.image = renderedImage
        
    }
    
    func drawText(text: String, rendererSize: CGSize, isBottomText: Bool) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        // accomodate all images sizes
        let sidesLength = rendererSize.width + rendererSize.height
        let fontSize = sidesLength / 30
        
        let attrs: [NSAttributedString.Key : Any] = [
            .strokeWidth: -2.0,
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue", size: fontSize)!,
            .paragraphStyle: paragraphStyle
        ]
        
        let margin = 32
        let textWidth = Int(rendererSize.width) - (margin * 2)
        let textHeight = computeTextHeight(for: text, attributes: attrs, width: textWidth)
        
        var startY: Int
        switch isBottomText {
        case false:
            startY = margin
        case true:
            startY = Int(rendererSize.height) - (textHeight + margin)
        }
        
        text.draw(with: CGRect(x: margin, y: startY, width: textWidth, height: textHeight), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }
    
    func computeTextHeight(for text: String, attributes: [NSAttributedString.Key : Any], width: Int) -> Int {
        let nsText = NSString(string: text)
        let size = CGSize(width: CGFloat(width), height: .greatestFiniteMagnitude)
        let textRect = nsText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return Int(ceil(textRect.size.height))
    }
    
    
}

