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
    if let memoryImage = self.storage[key] {
      return memoryImage
    }

    return nil
  }
  
  func saveData(key: String, data: Data) {
    self.storage[key] = data
  }
}

struct FetchImagesHelper {
  fileprivate static let rotationAnimationName = "rotationAnimationName"

  static func fetchImageData(url strUrl: String, completion: @escaping (_: Data?) -> Void) {
    // Check for cache image
    if let dataImage = FetchImagesHelperCache.shared.dataForKey(key: strUrl) {
      completion(dataImage)

      return
    }
    
    guard let url = URL(string: strUrl) else {
      completion(nil)

      return
    }

    DispatchQueue.global().async {
      guard let data = try? Data(contentsOf: url) else {
        DispatchQueue.main.async {
          completion(nil)
        }

        return
      }

      DispatchQueue.main.async {
        completion(data)
      }
    }
  }
  
  static func fetchImage(url strUrl: String, into imageView: UIImageView) {
    // circular animation for the image view
    imageView.setLoadingAnimation()
    
    
    fetchImageData(url: strUrl) { (dataImage) in
      imageView.removeLoadingAnimation()

      guard let dataImage = dataImage else {
        imageView.image = UIImage(named: "error")

        return
      }

      // Save image in memory for fast scrolling
      FetchImagesHelperCache.shared.saveData(key: strUrl, data: dataImage)
      
      // Set image
      imageView.image = UIImage(data: dataImage)
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
