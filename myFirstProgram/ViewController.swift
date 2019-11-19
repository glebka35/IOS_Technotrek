//
//  ViewController.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 29/09/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var coreDataStack = CoreDataStack()
    var imagesToDownload = 0
    var countOfDownloadedImages = 0 {
        didSet {
            let articlesToSave = Array(self.listOfArticles[self.listOfArticles.count - self.countOfDownloadedImages...self.listOfArticles.count-1]) as [ArticleDetail]
            if self.countOfDownloadedImages == imagesToDownload{
                saveArticles(articles: articlesToSave)
                self.countOfDownloadedImages = 0
            }
        }
    }
    
    @IBOutlet weak var mainTable: UITableView!
    
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let blurredEffectViewPicker = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let categories = ["Startups", "Technology", "Business", "Politics", "Favorites"]
    private var currentCategory = "Startups"
    var countOfArticles = 0
    
    var listOfArticles = [ArticleDetail]() {
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
        self.coreDataStack = CoreDataStack()
        
        let savedArticles = getArticles(category: currentCategory)
        if savedArticles.count > 0 {
            self.listOfArticles = savedArticles
        }
        let articleRequest = ArticleRequest(category: currentCategory)
        articleRequest.getArticles {[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                        
            case .success(let articles):
                self?.listOfArticles += articles
                self!.imagesToDownload = articles.count
                self!.downloadImage()
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
        listOfArticles.removeAll()
        let savedArticles = getArticles(category: currentCategory)
        if savedArticles.count > 0 {
            self.listOfArticles = savedArticles
        }
        
        let articleRequest = ArticleRequest(category: currentCategory)
        articleRequest.getArticles {[weak self] result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let articles):
                    self?.listOfArticles = articles
                    self!.imagesToDownload = articles.count
                    self!.downloadImage()
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
        var uiImage = UIImage(named: "noPicture.png")
        if let image = self.listOfArticles[indexPath.row].image
        {
            uiImage = UIImage(data: image)
        }
    
        cell.myImage?.image = uiImage
        cell.myLabel?.text = self.listOfArticles[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let articleVC = sb.instantiateViewController(withIdentifier: "ArticleVC") as? ArticleViewController
        {
            
            articleVC.text = listOfArticles[indexPath.row].content ?? ""
            articleVC.image = UIImage(data:listOfArticles[indexPath.row].image!)
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
                        self!.imagesToDownload = articles.count
                        self!.downloadImage()
                }
                }
        }
    }
    
    func downloadImage() {
        let session = URLSession(configuration: .default)
        if(self.listOfArticles.count > 0){
            for i in self.listOfArticles.count - self.imagesToDownload...self.listOfArticles.count - 1 {
                let URLToImage = self.listOfArticles[i].urlToImage
                self.listOfArticles[i].image = UIImage(named: "noPicture.png")?.pngData()
                if(URLToImage != nil && URLToImage != "") {
                    let getImageFromUrl = session.dataTask(with: URL(string: URLToImage!)!) { (data, _, _) in
                        DispatchQueue.main.async {
                            self.countOfDownloadedImages += 1
                            print(i)
                        }
                        guard let imageData = data else { return }
                        guard let image = UIImage(data: imageData) else {return}
                        self.listOfArticles[i].image = image.pngData()
                    }
                    getImageFromUrl.resume()
                } else {
                    self.countOfDownloadedImages += 1
                }
                
            }
            //self.countOfArticles = self.listOfArticles.count
        }
    }
    
    func saveArticles(articles : [ArticleDetail]){
        
        
        if let articleEntity = NSEntityDescription.entity(forEntityName: "Articles", in: self.coreDataStack.masterContext!),
            let categoryEntity = NSEntityDescription.entity(forEntityName: "Categories", in: self.coreDataStack.masterContext!){
            var categoryUnwraped : Categories
            
            if let categoryForContext = getCategory(categoryName: self.currentCategory){
                 categoryUnwraped = categoryForContext
            }
            else {
                categoryUnwraped = Categories(entity: categoryEntity, insertInto: self.coreDataStack.masterContext)
                categoryUnwraped.name = self.currentCategory
            }
    
            for article in articles{
                
                let articleForContext = Articles(entity: articleEntity, insertInto: self.coreDataStack.masterContext!)

                
                articleForContext.author = article.author
                articleForContext.content = article.content
                articleForContext.title = article.title
                articleForContext.date = article.publishedAt
                articleForContext.image = article.image
                articleForContext.category = categoryUnwraped
                categoryUnwraped.addToArticle(articleForContext)
            }
        }

        self.coreDataStack.performSave(context:self.coreDataStack.masterContext!)
    }
    
    func getArticles(category: String) -> [ArticleDetail]{
        var gettingArticles = [ArticleDetail]()
        let newsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Articles")
        self.coreDataStack.saveContext?.performAndWait {
            do {
                let result = try self.coreDataStack.saveContext?.fetch(newsFetchRequest)
                result?.forEach({ (record) in
                    var article = ArticleDetail()
                    guard let news = record as? Articles else {
                        print("Error while get record")
                        return
                    }
                    if let categorySaved = news.category as Categories?{
                        if categorySaved.name == category{
                            article.content = news.content
                            article.author = news.author
                            article.image = news.image
                            article.title = news.title
                            article.publishedAt = news.date
                            gettingArticles.append(article)
                        }
                    }
                })
            }
            catch
            {
                print("CoreData error: \(error.localizedDescription)")
            }
        }
        return gettingArticles
    }
    
    func getCategory(categoryName : String)->Categories? {
        var returnCategory : Categories?
        let categoryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        self.coreDataStack.masterContext?.performAndWait {
            do {
                let result = try self.coreDataStack.masterContext?.fetch(categoryFetchRequest)
                result?.forEach({(record) in
                    guard let category = record as? Categories else {return}
                    if(category.name == categoryName){
                        returnCategory = category
                    }
                })
            }
            catch {
                print("CoreData error: \(error.localizedDescription)")
            }
        }
        return returnCategory
    }
}

