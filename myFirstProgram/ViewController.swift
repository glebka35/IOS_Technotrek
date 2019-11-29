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
    private let categories = ["Startups", "Technology", "Business", "Politics", "Favorites", "Cars"]
    let articleRequest = ArticleRequest()
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let blurredEffectViewPicker = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private var currentCategory = "Startups"
    var chosenCategory = ""
    var coreDataStack = CoreDataStack()
    var imagesToDownload = 0
    var countOfArticles = 0
    var pageArticles = 1
    var listOfArticles = [ArticleDetail]() {
        didSet {
            
            DispatchQueue.main.async {
                self.mainTable.reloadData()
            }
        }
    }
    var countOfDownloadedImages = 0 {
        didSet {
            if self.countOfDownloadedImages == imagesToDownload{
            let articlesToSave = Array(self.listOfArticles[self.listOfArticles.count - self.countOfDownloadedImages...self.listOfArticles.count-1]) as [ArticleDetail]
                saveArticles(articles: articlesToSave)
                self.countOfDownloadedImages = 0
            }
        }
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var viemForPicker: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var UiViewBar: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var viewForGesture: UIView!
    
    override func viewDidLoad() {
//        Delete UserDefaults
//        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//        UserDefaults.standard.synchronize()
        
        super.viewDidLoad()
        self.coreDataStack = CoreDataStack()
        
        let savedArticles = getArticles(category: currentCategory)
        if savedArticles.count > 0 {
            self.listOfArticles = savedArticles
        }
        downloadArticles()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        UiViewBar.backgroundColor = UIColor.clear
        blurredEffectView.frame = UiViewBar.bounds
        UiViewBar.addSubview(blurredEffectView)
        UiViewBar.bringSubviewToFront(menuButton)
        
        myTableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        
        UiViewBar.bringSubviewToFront(profileButton)
        profileButton.backgroundColor = UIColor.clear
        
        pickerView.backgroundColor = UIColor.clear
        
        blurredEffectViewPicker.frame = viemForPicker.bounds
        viemForPicker.backgroundColor = UIColor.clear
        viemForPicker.addSubview(blurredEffectViewPicker)
        viemForPicker.bringSubviewToFront(pickerView)
        viemForPicker.layer.cornerRadius = 20
        viemForPicker.clipsToBounds = true
        
        menuButton.setTitle(currentCategory, for: .normal)
        menuButton.backgroundColor = UIColor.clear
    }
    
    @IBAction func touchProfileButton(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = sb.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}



//MARK: - Picker Categories
extension ViewController {
    @IBAction func touchMenuButton(_ sender: Any) {
        if(viemForPicker.isHidden){
            viemForPicker.isHidden = false
            viewForGesture.isHidden = false
        }
        else{
            viemForPicker.isHidden = true
            viewForGesture.isHidden = true
            if(chosenCategory != currentCategory){
                currentCategory = chosenCategory
                self.countOfArticles = 0
                self.pageArticles = 1
                self.listOfArticles.removeAll()
                let savedArticles = getArticles(category: currentCategory)
                if savedArticles.count > 0 {
                    self.listOfArticles = savedArticles
                }
                downloadArticles()
            }
        }
    }
    
    @IBAction func closePickerView(_ sender: UITapGestureRecognizer) {
        viemForPicker.isHidden = true
        viewForGesture.isHidden = true
        if(chosenCategory != currentCategory){
            currentCategory = chosenCategory
            self.countOfArticles = 0
            self.pageArticles = 1
            self.listOfArticles.removeAll()
            let savedArticles = getArticles(category: currentCategory)
            if savedArticles.count > 0 {
                self.listOfArticles = savedArticles
            }
            downloadArticles()
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenCategory = categories[row]
        menuButton.setTitle(chosenCategory, for: .normal)
    }
}
//MARK: - Main Table View
extension ViewController {
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
            articleVC.articletTitle = listOfArticles[indexPath.row].title ?? "No title"
            self.navigationController?.pushViewController(articleVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == listOfArticles.count - 1){
            downloadArticles()
        }
    }
    
}

// MARK: - HTTP
extension ViewController {
    func downloadArticles() {
        articleRequest.getArticles(category: currentCategory, page: pageArticles) {[weak self] result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let articles):
                    self?.pageArticles += 1
                    self?.listOfArticles += articles
                    self?.imagesToDownload = articles.count
                    self?.downloadImage()
            }
        }
    }
    
    func downloadImage() {
        let session = URLSession(configuration: .default)
        if(self.listOfArticles.count > 0){
            for i in self.listOfArticles.count - self.imagesToDownload...self.listOfArticles.count - 1 {
                let URLToImageString = self.listOfArticles[i].urlToImage
                self.listOfArticles[i].image = UIImage(named: "noPicture.png")?.pngData()
                if let unwrapedURLToImageString = URLToImageString,
                    let imageUrl = URL(string: unwrapedURLToImageString){
                        let getImageFromUrl = session.dataTask(with: imageUrl) { (data, _, _) in
                            DispatchQueue.main.sync {
                                self.countOfDownloadedImages += 1
                            }
                            guard let imageData = data else { return }
                            if(self.listOfArticles.count > 0){
                                self.listOfArticles[i].image = imageData
                            }
                        }
                        getImageFromUrl.resume()
                    } else {
                        self.countOfDownloadedImages += 1
                    }
            }
        }
    }
}

// MARK: - Core Data
extension ViewController {
    func saveArticles(articles : [ArticleDetail]){
        guard let masterContext = self.coreDataStack.masterContext else {return}
        if let articleEntity = NSEntityDescription.entity(forEntityName: "Articles", in: masterContext),
            let categoryEntity = NSEntityDescription.entity(forEntityName: "Categories", in: masterContext){
            var categoryUnwraped : Categories
            
            if let categoryForContext = getCategory(categoryName: self.currentCategory){
                 categoryUnwraped = categoryForContext
            }
            else {
                categoryUnwraped = Categories(entity: categoryEntity, insertInto: self.coreDataStack.masterContext)
                categoryUnwraped.name = self.currentCategory
            }
    
            for article in articles{
                let articleForContext = Articles(entity: articleEntity, insertInto: masterContext)
                articleForContext.author = article.author
                articleForContext.content = article.content
                articleForContext.title = article.title
                articleForContext.date = article.publishedAt
                articleForContext.image = article.image
                articleForContext.category = categoryUnwraped
                categoryUnwraped.addToArticle(articleForContext)
            }
        }
        self.coreDataStack.performSave(context:masterContext)
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

