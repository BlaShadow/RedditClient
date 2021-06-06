//
//  RedditPostViewModel.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class RedditPostViewModel {
  var post: RedditPost
  
  init(post: RedditPost) {
    self.post = post
  }
}

extension RedditPostViewModel: DisplayableRedditPostProtocol {}
