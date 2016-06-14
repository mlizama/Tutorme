//
//  CalendarTutorViewController.swift
//  TutorMe
//
//  Created by Moises Lizama on 3/22/16.
//  Copyright © 2016 Moises Lizama. All rights reserved.
//

import UIKit

class CalendarTutorViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource , UITableViewDelegate, UITableViewDataSource{
    //private weak var calendar: FSCalendar!

    var data: [String] = [""]
    var dates: [String] = [""]
    var  dictionary: [String:Int]! = [:]
        
    @IBOutlet var goBack: UIButton!
    @IBOutlet var table: UITableView!
    
    @IBAction func `return`(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.data.removeAll()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        let image = UIImage(named: "blackboard3.jpg")
        let background = UIImageView(image: image)
        background.frame  = self.view.frame
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
        
        self.view.backgroundColor = UIColor(patternImage: image!)

        self.goBack.backgroundColor = UIColor.whiteColor()
        //self.dismissViewControllerAnimated(true, completion: nil)
       // self.table.backgroundColor = UIColor.clearColor()
        self.calendar.dataSource = self
        
        
        self.table.layer.cornerRadius = 10
        self.table.delegate = self
        self.table.dataSource = self
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        //self.calendar.backgroundColor = UIColor(colorLiteralRed: 0.14, green: 0.48, blue: 0.66, alpha: 1);
        self.calendar.backgroundColor = UIColor.clearColor()   
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)

        //self.view.backgroundColor = UIColor(colorLiteralRed: 0.14, green: 0.48, blue: 0.66, alpha: 1);
        self.calendar.delegate = self;

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
  
        if(Bool(is_tutor))
        {
            self.goBack.hidden = true
        }
        
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

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func calendar(calendar: FSCalendar!, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //calendarHeightConstraint.constant = CGRectGetHeight(bounds);
        self.view.layoutIfNeeded();
    }
    
    // FSCalendarDelegate called when user selects a date
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        self.dictionary.removeAll()
        self.data.removeAll()
        self.table.reloadData()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        print("--------------------")
        print(day);
        print(year);
        print(month);
        let dates = String(year) + "-" + String(month) + "-" + String(day);
        print(dates)
        print("--------------------")
        
        
        var url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/sessions.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        var body = "";
        body += "userid=";
        //body += String(user_id);
        
        body += String(tutor_id)
        
        body += "&";
        body += "date=";
        body += dates;

        let bodyData = body;
        var success = false;
        var Dayid = 0;

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
                            Dayid = Int(dataToReturn["idDay"].stringValue)!;
                            print(dataToReturn);
                            success = true;
                            //----------------
                            let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/block.php")!
                            let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)

                            var body = "";
                            body += "dayid=";
                            body += String(Dayid);
                            var bodyData = body;
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
                                                self.dictionary.removeAll()
                                                print(dataToReturn);
                                                for i in 0..<dataToReturn.count
                                                {
                                                    var sess = "";
                                                    sess += "Session Time: "
                                                    sess += self.getHour((dataToReturn[i])["Hour"].stringValue);
                                                    self.dictionary[sess] = Int((dataToReturn[i])["idSessionBlock"].stringValue)
                                                    self.data.append(sess)
                                                }
                                                self.table.reloadData()
                                                self.calendar.reloadData()

                                            }
                                            else
                                            {
                                                self.dictionary.removeAll()
                                                self.calendar.reloadData()


                                            }
                                        }
                                    }    
                            }

                            self.reloadDates()


                            
                        }
                        else
                        {
                            //else something went wrong
                        }
                    }
                }

        }
        

        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell = self.table.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.data[indexPath.row]

        
        return cell
    }
    
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //this code segment is ran when you select a cell
        print("\(indexPath.row)")
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell

        let alert = UIAlertController(title: currentCell.textLabel!.text!, message:"Sign up for this slot?", preferredStyle: .Alert)
        let action = UIAlertAction(title: "YES", style: .Default) { _ in
            //code executed when user taps ok
            
            let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/takeSession.php")!
            let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
            var body = "";
            body += "tutee=";
            body += String(user_id);
            body += "&sessId="
            body += String(self.dictionary[currentCell.textLabel!.text!]!)
            body += "&name="
            body += user_name
            let bodyData = body;
            
            print("++++++++++++++++++++")
            print(user_id)
            print(String(self.dictionary[currentCell.textLabel!.text!]!))
            print(body)
            print("++++++++++++++++++++")

            
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
                                
                                let alert3 = UIAlertController(title: currentCell.textLabel!.text!, message:"Successfully Signed Up!", preferredStyle: .Alert)
                                let action3 = UIAlertAction(title: "OK", style: .Default) { _ in
                                    //code executed when user taps ok
                                }
                                alert3.addAction(action3)
                                self.presentViewController(alert3, animated: true){}
                                var index = self.data.indexOf(currentCell.textLabel!.text!)
                                self.data.removeAtIndex(index!)
                                self.table.reloadData()

                            }
                            else
                            {
                                
                                let alert4 = UIAlertController(title: currentCell.textLabel!.text!, message:"Failed To Sign Up!", preferredStyle: .Alert)
                                let action4 = UIAlertAction(title: "OK", style: .Default) { _ in
                                    //code executed when user taps ok
                                }
                                alert4.addAction(action4)
                                self.presentViewController(alert4, animated: true){}
                                print("empty")
                            }
                        }
                    }
            }

         
        }
        let action2 = UIAlertAction(title: "NO", style: .Default) { _ in
            //code executed when user taps ok
            
        }
        alert.addAction(action)
        alert.addAction(action2)
        self.presentViewController(alert, animated: true){}
        
        self.calendar.reloadData()

        
    }
    
    func getHour(hour: String) -> String {
        
        if(hour == "1")
        {
            return " 1 am";
        }
        else if(hour == "2"){ return " 2 am";}
        else if(hour == "3"){ return " 3 am";}
        else if(hour == "4"){ return " 4 am";}
        else if(hour == "5"){ return " 5 am";}
        else if(hour == "6"){ return " 6 am";}
        else if(hour == "7"){ return " 7 am";}
        else if(hour == "8"){ return " 8 am";}
        else if(hour == "9"){ return " 9 am";}
        else if(hour == "10"){ return " 10 am";}
        else if(hour == "11"){ return " 11 am";}
        else if(hour == "12"){ return " 12 pm";}
        else if(hour == "13"){ return " 1 pm";}
        else if(hour == "14"){ return " 2 pm";}
        else if(hour == "15"){ return " 3 pm";}
        else if(hour == "16"){ return " 4 pm";}
        else if(hour == "17"){ return " 5 pm";}
        else if(hour == "18"){ return " 6 pm";}
        else if(hour == "19"){ return " 7 pm";}
        else if(hour == "20"){ return " 8 pm";}
        else if(hour == "21"){ return " 9 pm";}
        else if(hour == "22"){ return " 10 pm";}
        else if(hour == "23"){ return " 11 pm";}
        else if(hour == "24"){ return " 12 am";}
        else {return "error"}

        //return greeting
    }
    
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        //print(date.)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)

        if(dates.contains(dateString) )
        {
            return true
        }
        else{
        return false
        }
    }
    
    func reloadDates() -> Void{
        print("@@@@@@@@@@@@@@@@@@@@@@@@@")
        print(dates)
        self.dates.removeAll()
        print(dates)
        print("@@@@@@@@@@@@@@@@@@@@@@@@@")

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
}







