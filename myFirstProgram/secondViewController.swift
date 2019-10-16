//
//  secondViewController.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 15/10/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    
    
    override func viewDidLoad() {        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageVIew.layer.cornerRadius = 20
        textView.isEditable = false
        
        
    }
    
    @IBAction func returnButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
