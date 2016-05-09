//
//  CalendarTutorViewController.swift
//  TutorMe
//
//  Created by Moises Lizama on 3/22/16.
//  Copyright © 2016 Moises Lizama. All rights reserved.
//

import UIKit

class CalendarTutorViewController: UIViewController, FSCalendarDelegate , UITableViewDelegate, UITableViewDataSource{
    //private weak var calendar: FSCalendar!

    var data: [String] = [""]

    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    override func viewDidLoad() {
        
        self.table.layer.cornerRadius = 10
        self.table.delegate = self
        self.table.dataSource = self
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        self.calendar.backgroundColor = UIColor(colorLiteralRed: 0.14, green: 0.48, blue: 0.66, alpha: 1);
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.14, green: 0.48, blue: 0.66, alpha: 1);
        self.calendar.delegate = self;
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        body += String(user_id);
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
                                                print(dataToReturn);
                                                for i in 0..<dataToReturn.count
                                                {
                                                    var sess = "";
                                                    sess += "Session Time: "
                                                    sess += self.getHour((dataToReturn[i])["Hour"].stringValue);
                                                    self.data.append(sess)
                                                    //(returnedJSON[size])["title"]
                                                }
                                                
                                                self.table.reloadData()
                                            }
                                            else
                                            {
                                                
                                            }
                                        }
                                    }    
                            }

                            

                            
                            //-----------------
                            
                        }
                        else
                        {
                            //else something went wrong
                        }
                    }
                }
                
                /////////

                
                /////
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
        //data.append("1")
        //table.reloadData()
        
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
        else if(hour == "13"){ return " 1 am";}
        else if(hour == "14"){ return " 2 am";}
        else if(hour == "15"){ return " 3 am";}
        else if(hour == "16"){ return " 4 am";}
        else if(hour == "17"){ return " 5 am";}
        else if(hour == "18"){ return " 6 am";}
        else if(hour == "19"){ return " 7 am";}
        else if(hour == "20"){ return " 8 am";}
        else if(hour == "21"){ return " 9 am";}
        else if(hour == "22"){ return " 10 am";}
        else if(hour == "23"){ return " 11 am";}
        else if(hour == "24"){ return " 12 am";}
        else {return "error"}

        //return greeting
    }
}







