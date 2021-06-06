//
//  FeedViewModel.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class FeedViewModel: NSObject {
  var didSelectPost: ((_: RedditPost) -> Void)?

  var newDataArrive: ((_: [TopReditItemContentServiceResponse]) -> Void)?
  
  private var redditPosts: [TopReditItemContentServiceResponse] = [] {
    didSet {
      newDataArrive?(self.redditPosts)
    }
  }

  var onErrorReceive: ((_: ServiceErrorResponse) -> Void)?
  var currentTask: URLSessionDataTask?
  var isLoadingData: Bool = false

  var lastPostIdentifier: String {
    return self.redditPosts.last?.id ?? ""
  }

  var error: ServiceErrorResponse? {
    didSet {
      if let error = self.error {
        onErrorReceive?(error)
      }
    }
  }
  
  func refreshContent() {
    self.redditPosts = []

    self.fetchData()
  }
  
  func fetchData(after: String = "") {
    self.isLoadingData = true
    
    self.currentTask = FacadeDataAccess.shared.fetchRedditPosts(after: after, completion: { [weak self] result in
      self?.isLoadingData = false

      guard let self = self else {
        return
      }

      switch result {
      case .success(let items):
        self.redditPosts.append(contentsOf: items)
      case .failure(let error):
        self.error = error
      }
    })
  }
  
  deinit {
    if let task = self.currentTask, task.state == .running {
      task.cancel()
    }
  }
}

extension FeedViewModel: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.redditPosts.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.redditPostCellIdentifier) as? RedditPostTableViewCell else {
      return UITableViewCell()
    }

    let post = self.redditPosts[indexPath.row]
    cell.viewModel = RedditPostViewModel(post: post)

    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let post = self.redditPosts[indexPath.row]

    // Post details event
    didSelectPost?(post)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let shouldLoadMore = self.redditPosts.count - indexPath.row == 4

    if shouldLoadMore && isLoadingData == false {
      self.fetchData(after: self.lastPostIdentifier)
    }
  }
}
