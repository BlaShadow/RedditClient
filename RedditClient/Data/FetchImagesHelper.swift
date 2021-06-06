//
//  FetchImagesHelper.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

struct FetchImagesHelper {
  fileprivate static let rotationAnimationName = "rotationAnimationName"

  static func fetchImage(url: String, into imageView: UIImageView) {
    guard let url = URL(string: url) else {
      imageView.image = UIImage(named: "error")

      return
    }

    // circular animation for the image view
    imageView.setLoadingAnimation()
    
    DispatchQueue.global().async {
      guard let data = try? Data(contentsOf: url) else {
        imageView.removeLoadingAnimation()

        DispatchQueue.main.async {
          imageView.image = UIImage(named: "error")
        }

        return
      }

      DispatchQueue.main.async {
        imageView.removeLoadingAnimation()

        imageView.image = UIImage(data: data)
      }
    }
  }
}

extension UIImageView {
  fileprivate func removeLoadingAnimation() {
    self.layer.removeAnimation(forKey: FetchImagesHelper.rotationAnimationName)
  }

  fileprivate func setLoadingAnimation() {
    removeLoadingAnimation()
    
    let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
    rotationAnimation.duration = 1.250
    rotationAnimation.repeatCount = Float.greatestFiniteMagnitude

    self.layer.add(rotationAnimation, forKey: FetchImagesHelper.rotationAnimationName)
  }
}
