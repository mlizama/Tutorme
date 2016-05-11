//
//  SearchViewController.swift
//  TutorMe
//
//  Created by Moises Lizama on 5/8/16.
//  Copyright © 2016 Moises Lizama. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var searchCourse: UIButton!
    @IBOutlet var nameButton: UITextField!
    var  dictionary: [String:Int] = [:]
    var data: [String] = [""]
    var courses: [String] = ["CSCI 100","CSCI 101","CSCI 102","CSCI 111","CSCI 111X","CSCI 144",
                                "CSCI 198","CSCI 211","CSCI 211X","CSCI 217","CSCI 221","CSCI 221X",
                                "CSCI 301","CSCI 311","CSCI 311X","CSCI 313H","CSCI 315","CSCI 340",
                                "CSCI 344","CSCI 346","CSCI 380","CSCI 381","CSCI 381","CSCI 389",
                                "CSCI 398","CSCI 400","CSCI 430","CSCI 431","CSCI 444","CSCI 490",
                                "CSCI 498","CSCI 499","CSCI 499H","CSCI 511","CSCI 515","CSCI 533",
                                "CSCI 540","CSCI 546","CSCI 547","CSCI 550","CSCI 551","CSCI 566",
                                "CSCI 567","CSCI 568","CSCI 569","CSCI 580","CSCI 583","CSCI 585",
                                "CSCI 598","CSCI 611",];

    @IBAction func changed(sender: AnyObject) {
        if(self.data.isEmpty == false){
            let index = self.table.indexPathsForVisibleRows
            self.table.cellForRowAtIndexPath(index![0])?.textLabel?.textColor = UIColor.blackColor()
        }
        var name = nameButton.text
        if(name != ""){
        let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/name.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        var body = "";
        body += "name=";
        body += name!;
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
                            self.data.removeAll()
                            print(dataToReturn);
                            for i in 0..<dataToReturn.count
                            {
                                self.dictionary[(dataToReturn[i])["name"].stringValue] = Int((dataToReturn[i])["idUser"].stringValue)
                                  //  Int(dataToReturn["idUser"].stringValue)!
                              
                                print("++++++++++++++++++++++")
                                print((dataToReturn[i])["Name"].stringValue)
                                print(Int((dataToReturn[i])["Uid"].stringValue))
                                print(self.dictionary)
                                print("++++++++++++++++++++++")

                                
                                self.data.append((dataToReturn[i])["name"].stringValue)
                            }
                            self.table.reloadData()
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
        else{
            self.data.removeAll()
            self.table.reloadData()
        }
       
    }
    
    
    @IBAction func t(sender: AnyObject) {
        self.nameButton.endEditing(true)
        if(self.data.isEmpty == false){
            let index = self.table.indexPathsForVisibleRows
            self.table.cellForRowAtIndexPath(index![0])?.textLabel?.textColor = UIColor.blackColor()
        }
        ActionSheetStringPicker.showPickerWithTitle("choose course", rows: courses, initialSelection: 0, doneBlock:{
            picker, selectedIndex, selectedValue in
            
            
            let url: NSURL = NSURL(string: "http://default-environment.s4mivgjgvz.us-east-1.elasticbeanstalk.com/course.php")!
            let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
            var body = "";
            body += "course=";
            body += String(selectedValue);
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
                                self.data.removeAll()
                                self.nameButton.text = ""
                                print(dataToReturn);
                                for i in 0..<dataToReturn.count
                                {
                                    self.dictionary[(dataToReturn[i])["Name"].stringValue] = Int((dataToReturn[i])["Uid"].stringValue)
                                    print("++++++++++++++++++++++")
                                    print((dataToReturn[i])["Name"].stringValue)
                                    print(Int((dataToReturn[i])["Uid"].stringValue))
                                    
                                    print(self.dictionary)
                                    print("++++++++++++++++++++++")
                                    
                                    self.data.append((dataToReturn[i])["Name"].stringValue)
                                }
                                self.table.reloadData()
                            }
                            else
                            {
                                self.data.removeAll()
                                self.table.reloadData()


                            }
                            if(self.data.isEmpty)
                            {
                                self.data.append("No tutors found")
                                self.table.reloadData()
                                
                                let index = self.table.indexPathsForVisibleRows
                                self.table.cellForRowAtIndexPath(index![0])?.textLabel?.textColor = UIColor.redColor()
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


    
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.data.removeAll()
        self.nameButton.delegate = self
        self.searchCourse.backgroundColor = UIColor.whiteColor()
        self.searchCourse.layer.cornerRadius = 10
        self.table.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.14, green: 0.48, blue: 0.66, alpha: 1);
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")


        // Do any additional setup after loading the view.
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
        //this code segment is ran when you select a cell
        //print("\(indexPath.row.value)")
        
        let indexPath = tableView.indexPathForSelectedRow
        print(self.dictionary)
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
        print(currentCell.textLabel!.text!)

        if(!currentCell.textLabel!.text!.isEmpty){
        tutor_id = self.dictionary[currentCell.textLabel!.text!]!
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("calendar") as! CalendarTutorViewController
        //let navController = UINavigationController(rootViewController: vc) // Creating a navigation controller with VC1 at the root of the navigation stack.
        
        self.presentViewController(vc, animated:true, completion: nil)        //self.presentViewController(vc, animated: true, completion: nil)
        }
        //data.append("1")
        //table.reloadData()
        
    }
        // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    //textfield delegate functions
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameButton
        {
            //username.becomeFirstResponder()
            nameButton.resignFirstResponder();
        }

        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)

    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    }
