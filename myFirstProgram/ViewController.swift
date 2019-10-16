//
//  ViewController.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 29/09/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    var dataArray: [String] = ["lambo", "ferrari", "ferrari2"]
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let blurredEffectViewPicker = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let dataStrings = ["Startups", "Technology", "Business", "Politics"]
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var viemForPicker: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var UiViewBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UiViewBar.backgroundColor = UIColor.clear
        blurredEffectView.frame = UiViewBar.bounds
        UiViewBar.addSubview(blurredEffectView)
        
        myTableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        
        UiViewBar.bringSubviewToFront(menuButton)
        menuButton.backgroundColor = UIColor.clear
        menuImage.image = UIImage(named: "lines2.png")
        UiViewBar.bringSubviewToFront(menuImage)
        
        pickerView.backgroundColor = UIColor.clear
        viemForPicker.backgroundColor = UIColor.clear
        blurredEffectViewPicker.frame = viemForPicker.bounds
        viemForPicker.addSubview(blurredEffectViewPicker)
        viemForPicker.bringSubviewToFront(pickerView)
        //mainView.sendSubviewToBack(viemForPicker)
        viemForPicker.layer.cornerRadius = 20

        viemForPicker.clipsToBounds = true
        menuButton.setTitle("Startups", for: .normal)
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
        return dataStrings.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataStrings[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        menuButton.setTitle(dataStrings[row], for: .selected)
        menuButton.setTitle(dataStrings[row], for: .highlighted)
        menuButton.setTitle(dataStrings[row], for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! ViewControllerTableViewCell
        
        cell.myImage?.image = UIImage(named:  (dataArray[indexPath.row]+".jpg"))
        cell.myLabel?.text = dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let secondVC = sb.instantiateViewController(withIdentifier: "SecondVC") as? secondViewController {
            
            if !secondVC.isViewLoaded {
                secondVC.loadView()
            }
            secondVC.textView.text = text
            secondVC.imageVIew.image = UIImage(named:  (dataArray[indexPath.row]+".jpg"))
            self.navigationController?.pushViewController(secondVC, animated: true)
        
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    
    
}

