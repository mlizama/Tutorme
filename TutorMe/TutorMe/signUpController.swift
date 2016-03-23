//
//  signUpController.swift
//  TutorMe
//
//  Created by Moises Lizama on 3/10/16.
//  Copyright © 2016 Moises Lizama. All rights reserved.
//

import UIKit

class signUpController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.grayColor();

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUp(sender: AnyObject) {
        
                let username = self.userName.text;
                let password = self.password.text;
        
                let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/signup.php")!
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
                                    
                                }
                            }
                        }    
                }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == userName
        {
            //username.becomeFirstResponder()
            userName.resignFirstResponder();
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
