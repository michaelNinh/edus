//
//  PostModel.swift
//  Edus
//
//  Created by michael ninh on 11/11/15.
//  Copyright © 2015 Cognitus. All rights reserved.
//

import Foundation
import Parse
import Mixpanel
import Bond

class Post: PFObject, PFSubclassing{
    
    var title: String?
    var content: String?
    var fromUser: PFUser?
    var fromUserName: String?
    var anonymous: Bool = false
   
    //var toPostPoints = PostPoints()
    
    var toClassroom:Classroom?
    var subject:String?
    var subjectLevel:String?
    
    var imageFile: PFFile?
    var postImage: Dynamic <UIImage?> = Dynamic(nil)
    
    func uploadPost(){
        let query = PFObject(className: "Post")
        query["title"] = self.title
        query["content"] = self.content
        query["anonymous"] = self.anonymous
        query["fromUser"] = self.fromUser
        query["fromUserName"] = PFUser.currentUser()?.username!
        query["subject"] = self.subject
        query["subjectLevel"] = self.subjectLevel
        query["toClassroom"] = self.toClassroom
    
        query.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("post uploaded")
            let mixpanel: Mixpanel = Mixpanel.sharedInstance()
            mixpanel.track("Post uploaded")
        }
        
        
    }
    
    func setPost(){
        
        self.title = self["title"] as? String
        self.content = self["content"] as? String
        self.fromUser = self["fromUser"] as? PFUser
        self.anonymous = (self["anonymous"] as? Bool)!
        self.toClassroom = self["toClassroom"] as? Classroom
        self.subject = self["subject"] as? String
        self.subjectLevel = self["subjectLevel"] as? String
        if self.anonymous == true{
            self.fromUserName = "Anon Y. Moose"
        }else{
            self.fromUserName = self["fromUserName"] as? String
        }
        
        //set image
        downloadImage()
    }
    
    //function to dl image from parse
    func downloadImage(){
        if let imgData = self["imageFile"] as? PFFile {
            imgData.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil){
                    let image = UIImage(data: imageData!)
                    self.image.value = image
                }
            })
        }
        
    }
    
    //upload athe photo
    func uploadPhoto() {
        //so...this works but it shouldnt be like this lOL...this is the nil catcher
        if image.value == nil{
            //image.value = UIImage(named: "addPhoto")
            print("these is no photo")
        } else{
            let imageData = UIImageJPEGRepresentation(image.value, 0.8)
            let imageFile = PFFile(data: imageData)
            self.imageFile = imageFile
            imageFile.saveInBackground()}
    }
    
    
    
    func deletePost(){
        print(self.objectId!)
        let query = PFQuery(className: "Post")
        query.getObjectInBackgroundWithId(self.objectId!) { (result: PFObject?, error: NSError?) -> Void in
            if error != nil{
                print(error)
            }else{
                result?.deleteInBackgroundWithBlock({ (succes: Bool, error: NSError?) -> Void in
                    print("post deleted")
                    let deleterPostPoints = PostPoints()
                    deleterPostPoints.toPost = self
                    deleterPostPoints.deletePostPoints()
                })
            }
        }
    }
    
    
    //start protocol code for PFSubclass
    static func parseClassName() -> String {
        return "Post"
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    //end
}
