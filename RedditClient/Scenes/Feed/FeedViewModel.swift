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
      // Avoid reload table view for post deletion
      if oldValue.count < redditPosts.count || self.redditPosts.count == 0 {
        newDataArrive?(self.redditPosts)
      }
    }
  }

  var onErrorReceive: ((_: ServiceErrorResponse) -> Void)?
  private var currentTask: URLSessionDataTask?
  private var isLoadingData: Bool = false

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
  
  func clearAllPost() {
    self.redditPosts = []
  }
  
  func removePosts(visiblesRows: [Int]) {
    self.redditPosts.removeSubrange(0 ... (visiblesRows.max() ?? 0))
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
    let cellViewModel = RedditPostViewModel(post: post)
    cellViewModel.onRemovePost = { [weak self] _ in
      guard let self = self else {
        return
      }

      // Delete post
      self.deletePost(tableView: tableView, post: post)
    }

    cell.viewModel = cellViewModel

    return cell
  }

  private func deletePost(tableView: UITableView, post: RedditPost) {
    guard  let index = self.redditPosts.firstIndex(where: { $0.id == post.id }) else {
      return
    }

    let actualIndexPath = IndexPath(row: index, section: 0)
    self.redditPosts.remove(at: index)
    tableView.deleteRows(at: [actualIndexPath], with: .left)
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
