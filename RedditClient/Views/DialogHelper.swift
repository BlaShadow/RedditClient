//
//  DialogHelper.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

struct DialogHelper {
  static func displayAlert(title: String, message: String, controller: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

    controller.present(alert, animated: true, completion: nil)
  }
}
