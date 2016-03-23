//
//  CalendarTutorViewController.swift
//  TutorMe
//
//  Created by Moises Lizama on 3/22/16.
//  Copyright © 2016 Moises Lizama. All rights reserved.
//

import UIKit

class CalendarTutorViewController: UIViewController, FSCalendarDelegate{
    //private weak var calendar: FSCalendar!

    @IBOutlet weak var calendar: FSCalendar!
    override func viewDidLoad() {
      

        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func calendar(calendar: FSCalendar!, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //calendarHeightConstraint.constant = CGRectGetHeight(bounds);
        self.view.layoutIfNeeded();
    }
 
}

// For autoLayout
