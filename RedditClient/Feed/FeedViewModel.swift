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
  
  var error: ServiceErrorResponse? {
    didSet {
      if let error = self.error {
        onErrorReceive?(error)
      }
    }
  }
  
  func fetchData() {
    FacadeDataAccess.shared.fetchRedditPosts(completion: { [weak self] result in
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
}
