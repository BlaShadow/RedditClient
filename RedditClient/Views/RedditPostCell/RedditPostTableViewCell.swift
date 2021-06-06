//
//  RedditPostTableViewCell.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class RedditPostTableViewCell: UITableViewCell {

  var viewModel: RedditPostViewModel? {
    didSet {
      print("make some changes")
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
