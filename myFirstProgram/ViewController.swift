//
//  ViewController.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 29/09/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var mainTable: UITableView!
    
    var dataArray: [String] = ["lambo", "ferrari", "ferrari2"]
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let blurredEffectViewPicker = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let categories = ["Startups", "Technology", "Business", "Politics", "Favorites"]
    private var currentCategory = "Startups"
    var countOfArticles = 0
    
    var listOfArticles = [ArticleDetail]() {
        didSet {
            let session = URLSession(configuration: .default)
            self.listOfImages += Array(repeating: UIImage(named: "noPicture.png"), count: self.listOfArticles.count)
            if(self.listOfArticles.count > 0){
                for i in self.countOfArticles...self.listOfArticles.count - 1 {
                    let URLToImage = self.listOfArticles[i].urlToImage
                    if(URLToImage != nil && URLToImage != "") {
                        let getImageFromUrl = session.dataTask(with: URL(string: URLToImage!)!) { (data, _, _) in
                            guard let imageData = data else { return }
                            guard let image = UIImage(data: imageData) else {return}
                            self.listOfImages[i] = image
                        }
                        getImageFromUrl.resume()
                    }
                }
                self.countOfArticles = self.listOfArticles.count
            }
        }
    }
    
    var listOfImages = [UIImage?](){
        didSet {
            DispatchQueue.main.async {
                self.mainTable.reloadData()
            }
        }
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var viemForPicker: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var UiViewBar: UIView!
    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        // Delete UserDefaults
//        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//        UserDefaults.standard.synchronize()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let articleRequest = ArticleRequest(category: currentCategory)
        articleRequest.getArticles {[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                var articlesMemory = [ArticleDetail]()
                
                var i = 0;
                while UserDefaults.standard.object(forKey: self!.currentCategory + "content" + String(i)) != nil {
                    let content = UserDefaults.standard.string(forKey: self!.currentCategory + "content" + String(i))!
                    let title = UserDefaults.standard.string(forKey: self!.currentCategory + "title" + String(i))
                    let image = UIImage(data: UserDefaults.standard.object(forKey: self!.currentCategory + "image" + String(i)) as! Data)
                    let article = ArticleDetail(author: nil, title: title, url: nil, urlToImage: nil, publishedAt: nil, content: content, source: nil)
                    articlesMemory.append(article)
                    self?.listOfImages.append(image)
                    i += 1
                }
                self?.listOfArticles = articlesMemory
                
                
            case .success(let articles):
                self?.listOfArticles = articles
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UiViewBar.backgroundColor = UIColor.clear
        blurredEffectView.frame = UiViewBar.bounds
        UiViewBar.addSubview(blurredEffectView)
        
        myTableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        
        UiViewBar.bringSubviewToFront(menuButton)
        menuButton.backgroundColor = UIColor.clear
        menuImage.image = UIImage(named: "lines2.png")
        
        UiViewBar.bringSubviewToFront(profileButton)
        profileButton.backgroundColor = UIColor.clear
        UiViewBar.bringSubviewToFront(menuImage)
        
        pickerView.backgroundColor = UIColor.clear
        viemForPicker.backgroundColor = UIColor.clear
        blurredEffectViewPicker.frame = viemForPicker.bounds
        viemForPicker.addSubview(blurredEffectViewPicker)
        viemForPicker.bringSubviewToFront(pickerView)
        //mainView.sendSubviewToBack(viemForPicker)
        viemForPicker.layer.cornerRadius = 20

        viemForPicker.clipsToBounds = true
        menuButton.setTitle(currentCategory, for: .normal)
    }
    

    @IBAction func touchMenuButton(_ sender: Any) {
        
        if(viemForPicker.isHidden){
            viemForPicker.isHidden = false
        }
        else{
            viemForPicker.isHidden = true
        }
    }
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countOfArticles = 0
        currentCategory = categories[row]
        menuButton.setTitle(currentCategory, for: .normal)
        
        self.listOfImages = Array(repeating: UIImage(named: "noPicture.png"), count: self.listOfImages.count)
        
        let articleRequest = ArticleRequest(category: currentCategory)
        articleRequest.getArticles {[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                var articlesMemory = [ArticleDetail]()
                
                var i = 0;
                while UserDefaults.standard.object(forKey: self!.currentCategory + "content" + String(i)) != nil {
                    let content = UserDefaults.standard.string(forKey: self!.currentCategory + "content" + String(i))!
                    let title = UserDefaults.standard.string(forKey: self!.currentCategory + "title" + String(i))
                    let image = UIImage(data: UserDefaults.standard.object(forKey: self!.currentCategory + "image" + String(i)) as! Data)
                    let article = ArticleDetail(author: nil, title: title!, url: nil, urlToImage: nil, publishedAt: nil, content: content, source: nil)
                    articlesMemory.append(article)
                    self?.listOfImages.append(image)
                    i += 1
                }
                self?.listOfArticles = articlesMemory
            case .success(let articles):
                self?.listOfArticles = articles
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return listOfArticles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! MainTableViewCell
        cell.myImage?.image = self.listOfImages[indexPath.row]
        cell.myLabel?.text = self.listOfArticles[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let articleVC = sb.instantiateViewController(withIdentifier: "ArticleVC") as? ArticleViewController
        {
            
            articleVC.text = listOfArticles[indexPath.row].content ?? ""
            articleVC.image = listOfImages[indexPath.row]
            articleVC.currentCategory = self.currentCategory
            articleVC.articletTitle = listOfArticles[indexPath.row].title!
            self.navigationController?.pushViewController(articleVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    @IBAction func touchProfileButton(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = sb.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController {
            self.navigationController?.pushViewController(profileVC, animated: true)
        
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == listOfArticles.count - 1){
            let articleRequest = ArticleRequest(category: currentCategory)
            articleRequest.getArticles {[weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let articles):
                    self?.listOfArticles += articles
                }
            }
        }
    }
}

