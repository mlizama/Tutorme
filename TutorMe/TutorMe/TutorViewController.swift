//
//  TutorViewController.swift
//  TutorMe
//
//  Created by Moises Lizama
//  Copyright © 2016 Moises Lizama. All rights reserved.
//

import UIKit

class TutorViewController: UIViewController {
    @IBOutlet weak var welcomMessage: UILabel!
    @IBAction func signOut(sender: AnyObject) {
        self.performSegueWithIdentifier("backTutor", sender:sender)

        }
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)

        //self.view.backgroundColor = UIColor(colorLiteralRed: 0.14, green: 0.48, blue: 0.66, alpha: 1);
        //24 116 205
        var welcome = user_name;
        welcome += " ";
        welcome += welcomMessage.text!;
        welcomMessage.text = welcome;
       
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
