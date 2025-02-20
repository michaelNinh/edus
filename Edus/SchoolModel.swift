//
//  SchoolModel.swift
//  Edus
//
//  Created by michael ninh on 11/9/15.
//  Copyright © 2015 Cognitus. All rights reserved.
//

import Foundation
import Parse

class School: PFObject, PFSubclassing{
    
    var schoolName: String?
    //i am not entirely sure this list of users is even needed
    var enrolledUsers: [PFUser]?
    
    
    //this is async - using "school.save" requires knowledge of throws? must learn
    //creation of an entirely new school, first student
    func createNewSchool(){

        let school = PFObject(className: "School")
        school["schoolName"] = self.schoolName
        school.addObject(PFUser.currentUser()!.objectId!, forKey: "enrolledUsers")
        
        school.ACL?.publicReadAccess = true
        school.ACL?.publicWriteAccess = true

        
        school.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("School saved.")
        }
        
        let currentUser = PFUser.currentUser()!
        currentUser["activeSchool"] = school
        currentUser["activeSchoolName"] = self.schoolName
        currentUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("User assigned school saved.")
        }
        
        
    }
    
    func addStudentIntoSchool(){
        let schoolQuery = PFQuery(className: "School")
        schoolQuery.getObjectInBackgroundWithId(self.objectId!) { (result:  PFObject?, error: NSError?) -> Void in
            let targetSchool = result as! School
            targetSchool.addObject(PFUser.currentUser()!.objectId!, forKey: "enrolledUsers")
            targetSchool.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                print("added User to school")
            }
        }
        
    }
    
    func enrolledSchool(){
        let school = PFObject(className: "School")
        school.saveInBackground()
    }
    
    func setSchoolName(){
        self.schoolName = self["schoolName"] as? String
    }
    
    
    
    //start protocol code for PFSubclass
    static func parseClassName() -> String {
        return "School"
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
