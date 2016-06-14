//
//  addSessionViewController.swift
//  TutorMe
//
//  Created by Moises Lizama on 5/12/16.
//  Copyright © 2016 Moises Lizama. All rights reserved.
//
import UIKit
import SCLAlertView
import ActionSheetPicker_3_0

class addSessionViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource  {

    var chosen_day = ""
    
    @IBAction func choose(sender: AnyObject) {
        

        ActionSheetStringPicker.showPickerWithTitle("choose course", rows: courses, initialSelection: 0, doneBlock:{
            picker, selectedIndex, selectedValue in
            
            
            let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/sessions.php")!
            let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
            var body = "";
            body += "userid=";
            body += String(tutor_id);
            body += "&date="
            body += self.chosen_day
            let bodyData = body;
            
            print("------------------------------------")

            print("------------------------------------")

            
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
                            var dayid = 0
                            //do something if the json returned is not empty
                            if(!dataToReturn.isEmpty)
                            {
                                print(dataToReturn);
                                dayid = Int(dataToReturn["idDay"].stringValue)!
                                
                                //////////////////////
                                
                                let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/insertsession.php")!
                                let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
                                var body = "";
                                body += "dayid=";
                                body += String(dayid);
                                body += "&tutorid="
                                body += String(tutor_id)
                                body += "&hour="
                                body += self.getHour(selectedValue as! String)
                                body += "&date="
                                body += self.chosen_day

                                
                                let bodyData = body;
                                
                                request.HTTPMethod = "POST"
                                
                                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
                                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
                                    {
                                        (response, data, error) in
                                        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                                        
                                        print("should only get one")
                                        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                                        //print(data)
                                        if let HTTPResponse = response as? NSHTTPURLResponse {
                                            let statusCode = HTTPResponse.statusCode
                                            
                                            if statusCode == 200 {
                                                let dataToReturn = JSON(data: data!)
                                                print("http status code = 200");
                                                var dayid = 0
                                                //do something if the json returned is not empty
                                                if(!dataToReturn.isEmpty)
                                                {
                                                    print("------------------------------------")
                                                    let alert = UIAlertController(title: "Success!", message:"You have added this session to your calendar", preferredStyle: .Alert)
                                                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                                                        
                                                    }
                                                    alert.addAction(action)
                                                    self.presentViewController(alert, animated: true){}
                                                    print("successs")
                                                    print("------------------------------------")
                                                    
                                                    
                                                }
                                                else
                                                {
                                                    print("------------------------------------")
                                                    
                                                    print(dataToReturn)

                                                    print("------------------------------------")

                                                }
                                                if(self.data.isEmpty)
                                                {
                                                    
                                                }
                                            }
                                        }
                                }

                                
                                
                                //////////////////////
                                
                                
                                
                                
                            }
                            else
                            {
                                
                            }
                            if(self.data.isEmpty)
                            {
                                
                            }
                        }
                    }
            }
            
            
            print("index = \(selectedIndex)")
            print("value = \(selectedValue)")
            print("picker = \(picker)")
            return
            }
            , cancelBlock: nil, origin: self.view)
        
        
    }
    var data: [String] = [""]
    var dates: [String] = [""]
    var  dictionary: [String:Int]! = [:]
    var courses: [String] = ["1 a.m","2 a.m","3 a.m","4 a.m","5 a.m","6 a.m","7 a.m","8 a.m","9 a.m",
                            "10 a.m","11 a.m","12 p.m","1 p.m","2 p.m","3 p.m","4 p.m","5 p.m","7 p.m",
                            "8 p.m","10 p.m","11 p.m","12 a.m"]
    
    
    @IBOutlet var selectButton: UIButton!

    
    
    @IBOutlet var pick: UILabel!
    @IBOutlet var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectButton.hidden = true
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        UIGraphicsBeginImageContext(self.view.frame.size)
        let image = UIImage(named: "blackboard3.jpg")
        let background = UIImageView(image: image)
        background.frame  = self.view.frame
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
        
        self.view.backgroundColor = UIColor(patternImage: image!)

        self.calendar.backgroundColor = UIColor.clearColor()
        self.calendar.delegate = self
        self.calendar.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        

        
        let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/days.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        var body = "";
        body += "id=";
        body += String(tutor_id);
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
                            for i in 0..<dataToReturn.count
                            {
                                //fix here
                                self.dates.append((dataToReturn[i])["Date"].stringValue)
                                print(self.dates)
                            }
                            print(dataToReturn);
                            
                            self.calendar.reloadData()
                        }
                    }
                }
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        let dates1 = String(year) + "-" + String(month) + "-" + String(day);
        self.chosen_day = dates1
        
        self.selectButton.hidden = false

    }
    
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        //print(date.)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)
        chosen_day = dateString
        if(dates.contains(dateString) )
        {
            return true
        }
        else{
            return false
        }
    }

    
    func calendar(calendar: FSCalendar!, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //calendarHeightConstraint.constant = CGRectGetHeight(bounds);
        self.view.layoutIfNeeded();
    }
    
    func getHour(hour: String) -> String {
        
        if(hour == "1 a.m")
        {
            return "1";
        }
        else if(hour == "2 a.m"){ return "2";}
        else if(hour == "3 a.m"){ return "3";}
        else if(hour == "4 a.m"){ return "4";}
        else if(hour == "5 a.m"){ return "5";}
        else if(hour == "6 a.m"){ return "6";}
        else if(hour == "7 a.m"){ return "7";}
        else if(hour == "8 a.m"){ return "8";}
        else if(hour == "9 a.m"){ return "9";}
        else if(hour == "10 a.m"){ return "10";}
        else if(hour == "11 a.m"){ return "11";}
        else if(hour == "12 p.m"){ return "12";}
        else if(hour == "1 p.m"){ return "13";}
        else if(hour == "2 p.m"){ return "14";}
        else if(hour == "3 p.m"){ return "15";}
        else if(hour == "4 p.m"){ return "16";}
        else if(hour == "5 p.m"){ return "17";}
        else if(hour == "6 p.m"){ return "18";}
        else if(hour == "7 p.m"){ return "19";}
        else if(hour == "8 p.m"){ return "20";}
        else if(hour == "9 p.m"){ return "21";}
        else if(hour == "10 p.m"){ return "22";}
        else if(hour == "11 p.m"){ return "23";}
        else if(hour == "12 a.m"){ return "24";}
        else {return "error"}
        
        //return greeting
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
