//
//  ViewController.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 29/09/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController{
    private let categories = ["Startups", "Technology", "Business", "Politics", "Favorites", "Cars"]
    let articleDownloader = GUArticleDownloaderImpl()
    let coreDataManager = GUCoreDataManagerImpl()
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let blurredEffectViewPicker = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let instanceThemeManager = ThemeManager.sharedInstance()
    
    var currentCategory = "Startups"
    var chosenCategory = "Startups"
    var imagesToDownload = 0
    var countOfArticles = 0 {
        didSet{
            isNewsAppeared += Array(repeating: false, count: countOfArticles - isNewsAppeared.count)
        }
    }
    var pageArticles = 1
    var isFetchInProgress = false
    var isGetArticleFromCoreData = true {
        didSet {
            pageArticles = 1
            takeDataFromCoreDataOrInternet()
        }
    }
    var isNewsAppeared : [Bool] = []
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
                DispatchQueue.global(qos: .default).async {[weak self] in
                    guard let self=self else {return}
                    self.saveArticles(articles: articlesToSave)
                }
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
        

//        NotificationCenter.default.addObserver(self, selector: #selector(setToDark(notification:)), name: .dark, object: nil)
        super.viewDidLoad()
        isGetArticleFromCoreData = true
        print(workWithCppClass(myString: currentCategory))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UiViewBar.backgroundColor = UIColor.clear
        blurredEffectView.frame = UiViewBar.bounds
        UiViewBar.addSubview(blurredEffectView)
        
        
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
//        myTableView.addSubview(instanceThemeManager!)
//        myTableView.bringSubviewToFront(instanceThemeManager!)
        UiViewBar.bringSubviewToFront(menuButton)
    }
    
    @IBAction func touchProfileButton(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = sb.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

//MARK: - Picker Categories
extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    @IBAction func touchMenuButton(_ sender: Any) {
        if(viemForPicker.isHidden){
            viewForGesture.isHidden = false
            viemForPicker.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, pickerView.bounds.height, 0)
            viemForPicker.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.viemForPicker.layer.transform = CATransform3DIdentity
            }
        }
        else{
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, pickerView.bounds.height, 0)
            UIView.animate(withDuration: 0.3, animations: {
                self.viemForPicker.layer.transform = transform
            }) {(finished) in
                self.viemForPicker.isHidden = true
                self.viemForPicker.layer.transform = CATransform3DIdentity
            }
            
           
            viewForGesture.isHidden = true
            changeCategory()
        }
    }
    
    @IBAction func closePickerView(_ sender: UITapGestureRecognizer) {
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, pickerView.bounds.height, 0)
        UIView.animate(withDuration: 0.3) {
            self.viemForPicker.layer.transform = transform
        }
        viemForPicker.isHidden = true
        viewForGesture.isHidden = true
        changeCategory()
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: categories[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return attributedString
    }
    
    func changeCategory(){
        if(chosenCategory != currentCategory){
                currentCategory = chosenCategory
                self.isNewsAppeared.removeAll()
                self.pageArticles = 1
                self.listOfArticles.removeAll()
                takeDataFromCoreDataOrInternet()
        }
    }
}
//MARK: - Main Table View
extension ViewController : UITableViewDelegate, UITableViewDataSource {
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
            articleVC.text = listOfArticles[indexPath.row].description ?? ""
            articleVC.image = UIImage(data:listOfArticles[indexPath.row].image!)
            articleVC.currentCategory = self.currentCategory
            articleVC.articletTitle = listOfArticles[indexPath.row].title ?? "No title"
            self.navigationController?.pushViewController(articleVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let rowsAmount = listOfArticles.count
        guard let indexPathForVisibleRows = mainTable.indexPathsForVisibleRows else {return}
        for indexPath in indexPathForVisibleRows{
            if(indexPath.row == rowsAmount-1){
                takeDataFromCoreDataOrInternet()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let indexPathForVisibleRows = mainTable.indexPathsForVisibleRows else {return}
        for indexPathVisible in indexPathForVisibleRows{
            if(!isNewsAppeared[indexPath.row] && indexPath == indexPathVisible){
                isNewsAppeared[indexPath.row] = true
                let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -mainTable.bounds.width, 0, 0)
                cell.layer.transform = rotationTransform
                UIView.animate(withDuration: 0.5) {
                    cell.layer.transform = CATransform3DIdentity
                }
            }
        }
    }
}

// MARK: - HTTP
extension ViewController{
    func downloadArticles() {
        articleDownloader.downloadArticles(category: currentCategory, page: pageArticles) {[weak self] result in
            guard let self = self else {return}
            switch result {
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self.isFetchInProgress = false
                }
                case .success(let articles):
                    DispatchQueue.main.async {
                        self.pageArticles += 1
                        self.isFetchInProgress = false
                        self.listOfArticles += articles
                        self.countOfArticles = self.listOfArticles.count
                        self.imagesToDownload = articles.count
                        self.downloadImage()
                    }
            }
        }
    }
}

