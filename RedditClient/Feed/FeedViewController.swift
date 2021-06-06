//
//  ViewController.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class FeedViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  private var viewModel: FeedViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.viewModel = FeedViewModel()
    self.viewModel?.onErrorReceive = onErrorReceive
    self.viewModel?.newDataArrive = onNewDataArrive

    self.setupViews()

    self.viewModel?.fetchData()
  }
  
  private func onNewDataArrive(_ _: [TopReditItemContentServiceResponse]) {
    self.tableView.reloadData()
  }

  private func onErrorReceive(_ error: ServiceErrorResponse) {
    DialogHelper.displayAlert(title: "Error", message: "Error loading reddit posts", controller: self)
  }
  
  private func setupViews() {
    self.tableView.register(UINib(nibName: "RedditPostTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.redditPostCellIdentifier)
    self.tableView.tableFooterView = UIView()
    self.tableView.delegate = self.viewModel
    self.tableView.dataSource = self.viewModel
  }
}

