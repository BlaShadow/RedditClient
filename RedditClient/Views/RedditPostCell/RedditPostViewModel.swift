//
//  RedditPostViewModel.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class RedditPostViewModel {
  var post: RedditPost
  var onRemovePost: ((_: RedditPost) -> Void)?
  
  init(post: RedditPost) {
    self.post = post
  }
  
  func removePost() {
    self.onRemovePost?(self.post)
  }
}

extension RedditPostViewModel: DisplayableRedditPostProtocol {}
