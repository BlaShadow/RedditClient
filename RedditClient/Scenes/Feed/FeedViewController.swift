//
//  ViewController.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class FeedViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  let refreshControl = UIRefreshControl()

  private var viewModel: FeedViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.viewModel = FeedViewModel()
    self.viewModel?.onErrorReceive = onErrorReceive
    self.viewModel?.newDataArrive = onNewDataArrive
    self.viewModel?.didSelectPost = onPostSelected

    self.setupViews()

    self.viewModel?.fetchData()
  }
  
  private func onNewDataArrive(_ _: [TopReditItemContentServiceResponse]) {
    self.refreshControl.endRefreshing()

    self.tableView.reloadData()
  }

  private func onErrorReceive(_ error: ServiceErrorResponse) {
    DialogHelper.displayAlert(title: "Error", message: "Error loading reddit posts", controller: self)
  }
  
  private func onPostSelected(_ post: RedditPost) {
    self.performSegue(withIdentifier: Constants.postDetailsSegue, sender: post)
  }
  
  @objc private func refreshContent() {
    self.viewModel?.refreshContent()
  }
  
  private func setupViews() {
    self.refreshControl.attributedTitle = NSAttributedString(string: "Refresh content")
    self.refreshControl.addTarget(self, action: #selector(self.refreshContent), for: .valueChanged)
    self.tableView.addSubview(refreshControl)
    
    self.tableView.register(UINib(nibName: "RedditPostTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.redditPostCellIdentifier)
    self.tableView.tableFooterView = UIView()
    self.tableView.delegate = self.viewModel
    self.tableView.dataSource = self.viewModel
    self.tableView.estimatedRowHeight = 200
    self.tableView.rowHeight = UITableView.automaticDimension
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.postDetailsSegue,
       let controller = segue.destination as? PostDetailsViewController,
       let post = sender as? RedditPost {
      controller.viewModel = PostDetailsViewModel(post: post)
    }
  }
}

