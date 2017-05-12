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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        var query: String = ""
        
        if inputBox.text != nil {
            query = inputBox.text!
        }
        
        let searchURL = "https://glosbe.com/gapi/translate?from=it&dest=eng&format=json&phrase=\(query)"
        
        let url = URL(string: searchURL)
        
        self.meaning.isHidden = true
        self.parsing.isHidden = true
        self.spinner.isHidden = false
        
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
                
                var wordFound = false
                
                // Unwrap JSON
                if let meaningResult = (json as AnyObject)["tuc"] {
                    
                    // TODO: Try catch with OOB error
                    if let meaningResult2 = (meaningResult as AnyObject)[0] {
                        
                        // Find primary meaning
                        if let meaningResult3 = (meaningResult2 as AnyObject)["phrase"] {
                            if let meaningResult4 = (meaningResult3 as AnyObject)["text"] {
                                self.spinner.isHidden = true
                                self.meaning.isHidden = false
                                self.meaning.text = meaningResult4 as? String
                                wordFound = true
                            }
                        }
                        
                        // Find grammatical information
                        if let grammarResult = (meaningResult2 as AnyObject)["meanings"] {
                            if let grammarResult2 = (grammarResult as AnyObject)["text"] {
                                var str = String(describing: grammarResult2)
                                // Strip HTML tags
                                str = str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                                self.parsing.text = str
                                self.parsing.isHidden = false
                            }
                        }
                    }
                }
                
                if wordFound == false {
                    self.spinner.isHidden = true
                    self.meaning.text = "No results found."
                    self.meaning.isHidden = false
                    self.parsing.text = "Please search a different Italian word."
                    self.parsing.isHidden = false
                }
            
            } else {
                self.spinner.isHidden = true
                self.meaning.text = "Unable to retrieve data."
            }
            
        }
        
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        spinner.isHidden = true
        meaning.isHidden = true
        parsing.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

