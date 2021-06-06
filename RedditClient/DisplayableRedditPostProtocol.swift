//
//  DisplayableRedditPostProtocol.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

protocol DisplayableRedditPostProtocol {
  var post: RedditPost {get set}
}

extension DisplayableRedditPostProtocol {
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
  
  var comments: String {
    return "\(self.post.numComments) comments"
  }
  
  var haveBeenReaded: Bool {
    return self.post.haveBeenReaded ?? false
  }
}
