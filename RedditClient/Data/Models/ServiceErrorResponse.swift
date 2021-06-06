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
