//
//  WriteReplyPostViewController.swift
//  Edus
//
//  Created by michael ninh on 11/13/15.
//  Copyright © 2015 Cognitus. All rights reserved.
//

import UIKit

class WriteReplyPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var postQuestionText: UILabel!

    @IBOutlet weak var postContentText: UILabel!
    @IBOutlet weak var replyPostContentText: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBAction func takephoto(sender: AnyObject) {
        takePhoto()
    }
    
    @IBAction func submitReplyPost(sender: AnyObject) {
        print("what")
        self.replyPost.content = self.replyPostContentText.text
        self.replyPost.toPost = self.post
        self.replyPost.uploadReplyPost()
    }
    
    var post: Post?
    var replyPost = ReplyPost()
    var photoTakingHelper: PhotoTakingHelper?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.replyPostContentText.delegate = self
        self.replyPostContentText.text = "What's your reply?"
        self.replyPostContentText.textColor = UIColor.lightGrayColor()
        
        self.postQuestionText.text = self.post?.title
        self.postContentText.text = self.post?.content
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func takePhoto() {
        photoTakingHelper = PhotoTakingHelper(viewController: self) { (image: UIImage?) in
            self.replyPost.replyPostImage.value = image
            self.postImageView.image = image
            //self.photoPlaceHolder.image = image
            //self.addImageToTextView()
        }
    }
    
    //add image preview to textView
    func addImageToTextView(){
        let image = self.replyPost.replyPostImage.value
        let imgAttachment = NSTextAttachment()
        imgAttachment.image = image
        let attString = NSAttributedString(attachment: imgAttachment)
        self.replyPostContentText.textStorage.insertAttributedString(attString, atIndex: 0)
    }
    

    //text placeHolderstuff
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's your reply?"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
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
