//
//  TuteeViewController.swift
//  TutorMe
//
//  Created by Moises Lizama
//  Copyright © 2016 Moises Lizama. All rights reserved.
//

import UIKit

class TuteeViewController: UIViewController {

    @IBOutlet weak var welcomeMessage: UILabel!
    @IBAction func signOut(sender: AnyObject) {
        self.performSegueWithIdentifier("backTutee", sender:sender)
    }
    override func viewDidLoad() {
        //self.view.backgroundColor = UIColor.blackColor();
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.14, green: 0.48, blue: 0.66, alpha: 1);

        var welcome = user_name;
        welcome += " ";
        welcome += welcomeMessage.text!;
        welcomeMessage.text = welcome;
        super.viewDidLoad()

 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
