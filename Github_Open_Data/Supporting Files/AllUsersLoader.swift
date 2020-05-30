//
//  AllUsersLoader.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/30.
//  Copyright © 2020 JEROME. All rights reserved.
//

import Foundation
import Alamofire

typealias UserElementViewModelsDownloadedCompletion = ([UserElementViewModel]) -> Void

class AllUsersLoader {
  
  // MARK:- state and initializer
  private var firstSince: Int = 0
  private var firstPerPage: Int = 20
  
  private var fisrtQueryURLString: String {
    return "https://api.github.com/users?since=\(firstSince)&per_page=\(firstPerPage)"
  }
  
  private var nextQueryURLString: String?
  private var isLoading = false
  
  init(firstSince: Int = 0, firstPerPage: Int = 20) {
    self.firstSince = firstSince
    self.firstPerPage = firstPerPage
  }
  
  // MARK:- implementation of business logic
  func load(completion: @escaping UserElementViewModelsDownloadedCompletion) {
    guard isLoading == false else {
      print("Do not load until the last load is completed")
      return
    }
    
    var localURLString = ""
    if let nextQueryURLString = nextQueryURLString {
      localURLString = nextQueryURLString
    } else {
      localURLString = fisrtQueryURLString
    }
    isLoading = true
    AF.request(localURLString).response { [weak self] response in
      defer {
        self?.isLoading = false
      }
      if let data = response.data, let headerFields = response.response?.allHeaderFields, let nextLinkString = headerFields["Link"] as? String {
        // nextLinkString will be something like:
        // <https://api.github.com/users?since=19&per_page=5>; rel="next", <https://api.github.com/users{?since}>; rel="first"
        print("nextLinkString: \(nextLinkString)")
        let findingKey = "; rel=\"next\""
        var foundNextLink = ""
        guard let tempString = nextLinkString.components(separatedBy: ",").filter({ string -> Bool in
          string.contains(findingKey)
        }).first else {
          assertionFailure()
          return
        }
        foundNextLink = tempString.replacingOccurrences(of: findingKey, with: "").replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
        print("foundNextLink: \(foundNextLink)")
        self?.nextQueryURLString = foundNextLink
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
          let users = try decoder.decode([UserElement].self, from: data)
          let viewModels = users.map({ (userElement) -> UserElementViewModel in
            return UserElementViewModel(userElement: userElement)
          })
          completion(viewModels)
        } catch {
          print("decode failed. Error: \(String(describing: error))")
          completion([])
        }
      } else {
        print("download failed. Error: \(String(describing: response.error))")
        completion([])
      }
    }
  }
}
