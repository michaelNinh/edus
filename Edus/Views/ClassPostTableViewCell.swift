//
//  ClassPostTableViewCell.swift
//  Edus
//
//  Created by michael ninh on 11/11/15.
//  Copyright © 2015 Cognitus. All rights reserved.
//

import UIKit
import DateTools
import Parse
import Bond

protocol ShowFlagAlert{
    func showFlagAlert(title: String, message: String, callbackViewCell: ClassPostTableViewCell)
    func showDeleteAlert(title: String, message: String, callbackViewCell: ClassPostTableViewCell)
}


class ClassPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postTitleText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var postContentText: UITextView!
    
    
    @IBOutlet weak var upVoteButton: UIButton!
    @IBAction func upVote(sender: AnyObject) {
        postPoints.toPost = self.post
        postPoints.upVote()
        self.upVoteButton.enabled = false
        scoreText.text = String(Int(scoreText.text!)!+1)
    }
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deletePost(sender: AnyObject) {
        delegate?.showDeleteAlert("", message: "Delete post?", callbackViewCell: self)
        
    }
    
    
    @IBAction func flagPost(sender: AnyObject) {
        delegate?.showFlagAlert("", message: "Flag for inappropriate content?", callbackViewCell: self)
        
    }
    
    var voterList = [String]()
    var postPoints = PostPoints()
    var delegate: ShowFlagAlert?
    
    var post: Post?{
        didSet{
            if let post = post{
                dateText.text = post.createdAt?.shortTimeAgoSinceDate(NSDate()) ?? ""
                postTitleText.text = post.title
                postContentText.text = post.content
                nameText.text = post.fromUserName
                
                //IMAGE CODE
                
                postImage.image = post.postImage.value
                post.postImage.bindTo(postImage.bnd_image)
            
                print("the current text value of the score is \(self.scoreText.text)")
            }
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
    func flagContentAction(){
        let postFlagger = PostFlag()
        postFlagger.toPost = self.post
        postFlagger.fromUser = PFUser.currentUser()
        postFlagger.toUser = self.post?.fromUser
        postFlagger.flagContent()
    }
    
    func deleteContentAction(){
        self.post?.deletePost()
    }
    
}
