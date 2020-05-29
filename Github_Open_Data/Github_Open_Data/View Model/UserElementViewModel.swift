//
//  UserElementViewModel.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/28.
//  Copyright © 2020 JEROME. All rights reserved.
//

import UIKit
import Alamofire

public typealias ImageDownloadCompletionClosure = (_ image: UIImage ) -> Void

class UserElementViewModel {
  
  private let userElement: UserElement
  
  init(userElement: UserElement) {
    self.userElement = userElement
  }
  
  
  public var name: String {
    return userElement.login
  }
  
  public var siteAdmin: Bool {
    return userElement.siteAdmin
  }
  
  func asyncShowImage(completionHanlder: @escaping ImageDownloadCompletionClosure) {
    if let image = ImageCache.shared.get(userElement.avatarURL) {
      completionHanlder(image)
    } else {
      download(completionHanlder: completionHanlder)
    }
  }
  
  private func download(completionHanlder: @escaping ImageDownloadCompletionClosure) {
    AF.download(userElement.avatarURL).responseData { [weak self] response in
      guard let strongSelf = self else { return }
      if let data = response.value {
        if let image = UIImage(data: data) {
          ImageCache.shared.insert(image, string: strongSelf.userElement.avatarURL)
          completionHanlder(image)
        } else {
          print("Cannot convert data to UIImage")
        }
      } else {
        print("download failed. Error: \(String(describing: response.error))")
      }
    }
  }
}
