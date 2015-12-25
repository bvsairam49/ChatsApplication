//
//  ProfilesTableViewController.swift
//  DbDemoExampleSwift
//
//  Created by Development on 12/25/15.
//  Copyright © 2015 TheAppGuruz-New-6. All rights reserved.
//

import UIKit

class ProfilesTableViewController: UITableViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var chatsArray : NSMutableArray!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chatsArray = NSMutableArray()

    }
    
    override func viewWillAppear(animated: Bool) {
        self.refreshView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Other methods
    
    func refreshView(){
        
        chatsArray = ModelManager.getInstance().getAllStudentData()
        self.tableView.reloadData()
    }
    
    //MARK: UITableView delegate methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
       
        let imageButton:UIButton = cell?.contentView.viewWithTag(1000) as! UIButton
        let nameLable:UILabel = cell?.contentView.viewWithTag(1001) as! UILabel
        let descrLable:UILabel = cell?.contentView.viewWithTag(1002) as! UILabel
        let timeLable:UILabel = cell?.contentView.viewWithTag(1003) as! UILabel
        let counterLable:UILabel = cell?.contentView.viewWithTag(1004) as! UILabel

        let chat:Chat = chatsArray.objectAtIndex(indexPath.row) as! Chat
        
        let decodedData = NSData(base64EncodedString: chat.image, options: NSDataBase64DecodingOptions(rawValue: 0))
        let decodedimage = UIImage(data: decodedData!)
    
        imageButton.setBackgroundImage(decodedimage! as UIImage, forState: UIControlState.Normal)
        nameLable.text  = chat.name
        descrLable.text = chat.descr
        timeLable.text = chat.time
        counterLable.text = "\(chat.counnter)"
        
        return cell!
    }
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let chat:Chat = self.chatsArray.objectAtIndex((indexPath.row)) as! Chat
        ModelManager.getInstance().updateChatCounter(chat.chat_id, counterNuber: chat.counnter+1)
        self.refreshView()
    }
    //MARK: UIButton Action methods
    
    @IBAction func btnDeleteClicked(sender: AnyObject) {
        let btnDelete : UIButton = sender as! UIButton
        let selectedIndex : Int = btnDelete.tag
        let studentInfo: StudentInfo = chatsArray.objectAtIndex(selectedIndex) as! StudentInfo
        let isDeleted = ModelManager.getInstance().deleteStudentData(studentInfo)
        if isDeleted {
            Util.invokeAlertMethod("", strBody: "Record deleted successfully.", delegate: nil)
        } else {
            Util.invokeAlertMethod("", strBody: "Error in deleting record.", delegate: nil)
        }
        self.refreshView()
    }
    
    @IBAction func btnEditClicked(sender: AnyObject)
    {
        self.performSegueWithIdentifier("editSegue", sender: sender)
    }
    
    @IBAction func photoSelectButonClick(sender: AnyObject){
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        
        let chat:Chat = self.chatsArray.objectAtIndex((indexPath?.row)!) as! Chat
        
        ModelManager.getInstance().updateChatCounter(chat.chat_id, counterNuber: chat.counnter+1)
        
        let alertController: UIAlertController = UIAlertController(title: "Change Map Type", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Back", style: UIAlertActionStyle.Cancel, handler: nil)
        let button1action: UIAlertAction = UIAlertAction(title: "Camera"", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> () in
            // doing something for "product page"
        })
        let button2action: UIAlertAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> () in
            // doing something for "video"
        })
        alertController.addAction(cancelAction)
        alertController.addAction(button1action)
        alertController.addAction(button2action)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//        myImageView.contentMode = .ScaleAspectFit //3
//        myImageView.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    //MARK: Navigation methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editSegue")
        {
            let btnEdit : UIButton = sender as! UIButton
            let selectedIndex : Int = btnEdit.tag
            let viewController : InsertRecordViewController = segue.destinationViewController as! InsertRecordViewController
            viewController.isEdit = true
            viewController.studentData = chatsArray.objectAtIndex(selectedIndex) as! StudentInfo
        }
    }
    
}
