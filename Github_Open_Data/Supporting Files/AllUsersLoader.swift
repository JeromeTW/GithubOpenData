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
  private var since: Int = 0
  private var perPage: Int = 20
  
  private var queryURLString: String {
    return "https://api.github.com/users?since=\(since)&per_page=\(perPage)"
  }
  
  init(since: Int = 0, perPage: Int = 20) {
    self.since = since
    self.perPage = perPage
  }
  
  // MARK:- implementation of business logic
  func load(completion: @escaping UserElementViewModelsDownloadedCompletion) {
    AF.request(queryURLString).response { response in
      if let data = response.data {
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
