//
//  FetchImagesHelper.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

class FetchImagesHelperCache {
  private static let instance = FetchImagesHelperCache()
  
  static var shared: FetchImagesHelperCache {
    return instance
  }
  
  private init() {}
  
  private var storage: [String: Data] = [:]
  
  func dataForKey(key: String) -> Data? {
    return self.storage[key]
  }
  
  func saveData(key: String, data: Data) {
    self.storage[key] = data
  }
}

struct FetchImagesHelper {
  fileprivate static let rotationAnimationName = "rotationAnimationName"

  static func fetchImage(url strUrl: String, into imageView: UIImageView) {
    
    // Check for cache image
    if let dataImage = FetchImagesHelperCache.shared.dataForKey(key: strUrl) {
      imageView.image = UIImage(data: dataImage)
      return
    }
    
    guard let url = URL(string: strUrl) else {
      imageView.image = UIImage(named: "error")

      return
    }

    // circular animation for the image view
    imageView.setLoadingAnimation()
    
    DispatchQueue.global().async {
      guard let data = try? Data(contentsOf: url) else {
        DispatchQueue.main.async {
          imageView.removeLoadingAnimation()
          
          imageView.image = UIImage(named: "error")
        }

        return
      }

      DispatchQueue.main.async {
        imageView.removeLoadingAnimation()

        // Save image in memory for fast scrolling
        FetchImagesHelperCache.shared.saveData(key: strUrl, data: data)

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
