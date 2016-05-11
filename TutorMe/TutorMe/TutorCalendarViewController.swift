//
//  TutorCalendarViewController.swift
//  TutorMe
//
//  Created by Moises Lizama on 5/11/16.
//  Copyright © 2016 Moises Lizama. All rights reserved.
//

import UIKit

class TutorCalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource
,UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var calendar: FSCalendar!
    
    
    var data: [String] = [""]
    var dates: [String] = [""]
    var  dictionary: [String:Int]! = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.data.removeAll()
        
        self.tabBarController!.delegate = self
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.14, green: 0.48, blue: 0.66, alpha: 1);
        self.table.layer.cornerRadius = 10
        self.table.delegate = self
        self.table.dataSource = self
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.backgroundColor = UIColor(colorLiteralRed: 0.14, green: 0.48, blue: 0.66, alpha: 1);
        


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/tutordateshavesessions.php")!
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
                               // print(self.dates)
                            }
                            print(dataToReturn);
                            
                            
                        }
                    }
                }
                self.calendar.reloadData()
                    print("===================")
                    print(self.dates)
                    print("===================")
        }


    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        
        
    }
    
    
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        
    
        
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
    
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        let dates = String(year) + "-" + String(month) + "-" + String(day);
        
        print(self.dates)
        
        let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/tutortakenssession.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        var body = "";
        body += "id=";
        body += String(tutor_id);
        body += "&date="
        body += dates
        
        let bodyData = body;
        print(body)
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
                            
                            self.data.removeAll()
                            
                            for i in 0..<dataToReturn.count
                            {
                                var compose = "You have a session with at "
                                compose += self.getHour((dataToReturn[i])["Hour"].stringValue)
                                self.data.append(compose)
                            }
                            print(dataToReturn);
                            self.table.reloadData()
                            self.calendar.reloadData()
                        }
                        else
                        {
                            self.data.removeAll()
                            self.table.reloadData()
                            
                            
                        }
                    }
                }
        }
        
        

        
    }
    
    
    
    func calendar(calendar: FSCalendar!, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //calendarHeightConstraint.constant = CGRectGetHeight(bounds);
        self.view.layoutIfNeeded();
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

    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
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
