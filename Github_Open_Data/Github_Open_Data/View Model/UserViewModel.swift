//
//  UserViewModel.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/29.
//  Copyright © 2020 JEROME. All rights reserved.
//

import UIKit
import Alamofire

typealias ImageDownloadCompletionClosure = (_ image: UIImage) -> Void

class UserViewModel {
  
  private let user: User
  
  init(user: User) {
    self.user = user
  }
  
  public var login: String {
    return user.login
  }
  
  public var name: String? {
    return user.name
  }

  public var bio: String? {
    return user.bio
  }
  
  public var location: String? {
    return user.location
  }
  
  public var blog: String? {
    return user.blog
  }
  
  public var siteAdmin: Bool {
    guard let localSiteAdmin = user.siteAdmin else {
      assertionFailure()
      return false
    }
    return localSiteAdmin
  }
  
  func asyncShowImage(completionHanlder: @escaping ImageDownloadCompletionClosure) {
    guard let localAvatarURL = user.avatarURL else {
      assertionFailure()
      return
    }
    if let image = ImageCache.shared.get(localAvatarURL) {
      completionHanlder(image)
    } else {
      download(completionHanlder: completionHanlder)
    }
  }
  
  private func download(completionHanlder: @escaping ImageDownloadCompletionClosure) {
    guard let localAvatarURL = user.avatarURL else {
      assertionFailure()
      return
    }
    AF.download(localAvatarURL).responseData { [weak self] response in
      if let data = response.value {
        if let image = UIImage(data: data) {
          ImageCache.shared.insert(image, string: localAvatarURL)
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
