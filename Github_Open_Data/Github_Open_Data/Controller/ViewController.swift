//
//  ViewController.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/28.
//  Copyright © 2020 JEROME. All rights reserved.
//

import Alamofire
import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
    }
  }
  
  var userElementViewModels: [UserElementViewModel] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    let getAllURLString = "https://api.github.com/users"
    AF.request(getAllURLString).response { [weak self] response in
      if let data = response.data {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
          let users = try decoder.decode([UserElement].self, from: data)
          self?.userElementViewModels = users.map({ (userElement) -> UserElementViewModel in
            return UserElementViewModel(userElement: userElement)
          })
          self?.tableView.reloadData()
        } catch {
          print("decode failed. Error: \(String(describing: error))")
        }
      } else {
        print("download failed. Error: \(String(describing: response.error))")
      }
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userElementViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: String(describing: UserElementCell.self), for: indexPath) as? UserElementCell)!
    let modelView = userElementViewModels[indexPath.row]
    cell.resetUI()
    cell.updateUI(viewModel: modelView)
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  
}

