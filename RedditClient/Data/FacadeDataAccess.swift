//
//  FacadeDataAccess.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class FacadeDataAccess {
  static private let instance = FacadeDataAccess()

  static var shared: FacadeDataAccess {
    return instance
  }
  
  func fetchRedditPosts(after: String, completion: @escaping (_: Result<[TopReditItemContentServiceResponse], ServiceErrorResponse>) -> Void) -> URLSessionDataTask? {
    return RedditServiceClient.shared
      .fetchTopRedditPost(after: after, postPerPage: ServiceDataAccessConstants.postPerPage) { (result) in
        DispatchQueue.main.async {
          switch result {
          case .success(let response):
            completion(.success(response.data.children.map({ $0.data })))
          case .failure(let error):
            completion(.failure(error))
          }
        }
    }
  }
}
