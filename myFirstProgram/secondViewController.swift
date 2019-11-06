//
//  secondViewController.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 15/10/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import UIKit

struct dataArticle{
    var text: String?
    var image: UIImage?
    var title: String?
}

class secondViewController: UIViewController {
    var article = dataArticle()
    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var text = ""
    var image:UIImage? = UIImage()
    var articleTitle = ""
    
    @IBOutlet weak var returnButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnButton.adjustsImageWhenHighlighted = false;
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageVIew.layer.cornerRadius = 20
        textView.isEditable = false
        
        textView.text = text
        imageVIew.image = image
        saveButton.layer.cornerRadius = 7
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.layer.borderWidth = 1.5
        saveButton.clipsToBounds = true
        self.view.bringSubviewToFront(saveButton)
        
    }
    
    @IBAction func returnButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func pressSaveButton(_ sender: Any) {
        activityIndicatorView.startAnimating()
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        operationQueue.addOperation {
            UserDefaults.standard.set(self.article, forKey: self.articleTitle)
        }
        activityIndicatorView.stopAnimating()
    }
    
}
