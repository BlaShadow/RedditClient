//
//  LocalDataAccess.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class LocalDataAccess {
  static private let instance = LocalDataAccess()

  static var shared: LocalDataAccess {
    return instance
  }
  
  func storageAllData(posts: [RedditPost]) {
    let userDefaults = UserDefaults.standard
    
    let postsJsonData = try? JSONEncoder().encode(posts)
    userDefaults.setValue(postsJsonData, forKey: Constants.postsStoragekey)
    userDefaults.synchronize()
  }
  
  func fetchSavedPosts() -> [RedditPost] {
    let userDefaults = UserDefaults.standard

    guard let data = userDefaults.value(forKey: Constants.postsStoragekey) as? Data else {
      return []
    }

    let posts = try? JSONDecoder().decode([RedditPost].self, from: data)

    return posts ?? []
  }
}
