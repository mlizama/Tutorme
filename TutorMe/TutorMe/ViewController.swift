//
//  ViewController.swift
//  TutorMe
//
//  Created by Moises Lizama
//  Copyright © 2016 Moises Lizama. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        username.delegate = self;
        password.delegate = self;
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor();
        //self.view.backgroundColor = UIColor.grayColor();

        //set the password text entry to show *'s instead of text
        password.secureTextEntry = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUp(sender: AnyObject) {
        
        self.performSegueWithIdentifier("signUp", sender:sender)

        
//        let username = self.username.text;
//        let password = self.password.text;
//        
//        let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/signup.php")!
//        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
//        var body = "";
//        body += "name=";
//        body += username!;
//        body += "&";
//        body += "pass=";
//        body += password!;
//        let bodyData = body;
//        
//        request.HTTPMethod = "POST"
//        
//        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
//            {
//                (response, data, error) in
//                
//                //print(data)
//                if let HTTPResponse = response as? NSHTTPURLResponse {
//                    let statusCode = HTTPResponse.statusCode
//                    
//                    if statusCode == 200 {
//                        let dataToReturn = JSON(data: data!)
//                        print("http status code = 200");
//                        //do something if the json returned is not empty
//                        if(!dataToReturn.isEmpty)
//                        {
//                            print(dataToReturn);
//                            
//                        }
//                    }
//                }    
//        }
        

        
    }
    @IBAction func signIn(sender: AnyObject) {
        
        let username = self.username.text;
        let password = self.password.text;
        
        let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/index.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        var body = "";
        body += "name=";
        body += username!;
        body += "&";
        body += "pass=";
        body += password!;
        let bodyData = body;

        request.HTTPMethod = "POST"
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                
                //print(data)
            if let HTTPResponse = response as? NSHTTPURLResponse {
            let statusCode = HTTPResponse.statusCode
            
            if statusCode == 200 {
                let dataToReturn = JSON(data: data!)
                print("http status code = 200");
                //do something if the json returned is not empty
                if(!dataToReturn.isEmpty)
                {
                    print(dataToReturn);
                    let tutor = dataToReturn["tutor"].int64Value;
                    print(tutor);
                    //the user that signed in is a tutor
                    if(tutor == 1)
                    {
                        user_name = dataToReturn["name"].stringValue;
                        //self.performSegueWithIdentifier("Tutor", sender:sender)
                        self.performSegueWithIdentifier("tutorTabController", sender:sender)

                    }
                    //else the user that signed in is not a tutor
                    else
                    {
                        user_name = dataToReturn["name"].stringValue;
                        //self.performSegueWithIdentifier("Tutee", sender:sender)
                        self.performSegueWithIdentifier("barController", sender:sender)

                    }
                }
                else
                {
                    let alert = UIAlertController(title: "Sorry!", message:"Wrong username/password try again", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                        //code executed when user taps ok
                        self.password.text = "";
                        self.username.text = "";
                    }
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true){}

                }
            }
        }    
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == username
        {
            //username.becomeFirstResponder()
            username.resignFirstResponder();
        }
        else if textField == password
        {
            password.resignFirstResponder();
        }
        return true
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }


}

