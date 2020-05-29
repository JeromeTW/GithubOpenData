//
//  ImageCache.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/29.
//  Copyright © 2020 JEROME. All rights reserved.
//

import UIKit

// Singleton object
class ImageCache: NSObject {
  static let shared = ImageCache()
  // TaskID: Task
  private let cache = NSCache<NSString, UIImage>()
  
  private override init() {
    super.init()
  }
  
  func flushData() {
    cache.removeAllObjects()
  }
  
  func insert(_ image: UIImage, string: String) {
    cache.setObject(image, forKey: NSString(string: string))
  }
  
  func get(_ string: String) -> UIImage? {
    if let image = cache.object(forKey: NSString(string: string)) {
      return image
    } else {
      return nil
    }
  }
}
