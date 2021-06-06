//
//  RedditPostViewModel.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class RedditPostViewModel {
  let post: RedditPost
  
  init(post: RedditPost) {
    self.post = post
  }
  
  var title: String? {
    return self.post.title
  }
  
  var subReddit: String? {
    return "r/\(self.post.subreddit)"
  }
  
  var author: String? {
    return "u/\(self.post.author)"
  }
  
  var thumbnail: String? {
    return self.post.thumbnail
  }
  
  var image: String? {
    return self.post.url
  }
}