extension ViewController:GUImageDownloader{
    func downloadImage() {
        let session = URLSession(configuration: .default)
        if(self.listOfArticles.count > 0){
            for i in self.listOfArticles.count - self.imagesToDownload...self.listOfArticles.count - 1 {
                let URLToImageString = self.listOfArticles[i].urlToImage
                self.listOfArticles[i].image = UIImage(named: "noPicture.png")?.pngData()
                if let unwrapedURLToImageString = URLToImageString,
                    let imageUrl = URL(string: unwrapedURLToImageString){
                        let getImageFromUrl = session.dataTask(with: imageUrl) { (data, _, _) in
                            DispatchQueue.main.async {
                                self.countOfDownloadedImages += 1
                            }
                            guard let imageData = data else { return }
                            if(self.listOfArticles.count > 0){
                                DispatchQueue.main.async {
                                    self.listOfArticles[i].image = imageData
                                }
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
        guard let masterContext = self.coreDataManager.masterContext else {return}
        if let articleEntity = NSEntityDescription.entity(forEntityName: "Articles", in: masterContext),
            let categoryEntity = NSEntityDescription.entity(forEntityName: "Categories", in: masterContext){
            var categoryUnwraped : Categories
            
            if let categoryForContext = getCategory(categoryName: self.currentCategory){
                 categoryUnwraped = categoryForContext
            }
            else {
                categoryUnwraped = Categories(entity: categoryEntity, insertInto: self.coreDataManager.masterContext)
                categoryUnwraped.name = self.currentCategory
            }
    
            for article in articles{
                let articleForContext = Articles(entity: articleEntity, insertInto: masterContext)
                articleForContext.author = article.author
                articleForContext.content = article.content
                articleForContext.title = article.title
                articleForContext.date = article.publishedAt
                articleForContext.image = article.image
                articleForContext.descr = article.description
                articleForContext.category = categoryUnwraped
                categoryUnwraped.addToArticle(articleForContext)
            }
        }
        self.coreDataManager.performSave(context:masterContext)
    }
    
    func createFetchRequest(category: String) -> NSFetchedResultsController<NSFetchRequestResult>?{
        let newsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Articles")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let predicate = NSPredicate(format: "category.name == %@", category)
        newsFetchRequest.sortDescriptors = [sortDescriptor]
        newsFetchRequest.predicate = predicate
        newsFetchRequest.propertiesToFetch = ["content", "author", "image", "title", "date"]
        newsFetchRequest.fetchLimit = 20
        newsFetchRequest.fetchOffset = 20 * (self.pageArticles - 1)
        guard let context = self.coreDataManager.masterContext else {return nil}
        let frc = NSFetchedResultsController(fetchRequest: newsFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func getArticles(category: String){
        
        guard let frc = createFetchRequest(category: category) else {return}
        var gotArticles : [ArticleDetail] = []
        do{
            _ = try frc.performFetch()
            let result = frc.fetchedObjects
            
            result?.forEach({ (record) in
                guard let news = record as? Articles else {return}
                var article = ArticleDetail()
                article.author = news.author
                article.content = news.content
                article.image = news.image
                article.title = news.title
                article.publishedAt = news.date
                article.description = news.descr
                gotArticles.append(article)
            })
        }
        catch{
            DispatchQueue.main.async {
                self.isFetchInProgress = false
            }
            print("CoreDataError: \(error.localizedDescription)")
        }
        if(!gotArticles.isEmpty){
            DispatchQueue.main.async {
                self.isFetchInProgress = false
                self.listOfArticles += gotArticles
                self.countOfArticles = self.listOfArticles.count
                self.pageArticles += 1
            }
        } else {
            DispatchQueue.main.async {
                self.isFetchInProgress = false
                self.isGetArticleFromCoreData = false
            }
        }
    }
    
    func getCategory(categoryName : String)->Categories? {
        var returnCategory : Categories?
        let categoryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        self.coreDataManager.masterContext?.performAndWait {
            do {
                let result = try self.coreDataManager.masterContext?.fetch(categoryFetchRequest)
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

//MARK: - ThemeManager (not use in this version)
extension ViewController{
    @objc func setToDark(notification: NSNotification) {
        
    }
    
    func setToLight(notification: NSNotification) {
    
    }
}

extension Notification.Name {
    static let dark = Notification.Name("dark")
    static let light = Notification.Name("light")
}

// MARK: - Work with cpp class
// This function is called in the end of viewDidLoad method
extension ViewController {
    func workWithCppClass(myString : String) -> String {
        let instanceCharDeleteManager = LastCharDeleteManager()
        return instanceCharDeleteManager.doWork(myString)
    }
}

extension ViewController{
    func takeDataFromCoreDataOrInternet(){
        if(!isFetchInProgress){
            isFetchInProgress = true
            if(!self.isGetArticleFromCoreData){
                downloadArticles()
            } else {
                DispatchQueue.global(qos: .default).async {[weak self] in
                    guard let self = self else {return}
                    self.getArticles(category: self.currentCategory)
                }
            }
        }
    }
}
