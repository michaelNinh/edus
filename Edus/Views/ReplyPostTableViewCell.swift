//
//  ReplyPostTableViewCell.swift
//  Edus
//
//  Created by michael ninh on 11/13/15.
//  Copyright © 2015 Cognitus. All rights reserved.
//

import UIKit
import DateTools

class ReplyPostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var postContentText: UILabel!
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    
    @IBAction func deletePost(sender: AnyObject) {
    }
    
    @IBAction func flagPost(sender: AnyObject) {
    }
    
    @IBOutlet weak var upVoteButton: UIButton!
    @IBAction func upVote(sender: AnyObject) {
        self.replyPost?.toReplyPostPoints.upVote()
    }
    
    var replyPost: ReplyPost?{
        didSet{
            if let replyPost = replyPost{
                dateText.text = replyPost.createdAt?.shortTimeAgoSinceDate(NSDate()) ?? ""
                postContentText.text = replyPost.content
                nameText.text = replyPost.fromUserName
                scoreText.text = String(replyPost.toReplyPostPoints.score)
                
                if self.replyPost?.toReplyPostPoints.checkVoterList() == true{
                    self.upVoteButton.enabled = false
                }else{
                    self.upVoteButton.enabled = true
                }
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

}
