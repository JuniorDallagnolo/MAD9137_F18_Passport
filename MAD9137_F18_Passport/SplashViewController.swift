//
//  SplashViewController.swift
//  MAD9137_F18_Passport
//
//  Created by Ernilo Dallagnolo Junior on 2018-12-09.
//  Copyright © 2018 Ernilo Dallaagnolo Junior. All rights reserved.
//

import UIKit

//- create a segue from the SplashViewController to the NavigationController and give it an appropriate identifier (2 pt)
class SplashViewController: UIViewController {

    @IBOutlet weak var splashText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        splashText.isUserInteractionEnabled = false //disable user interaction for this textview
        splashText.text = "Welcome \n to \n Passport"
        
        // - when this viewController loads, it will wait 3 seconds and then call the performSegue(withIdentifier, sender) to segue to the tableView (3 pt)
        perform(#selector(showNewPage), with: nil, afterDelay: 3.0)
        
    }
    
    @objc func showNewPage () {
        performSegue(withIdentifier:"ShowPassportPage", sender: self)
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
