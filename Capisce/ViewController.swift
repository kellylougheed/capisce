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
        // let query = inputBox.text
        
        let url = URL(string: "https://glosbe.com/gapi/translate?from=it&dest=eng&format=json&phrase=ciao")

        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let json = json {
                print(json)
                
                // Clear text
                var meaningFound = false
                var grammarFound = false
                
                // Unwrap JSON
                if let meaningResult = (json as AnyObject)["tuc"] {
                    if let meaningResult2 = (meaningResult as AnyObject)[0] {
                        
                        // Find primary meaning
                        if let meaningResult3 = (meaningResult2 as AnyObject)["phrase"] {
                            if let meaningResult4 = (meaningResult3 as AnyObject)["text"] {
                                self.meaning.text = meaningResult4 as? String
                                meaningFound = true
                            }
                        }
                        
                        // Find grammatical information
                        if let grammarResult = (meaningResult2 as AnyObject)["meanings"] {
                            if let grammarResult2 = (grammarResult as AnyObject)["text"] {
                                var str = String(describing: grammarResult2)
                                // Strip HTML tags
                                str = str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                                self.meaning.text = str
                                grammarFound = true
                            }
                        }
                    }
                }
                
                
                // Check if results were found
                if meaningFound == false {
                    self.meaning.text = "No results found."
                    self.parsing.text = "Please make sure that you have entered an Italian word."
                }
//                else if grammarFound == false {
//                    self.parsing.text = "🏛"
//                }
                
            } else {
                self.meaning.text = "Unable to retrieve data."
            }
            
        }
        
        task.resume()
        
        meaning.isHidden = false
        parsing.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        meaning.isHidden = true
        parsing.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

