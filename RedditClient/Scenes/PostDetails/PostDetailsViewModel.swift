//
//  PostDetailsViewModel.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit
import Photos

class PostDetailsViewModel {
  var post: RedditPost

  init(post: RedditPost) {
    self.post = post
  }
  
  func savePostImage(completion: @escaping (_: Error?) -> Void) {
    let status = PHPhotoLibrary.authorizationStatus()

    if status != .authorized {
      completion(ServiceErrorResponse.strError(value: "Access error \(status)"))

      return
    }
    
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      guard let self = self else {
        return
      }

      guard status == .authorized else {
        completion(ServiceErrorResponse.strError(value: "Access error \(status)"))

        return
      }

      DispatchQueue.main.async {
        self.saveImageHandler(completion: completion)
      }
    }
  }
  
  private func saveImage(image: UIImage, completion: @escaping (_: Error?) -> Void) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAsset(from: image)
    }, completionHandler: { success, error in
      DispatchQueue.main.async {
        if success {
          completion(nil)
        } else if let error = error {
          completion(error)
        } else {
          completion(ServiceErrorResponse.strError(value: "Unkown error"))
        }
      }
    })
  }

  private func saveImageHandler(completion: @escaping (_: Error?) -> Void) {
    FetchImagesHelper.fetchImageData(url: post.url, completion: { [weak self] (imageData) in
      guard let self = self, let data = imageData, let image = UIImage(data: data) else {
        return
      }

      self.saveImage(image: image, completion: { (error) in
        if let error = error {
          completion(ServiceErrorResponse.strError(value: "Error saving photo \(error)"))
        } else {
          completion(nil)
        }
      })
    })
  }
}

extension PostDetailsViewModel: DisplayableRedditPostProtocol { }
