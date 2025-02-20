//
//  CreateNewClassViewController.swift
//  Edus
//
//  Created by michael ninh on 11/10/15.
//  Copyright © 2015 Cognitus. All rights reserved.
//

import UIKit
import Parse
import Mixpanel

class CreateNewClassViewController: UIViewController, UITextFieldDelegate {
    
    var selectedSubject: SubjectList?
    
    @IBOutlet weak var classNameField: UITextField!
    @IBOutlet weak var professorLastNameField: UITextField!
    
    @IBOutlet weak var subjectButtonText: UIButton!
    @IBAction func subjectButton(sender: AnyObject) {
    }
    
    @IBOutlet weak var subjectText: UIButton!
    
    @IBOutlet weak var levelSegementControlButton: UISegmentedControl!
    
    
    @IBAction func addClassButton(sender: AnyObject) {
        let classroom = Classroom()
        classroom.subject = self.selectedSubject?.subjectName
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("New class added")
        
        
        switch levelSegementControlButton.selectedSegmentIndex{
        case 0:
            classroom.subjectLevel = "Intro"
            print("intro")
        case 1:
            classroom.subjectLevel = "Intermediate"
        case 2:
            classroom.subjectLevel = "Advanced"
        default:
            break;
        }
        
        classroom.classTitle = self.classNameField.text
        classroom.professorLastName = self.professorLastNameField.text
        
        classroom.enrollClass()
        createdClassSegue()

        
    }
    
    func createdClassSegue(){
        self.performSegueWithIdentifier("createdClassSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this sets the button label to be selected subject
        if selectedSubject != nil{
            self.subjectButtonText.setTitle(self.selectedSubject?.subjectName, forState: .Normal)
        }else{
            self.subjectButtonText.setTitle("Select subject", forState: .Normal)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Close keyboard
    
    /**
    * Called when 'return' key pressed. return NO to ignore.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        self.view.endEditing(true)
    }

}
