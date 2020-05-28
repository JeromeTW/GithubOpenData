//
//  UserElementViewModel.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/28.
//  Copyright © 2020 JEROME. All rights reserved.
//

import Foundation
import Alamofire

public typealias ImageDownloadCompletionClosure = (_ imageData: Data ) -> Void

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
  
  func download(completionHanlder: @escaping ImageDownloadCompletionClosure) {
    AF.download(userElement.avatarURL).responseData { response in
      if let data = response.value {
        completionHanlder(data)
      } else {
        print("download failed. Error: \(String(describing: response.error))")
      }
    }
  }
}
