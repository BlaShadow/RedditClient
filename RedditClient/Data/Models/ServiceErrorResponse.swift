//
//  ServiceErrorResponse.swift
//  RedditClient
//
//  Created by Luis Romero on 6/6/21.
//

import UIKit

enum ServiceErrorResponse: Error {
  case invalidUrl(url: String)
  case networkResponse
  case errorParsingJson
  case strError(value: String)
}

extension ServiceErrorResponse: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .strError(let value):
      return value
    default:
      return "No description"
    }
  }
}
