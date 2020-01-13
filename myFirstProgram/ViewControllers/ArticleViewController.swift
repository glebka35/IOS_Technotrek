//
//  ArticleViewController.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 15/10/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import UIKit

struct dataArticle {
    var text: String?
    var image: UIImage?
    var title: String?
    var author: String?
}

class ArticleViewController: UIViewController {
    
    var article = dataArticle()
    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var urlLabel: UITextView!
    
    var text = ""
    var articletTitle = ""
    var image:UIImage? = UIImage()
    var currentCategory = ""
    var urlToArticle = ""
    var sourceName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnButton.adjustsImageWhenHighlighted = false;
        textView.text = text
        imageVIew.image = image
        if sourceName != "" {
            sourceNameLabel.text = sourceName
        }
        
        if urlToArticle != "" {
            urlLabel.text = urlToArticle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageVIew.layer.cornerRadius = 20
        textView.isEditable = false
        
        saveButton.layer.cornerRadius = 7
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.layer.borderWidth = 1.5
        saveButton.clipsToBounds = true
        
        if(urlToArticle != ""){
            shareButton.isHidden = false
            shareButton.layer.cornerRadius = 7
            shareButton.layer.borderWidth = 1.5
            shareButton.layer.borderColor = UIColor.systemGray.cgColor
            shareButton.clipsToBounds = true
            self.view.bringSubviewToFront(shareButton)
        } else {
            shareButton.isHidden = true
        }
        self.view.bringSubviewToFront(saveButton)
        
    }
    
    @IBAction func returnButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressSaveButton(_ sender: Any) {
        activityIndicatorView.startAnimating()
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.addOperation {
            var i = 0;
            while UserDefaults.standard.string(forKey: self.currentCategory + "content" + String(i)) != nil {
                i+=1
            }
            UserDefaults.standard.set(self.text, forKey: self.currentCategory + "content" + String(i))
            UserDefaults.standard.set(self.articletTitle, forKey: self.currentCategory + "title" + String(i))
            UserDefaults.standard.set(self.image?.jpegData(compressionQuality: 0.8), forKey: self.currentCategory + "image" + String(i))
        }
        activityIndicatorView.stopAnimating()
    }
    
    @IBAction func pressShareButton(_ sender: Any){
        guard let url = URL(string: urlToArticle) else {return}
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
}
