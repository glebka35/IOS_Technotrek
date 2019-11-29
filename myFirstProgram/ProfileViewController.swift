//
//  ProfileViewController.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 22/10/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import UIKit

struct personInfo {
    var image: UIImage?
    var name: String?
    var favoriteCategories: [Bool]?
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var person = personInfo()
    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    @IBOutlet weak var buttonNSOperation: UIButton!
    @IBOutlet weak var buttonGCD: UIButton!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var backToProfile: UIButton!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var backMenuButton: UIButton!
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let categories = ["Startups", "Technology", "Business", "Politics"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewCategories: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoriesButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func touchCategoriesButton(_ sender: Any) {
        viewCategories.isHidden = false
    }
    
    @IBAction func touchBackButton(_ sender: Any) {
        viewCategories.isHidden = true
    }
    
    @IBAction func pressPhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            person.image = pickedImage
            profileImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profileImageData = UserDefaults.standard.object(forKey: "profileImage"){
            person.image = UIImage(data: profileImageData as! Data)
        }
        else{
            person.image = UIImage(named: "tim-cook.jpg")
        }
        
        if let profileName = UserDefaults.standard.string(forKey: "profileName"){
            person.name = profileName
        }
        
        if let profileCategories = UserDefaults.standard.object(forKey: "favoriteCategories"){
            person.favoriteCategories = profileCategories as? [Bool]
        }
        else{
            person.favoriteCategories = []
            for _ in 0...categories.count {
                person.favoriteCategories?.append(false)
            }
        }
        
        activityIndicatorView.color = UIColor.black
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        activityIndicatorView.frame = self.view.frame
        activityIndicatorView.center = self.view.center
        backMenuButton.adjustsImageWhenHighlighted = false
        
        profileImage.image = person.image
        nameTextField.text = person.name
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        categoriesButton.layer.cornerRadius = 7
        categoriesButton.layer.borderWidth = 1.5
        categoriesButton.layer.borderColor = UIColor.black.cgColor
        categoriesButton.clipsToBounds = true
        
        buttonGCD.layer.cornerRadius = 7
        buttonGCD.layer.borderWidth = 1.5
        buttonGCD.layer.borderColor = UIColor.black.cgColor
        buttonGCD.clipsToBounds = true
        
        buttonNSOperation.layer.cornerRadius = 7
        buttonNSOperation.layer.borderWidth = 1.5
        buttonNSOperation.layer.borderColor = UIColor.black.cgColor
        buttonNSOperation.clipsToBounds = true
        
        viewCategories.isHidden = true
        
        viewCategories.backgroundColor = UIColor.clear
        blurredEffectView.frame = viewCategories.bounds
        viewCategories.addSubview(blurredEffectView)
        
        viewCategories.bringSubviewToFront(tableView)
        
        viewCategories.bringSubviewToFront(categoriesLabel)
        
        viewCategories.bringSubviewToFront(backToProfile)
        backToProfile.backgroundColor = UIColor.clear
        categoriesLabel.backgroundColor = UIColor.clear
        
        tableView.backgroundColor = UIColor.clear
        viewCategories.layer.cornerRadius = 20
        viewCategories.clipsToBounds = true
        
        choosePhotoButton.layer.cornerRadius = 20
        choosePhotoButton.clipsToBounds = true
        
        profileImage.layer.cornerRadius = 20
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCellCategories
        if cell.checkMarkImage.isHidden{
            cell.checkMarkImage.isHidden = false
            cell.categoriesLabel.textColor = UIColor.black
            person.favoriteCategories![indexPath.row] = true
        } else {
            cell.checkMarkImage.isHidden = true
            cell.categoriesLabel.textColor = UIColor.darkGray
            person.favoriteCategories![indexPath.row] = false
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! TableViewCellCategories
        
        cell.categoriesLabel.text = categories[indexPath.row]
        if person.favoriteCategories![indexPath.row] {
            cell.checkMarkImage.isHidden = false
        } else {
            cell.checkMarkImage.isHidden = true
        }
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        person.name = nameTextField.text
        
    }

    @IBAction func touchGCDButton(_ sender: Any) {
        activityIndicatorView.startAnimating()
        let globalQueue = DispatchQueue.global(qos: .default)
        let profileImageData = person.image?.jpegData(compressionQuality: 0.8)
        globalQueue.async {
            UserDefaults.standard.set(profileImageData, forKey: "profileImage")
            UserDefaults.standard.set(self.person.name, forKey: "profileName")
            UserDefaults.standard.set(self.person.favoriteCategories, forKey: "favoriteCategories")
        }
        activityIndicatorView.stopAnimating()
    }
    
    @IBAction func touchNSOperationButton(_ sender: Any) {
        activityIndicatorView.startAnimating()
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        let profileImageData = person.image?.jpegData(compressionQuality: 0.8)
        operationQueue.addOperation {
            UserDefaults.standard.set(profileImageData, forKey: "profileImage")
            UserDefaults.standard.set(self.person.name, forKey: "profileName")
            UserDefaults.standard.set(self.person.favoriteCategories, forKey: "favoriteCategories")
        }
        activityIndicatorView.stopAnimating()
    }
    @IBAction func touchBackToMenuButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
