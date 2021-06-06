//
//  MasterDetailsViewController.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class MasterDetailsViewController: UISplitViewController, UISplitViewControllerDelegate  {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
    self.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
  }
  
  func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
    return .supplementary
  }

  func splitViewController(
    _ splitViewController: UISplitViewController,
    collapseSecondary secondaryViewController: UIViewController,
    onto primaryViewController: UIViewController) -> Bool {
    return false
  }
}

