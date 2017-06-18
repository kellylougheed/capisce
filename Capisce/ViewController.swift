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
        
        if self.inputBox.text != nil {
            query = self.inputBox.text!
        }
        
        DispatchQueue.main.async(execute: {
            self.meaning.isHidden = true
            self.parsing.isHidden = true
            self.spinner.isHidden = false
        })
        
        let requestURL: NSURL = NSURL(string: "https://glosbe.com/gapi/translate?from=it&dest=eng&format=json&phrase=\(query)")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    
                    var wordFound = false
                    
                    print(json)
                    
                    // Unwrap JSON
                    if let meaningResult = (json as AnyObject)["tuc"] {
                        
                        print(meaningResult!)
                    
                        // TODO: Try catch with OOB error
                        if (meaningResult as AnyObject)[0] != nil {
                            
                            let meaningResult2 = (meaningResult as AnyObject)[0]
                            
                            print("meaning result 2")
                            print(meaningResult2)
                    
                        // Find primary meaning
                            if (meaningResult2 as AnyObject)["phrase"] != nil {
                                
                                let meaningResult3 = (meaningResult2 as AnyObject)["phrase"]
                                
                                print("meaning result 3")
                                print(meaningResult3)
                                
                                if (meaningResult3 as AnyObject)["text"] != nil {
                                    
                                    let meaningResult4 = (meaningResult3 as AnyObject)["text"]
                                    
                                    print("meaning result 4")
                                    print(meaningResult4)
                                    
                                    DispatchQueue.main.async(execute: {
                                        self.spinner.isHidden = true
                                        self.meaning.isHidden = false
                                        self.meaning.text = meaningResult4 as? String
                                    })
                                
                                    wordFound = true
                                }
                            }
                    
                            // Find grammatical information
                            if (meaningResult2 as AnyObject)["meanings"] != nil {
                                
                                let grammarResult = (meaningResult2 as AnyObject)["meanings"] as! [[String: AnyObject]]
                                
                                print("grammar result")
                                print(grammarResult)
                                
                                if grammarResult[0]["text"] != nil {
                                    
                                    let grammarResult2 = grammarResult[0]["text"]!
                                    
                                    print("grammar result 2")
                                    print(grammarResult2)
                                    
                                    var str = String(describing: grammarResult2)
                                    // Strip HTML tags
                                    str = str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                                    DispatchQueue.main.async(execute: {
                                        self.spinner.isHidden = true
                                        self.parsing.text = str
                                        self.parsing.isHidden = false
                                    })
                                    
                                    wordFound = true
                                }
                            }
                        }
                    }
                                    
                    if wordFound == false {
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.meaning.text = "No results found."
                            self.meaning.isHidden = false
                            self.parsing.text = "Please search a different Italian word."
                            self.parsing.isHidden = false
                        })
                    }
                    
                } catch {
                    print("Error with JSON: \(error)")
                }
                
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

