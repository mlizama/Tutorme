//
//  ViewController.swift
//  TutorMe
//
//  Created by Moises Lizama
//  Copyright © 2016 Moises Lizama. All rights reserved.
//

import UIKit
import SCLAlertView

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var password: TJTextField!
    @IBOutlet var username: TJTextField!
    
    override func viewDidLoad() {
        username.delegate = self;
        password.delegate = self;
        super.viewDidLoad()
        self.username.backgroundColor =  UIColor.clearColor()
        self.username.tintColor = UIColor.blackColor()
        self.username.textColor = UIColor.whiteColor()
        self.password.tintColor = UIColor.blackColor()
        self.password.textColor = UIColor.whiteColor()

        //let swiftColor = UIColor(red: 24, green: 116, blue: 205, alpha: 1)
        UIGraphicsBeginImageContext(self.view.frame.size)
        let image = UIImage(named: "blackboard3.jpg")
        let background = UIImageView(image: image)
        background.frame  = self.view.frame
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)

        self.view.backgroundColor = UIColor(patternImage: image!)

        //set the password text entry to show *'s instead of text
        password.secureTextEntry = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUp(sender: AnyObject) {
        
        self.performSegueWithIdentifier("signUp", sender:sender)

        

        
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
                    user_name = dataToReturn["name"].stringValue;
                    is_tutor = Int(dataToReturn["tutor"].stringValue)!
                    //the user that signed in is a tutor
                    if(tutor == 1)
                    {
                        
                        tutor_id = Int(dataToReturn["idUser"].stringValue)!;

                        //self.performSegueWithIdentifier("Tutor", sender:sender)
                        self.performSegueWithIdentifier("tutorTabController", sender:sender)

                    }
                        
                    //else the user that signed in is not a tutor
                    else
                    {
                        
                        user_id = Int(dataToReturn["idUser"].stringValue)!;

                        //self.performSegueWithIdentifier("Tutee", sender:sender)
                        self.performSegueWithIdentifier("barController", sender:sender)

                    }
                }
                else
                {
                    SCLAlertView().showError("Please Try Again", subTitle: "Wrong user name or password")

                    

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

