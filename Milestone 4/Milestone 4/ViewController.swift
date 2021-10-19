//
//  ViewController.swift
//  Milestone 4
//
//  Created by Hümeyra Şahin on 18.10.2021.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var pictures = [Images]()
    var addedCaption = ""
    var uuids = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openCamera))
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "images") as? Data{
            let jsonDecoder = JSONDecoder()
            
            do{
                pictures = try jsonDecoder.decode([Images].self, from: savedPeople)
            }catch{
                print("failed to load people")
            }
        }
        
    }
    
    @objc func openCamera(){
        
        let ac = UIAlertController(title: "enter a caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "add", style: .default){ [weak self, weak ac] _ in
            
            self?.addedCaption = ac?.textFields?[0].text ?? ""
            
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
            
        })
        present(ac, animated: true)
        
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "picture", for: indexPath)
        let path = getDocumentsDirectory().appendingPathComponent(pictures[indexPath.row].image)
        cell.textLabel?.text = pictures[indexPath.row].caption
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        return cell
    }
    
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage  else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.7){
            try? jpegData.write(to: imagePath)
            
        }
        
        
        
        
       
        let picture = Images(caption: addedCaption, image: imageName)
        pictures.append(picture)
        uuids.append(imageName)
        
        save()
        tableView.reloadData()
        dismiss(animated: true)
    }
   
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "images")
        } else {
            print("failed to save")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = getDocumentsDirectory().appendingPathComponent(pictures[indexPath.row].image)
        let pic = pictures[indexPath.row]
        
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC{
            
            vc.selectedImage = pic
            vc.path = path
            vc.selectedImageName = pic.caption
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pictures.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            save()
        }
    }
    


}

