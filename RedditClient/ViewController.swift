//
//  ViewController.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  private var redditPosts: [TopReditItemContentServiceResponse] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupViews()
  }
  
  private func setupViews() {
    self.tableView.register(UINib(nibName: "RedditPostTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.redditPostCellIdentifier)
    self.tableView.tableFooterView = UIView()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    FacadeDataAccess.shared.fetchRedditPosts(completion: { [weak self] result in
      guard let self = self else {
        return
      }

      switch result {
      case .success(let items):
        self.redditPosts.append(contentsOf: items)
      case .failure:
        DialogHelper.displayAlert(title: "Error", message: "Error loading reddit posts", controller: self)
      }
    })
  }
}

