//
//  RedditServiceClient.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class RedditServiceClient {
  static private let instance = RedditServiceClient()

  static var shared: RedditServiceClient {
    return instance
  }

  private init() {}

  func fetchTopRedditPost(
    after: String,
    postPerPage: Int,
    completion: @escaping (_: Result<TopRedditServiceResponse, ServiceErrorResponse>) -> Void) -> URLSessionDataTask? {
    let strUrl = "\(ServiceDataAccessConstants.url)?limit=\(postPerPage)&after=t3_\(after)"

    guard let url = URL(string: strUrl) else {
      completion(.failure(.invalidUrl(url: strUrl)))

      return nil
    }
    
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
      guard let data = data else {
        return completion(.failure(.networkResponse))
      }

      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase

      if let decodedResponse = try? decoder.decode(TopRedditServiceResponse.self, from: data) {
        completion(.success(decodedResponse))
        return
      }

      completion(.failure(.errorParsingJson))
    }
    
    task.resume()

    return task
  }
}
