//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 横田瑛美 on 2022/03/18.
//

import UIKit
import FirebaseStorageUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var comentWriteButton: UIButton!
    @IBOutlet weak var comentHyoujiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData) {
        
        // コメントの表示
            var comments = ""
            for comment in postData.comments {
              comments += "\(comment)\n"
            }
            self.comentHyoujiLabel.text = comments
        
         postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
         let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
         postImageView.sd_setImage(with: imageRef)
        
         self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
         self.dateLabel.text = ""
         if let date = postData.date {
            let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
          self.dateLabel.text = dateString
         
    }
        
         let likeNumber = postData.likes.count
             likeLabel.text = "\(likeNumber)"
        
        if postData.isLiked {
           let buttonImage = UIImage(named: "like_exist")
           self.likeButton.setImage(buttonImage, for: .normal)
        } else {
           let buttonImage = UIImage(named: "like_none")
           self.likeButton.setImage(buttonImage, for: .normal)
          }
        }
    
}
