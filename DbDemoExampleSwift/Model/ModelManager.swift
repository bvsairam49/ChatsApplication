//
//  ModelManager.swift
//  DataBaseDemo
//
//  Created by Krupa-iMac on 05/08/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

let sharedInstance = ModelManager()

class ModelManager: NSObject {
    
    var database: FMDatabase? = nil

    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Util.getPath("Chats.sqlite"))
        }
        return sharedInstance
    }
  
    func updateChatCounter(chat_id: Int, counterNuber:Int) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Chats SET count=? WHERE chat_id=?", withArgumentsInArray: [counterNuber,chat_id])
        sharedInstance.database!.close()
        return isUpdated
    }
    func updateChatImage(chat_id: Int, image:String, time:String) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Chats SET image=?, time=?  WHERE chat_id=?", withArgumentsInArray: [image,time,chat_id])
        sharedInstance.database!.close()
        return isUpdated
    }
    func deleteChatData(chat_id: Int) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Chats WHERE chat_id=?", withArgumentsInArray: [chat_id])
        sharedInstance.database!.close()
        return isDeleted
    }

    func getAllStudentData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Chats", withArgumentsInArray: nil)
        let chatsArray : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let newChat : Chat = Chat()
                newChat.chat_id = Int(resultSet.intForColumn("chat_id"))
                newChat.name = resultSet.stringForColumn("name")
                newChat.descr = resultSet.stringForColumn("description")
                newChat.image = resultSet.stringForColumn("image")
                newChat.time = resultSet.stringForColumn("time")
                newChat.counnter = Int(resultSet.intForColumn("count"))
                newChat.online_status = Bool(resultSet.boolForColumn("online-status"))
                chatsArray.addObject(newChat)
            }
        }
        sharedInstance.database!.close()
        return chatsArray
    }
}
