//
//  PostDetailsViewController.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class PostDetailsViewController: UIViewController {
  @IBOutlet weak var contentView: PostDetailsContentView!
  var viewModel: PostDetailsViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupView()
  }
  
  private func setupView() {
    self.contentView.userLabel.text = self.viewModel?.author
    self.contentView.subRedditLabel.text = self.viewModel?.subReddit
    self.contentView.contentLabel.text = self.viewModel?.title

    // Load image
    FetchImagesHelper.fetchImage(url: self.viewModel?.post.url ?? "", into: self.contentView.imageView)
  }
}
