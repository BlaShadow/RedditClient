//
//  ViewController.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class FeedViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var clearAllButton: UIBarButtonItem!
  
  let refreshControl = UIRefreshControl()

  private var viewModel: FeedViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.viewModel = FeedViewModel()
    self.viewModel?.onErrorReceive = onErrorReceive
    self.viewModel?.newDataArrive = onNewDataArrive
    self.viewModel?.didSelectPost = onPostSelected

    self.setupViews()

    self.viewModel?.initialFetchData()
  }

  @IBAction func clearAllPostAction(_ sender: Any) {
    self.clearAllButton.isEnabled = false

    self.tableView.beginUpdates()
    let values = self.tableView.indexPathsForVisibleRows ?? []
    self.viewModel?.removePosts(visiblesRows: values.map({ $0.row }))
    self.tableView.deleteRows(at: values, with: .top)
    self.tableView.endUpdates()
    
    // Disable clear button
    self.clearAllButton.isEnabled = false
    
    // Clear all post
    self.viewModel?.clearAllPost()
  }
  
  private func onNewDataArrive(_ items: [TopReditItemContentServiceResponse]) {
    self.refreshControl.endRefreshing()

    // Disable clear all button
    self.clearAllButton.isEnabled = items.count > 0

    // Reload data
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
  
  // Mark: Setup view method
  private func setupViews() {
    // - Disable clear all button
    self.clearAllButton.isEnabled = false

    // Refresh control
    self.refreshControl.attributedTitle = NSAttributedString(string: "Refresh content")
    self.refreshControl.addTarget(self, action: #selector(self.refreshContent), for: .valueChanged)
    self.tableView.addSubview(refreshControl)
    
    // - Table View
    self.tableView.register(UINib(nibName: "RedditPostTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.redditPostCellIdentifier)
    self.tableView.tableFooterView = UIView()
    self.tableView.delegate = self.viewModel
    self.tableView.dataSource = self.viewModel
    self.tableView.estimatedRowHeight = 200
    self.tableView.rowHeight = UITableView.automaticDimension
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.postDetailsSegue,
       let navController = segue.destination as? UINavigationController,
       let controller = navController.topViewController as? PostDetailsViewController,
       let post = sender as? RedditPost {
      controller.viewModel = PostDetailsViewModel(post: post)
    }
  }
}

