//
//  ProfilesTableViewController.swift
//  DbDemoExampleSwift
//
//  Created by Development on 12/25/15.
//  Copyright © 2015 TheAppGuruz-New-6. All rights reserved.
//

import UIKit
import MobileCoreServices

class ProfilesTableViewController: UITableViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var chatsArray : NSMutableArray!
    var imagePicker = UIImagePickerController()
    var indexPath:NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chatsArray = NSMutableArray()
        imagePicker.delegate = self


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
        
        var decodedimage:UIImage = UIImage(named: "list1Photo")!
        if let decodedData = NSData(base64EncodedString: chat.image, options: NSDataBase64DecodingOptions(rawValue: 0)){
            decodedimage = UIImage(data: decodedData)!
        }
        imageButton.setBackgroundImage(decodedimage as UIImage, forState: UIControlState.Normal)
        nameLable.text  = chat.name
        descrLable.text = chat.descr
        timeLable.text = chat.time
        counterLable.text = "\(chat.counnter)"
        
        return cell!
    }
    func showCamera() {
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let alert = UIAlertView(title: "alert", message: "No Device Connected/Available", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "Cancel")
            alert.show()
        }else if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: false, completion: nil)
        }
    }
    //Gallery Button Action
    func showGallery() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: false, completion: nil)
        }
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let chat:Chat = self.chatsArray.objectAtIndex((indexPath.row)) as! Chat
        ModelManager.getInstance().updateChatCounter(chat.chat_id, counterNuber: chat.counnter+1)
        self.refreshView()
    }
  
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        let editAction = UITableViewRowAction(style: .Default, title: "Edit",handler: { (action: UITableViewRowAction!,indexPath: NSIndexPath!) in
            
            // maybe show an action sheet with more options
            self.tableView.setEditing(false, animated: false)
            
            
            }
        );
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete",
            handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
                
                
                //self.deleteModelAt(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic);
            }
        );
        return [deleteAction, editAction]

    }
    //MARK: UIButton Action methods
    @IBAction func btnDeleteClicked(sender: AnyObject) {
        /*let btnDelete : UIButton = sender as! UIButton
        let selectedIndex : Int = btnDelete.tag
        let studentInfo: StudentInfo = chatsArray.objectAtIndex(selectedIndex) as! StudentInfo
        let isDeleted = ModelManager.getInstance().deleteStudentData(studentInfo)
        if isDeleted {
            Util.invokeAlertMethod("", strBody: "Record deleted successfully.", delegate: nil)
        } else {
            Util.invokeAlertMethod("", strBody: "Error in deleting record.", delegate: nil)
        }
        self.refreshView()*/
    }
    
    @IBAction func btnEditClicked(sender: AnyObject)
    {
        self.performSegueWithIdentifier("editSegue", sender: sender)
    }
    
    @IBAction func photoSelectButonClick(sender: AnyObject){
        
        
        let point = self.tableView.convertPoint(CGPointZero, fromView: sender as? UIButton)
        if let indexPath = tableView.indexPathForRowAtPoint(point){
            self.indexPath = indexPath
        }
        
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Camera", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.showCamera()
        })
        let saveAction = UIAlertAction(title: "Gallery", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.showGallery()
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)

    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        //Selected Type Is Image
        if mediaType.isEqualToString(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            let imageData = UIImagePNGRepresentation(image!) //OR with path var url:NSURL = NSURL(string : "urlHere")!
            let base64String = imageData!.base64EncodedStringWithOptions(
                NSDataBase64EncodingOptions(rawValue: 0))
            

            let chat:Chat = self.chatsArray.objectAtIndex((self.indexPath!.row)) as! Chat
            ModelManager.getInstance().updateChatImage(chat.chat_id, image:base64String )
            self.refreshView()
        }
        
    }
    //MARK: Navigation methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editSegue")
        {
         
        }
    }
    
}
