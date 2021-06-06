//
//  PostDetailsViewController.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit
import Photos

class PostDetailsViewController: UIViewController {
  @IBOutlet weak var contentView: PostDetailsContentView!
  var viewModel: PostDetailsViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupView()
  }
  
  @IBAction func saveImage(_ sender: Any) {
    self.viewModel?.savePostImage(completion: { (error) in
      if let error = error {
        DialogHelper.displayAlert(title: "Error", message: error.localizedDescription, controller: self)
      } else {
        DialogHelper.displayAlert(title: "Information", message: "Image saved successfully", controller: self)
      }
    })
  }
  
  private func setupView() {
    guard self.viewModel != nil else {
      return
    }
    
    self.contentView.userLabel.text = self.viewModel?.author
    self.contentView.subRedditLabel.text = self.viewModel?.subReddit
    self.contentView.contentLabel.text = self.viewModel?.title

    // Load image
    FetchImagesHelper.fetchImage(url: self.viewModel?.post.url ?? "", into: self.contentView.imageView)
  }
}
