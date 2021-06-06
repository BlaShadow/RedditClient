//
//  PostDetailsViewModel.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class PostDetailsViewModel {
  var post: RedditPost

  init(post: RedditPost) {
    self.post = post
  }
}

extension PostDetailsViewModel: DisplayableRedditPostProtocol { }
