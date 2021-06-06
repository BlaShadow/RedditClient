//
//  RedditPostTableViewCell.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class RedditPostTableViewCell: UITableViewCell {

  @IBOutlet weak var subRedditLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var content: UILabel!
  @IBOutlet weak var postImage: UIImageView!
  @IBOutlet weak var commentsLabel: UILabel!
  @IBOutlet weak var deletePostImageView: UIImageView!
  
  var viewModel: RedditPostViewModel? {
    didSet {
      self.authorLabel.text = self.viewModel?.author
      self.subRedditLabel.text = self.viewModel?.subReddit
      self.content.text = self.viewModel?.title
      self.commentsLabel.text = self.viewModel?.comments

      // Load remove image
      FetchImagesHelper.fetchImage(url: self.viewModel?.thumbnail ?? "", into: self.postImage)
      
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removePost))
      self.deletePostImageView.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func removePost() {
    self.viewModel?.removePost()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
