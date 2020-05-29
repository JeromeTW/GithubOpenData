//
//  UserElementViewModel.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/28.
//  Copyright © 2020 JEROME. All rights reserved.
//

import UIKit
import Alamofire

typealias ImageDownloadCompletionClosure = (_ image: UIImage, _ viewModel: UserElementViewModel) -> Void

class UserElementViewModel {
  
  private let userElement: UserElement
  
  init(userElement: UserElement) {
    self.userElement = userElement
  }
  
  
  public var login: String {
    return userElement.login
  }
  
  public var siteAdmin: Bool {
    guard let localSiteAdmin = userElement.siteAdmin else {
      assertionFailure()
      return false
    }
    return localSiteAdmin
  }
  
  func asyncShowImage(completionHanlder: @escaping ImageDownloadCompletionClosure) {
    guard let localAvatarURL = userElement.avatarURL else {
      assertionFailure()
      return
    }
    if let image = ImageCache.shared.get(localAvatarURL) {
      completionHanlder(image, self)
    } else {
      download(completionHanlder: completionHanlder)
    }
  }
  
  private func download(completionHanlder: @escaping ImageDownloadCompletionClosure) {
    guard let localAvatarURL = userElement.avatarURL else {
      assertionFailure()
      return
    }
    AF.download(localAvatarURL).responseData { [weak self] response in
      guard let strongSelf = self else { return }
      if let data = response.value {
        if let image = UIImage(data: data) {
          ImageCache.shared.insert(image, string: localAvatarURL)
          completionHanlder(image, strongSelf)
        } else {
          print("Cannot convert data to UIImage")
        }
      } else {
        print("download failed. Error: \(String(describing: response.error))")
      }
    }
  }
}
