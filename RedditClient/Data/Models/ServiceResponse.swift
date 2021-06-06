//
//  ServiceResponse.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

typealias RedditPost = TopReditItemContentServiceResponse

struct TopRedditServiceResponse: Codable {
  let data: TopDataRedditServiceResponse
}

struct TopDataRedditServiceResponse: Codable {
  let dist: Int
  let children: [TopReditItemServiceResponse]
  let after: String?
  let before: String?

  var posts: [TopReditItemServiceResponse] {
    return children
  }
}

struct TopReditItemServiceResponse: Codable {
  let kind: String
  let data: TopReditItemContentServiceResponse
}

struct TopReditItemContentServiceResponse: Codable {
  let id: String
  let title: String
  let url: String
  let thumbnail: String
  let ups: Int
  let author: String
  let numComments: Int
  let subreddit: String
  var haveBeenReaded: Bool?

  mutating func markAsReaded() {
    self.haveBeenReaded = true
  }
}
