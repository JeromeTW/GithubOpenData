//
//  ViewController.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/28.
//  Copyright © 2020 JEROME. All rights reserved.
//

import Alamofire
import UIKit
import MBProgressHUD

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.rowHeight = 90
      tableView.contentInsetAdjustmentBehavior = .never
    }
  }
  
  private var userElementViewModels: [UserElementViewModel] = []
  private let allUsersLoader = AllUsersLoader()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fecthData()
  }
  
  private func fecthData() {
    tableView.showFooterIndicator(style: .large, color: .gray, scale: 2.0, paddingY: 20)
    allUsersLoader.load { [weak self] viewModels in
      defer {
        self?.tableView.tableFooterView = nil
      }
      self?.userElementViewModels.append(contentsOf: viewModels)
      self?.tableView.reloadData()
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userElementViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: String(describing: UserElementCell.self), for: indexPath) as? UserElementCell)!
    let viewModel = userElementViewModels[indexPath.row]
    cell.resetUI()
    cell.updateUI(viewModel: viewModel)
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    // Push the dividing line given by the system out of the screen
    cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let viewModel = userElementViewModels[indexPath.row]
    let getUserURLString = "https://api.github.com/users/" + viewModel.login
    MBProgressHUD.showAdded(to: view, animated: true)
    AF.request(getUserURLString).response { [weak self] response in
      guard let strongSelf = self else { return }
      defer {
        MBProgressHUD.hide(for: strongSelf.view, animated: true)
      }
      if let data = response.data {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
          let user = try decoder.decode(User.self, from: data)
          let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
          let userDetailVC = UserDetailVC.instantiate(storyboard: storyboard)
          userDetailVC.userViewModel = UserViewModel(user: user)
          userDetailVC.modalPresentationStyle = .fullScreen
          strongSelf.present(userDetailVC, animated: true, completion: nil)
        } catch {
          print("decode failed. Error: \(String(describing: error))")
        }
      } else {
        print("download failed. Error: \(String(describing: response.error))")
      }
    }
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    
    if maximumOffset - currentOffset <= 10.0 {
      fecthData()
    }
  }
}

