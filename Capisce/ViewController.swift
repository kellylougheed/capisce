//
//  ViewController.swift
//  Capisce
//
//  Created by Kelly Lougheed on 5/11/17.
//  Copyright © 2017 Kelly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputBox: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var meaning: UILabel!
    @IBOutlet weak var parsing: UITextView!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let query = inputBox.text
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

