//
//  UserDetailVC.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/29.
//  Copyright © 2020 JEROME. All rights reserved.
//

import Alamofire
import UIKit

class UserDetailVC: UIViewController, Storyboarded {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var bioLabel: UILabel!
  @IBOutlet weak var loginLabel: UILabel!
  @IBOutlet weak var badgeView: UIView!
  @IBOutlet weak var siteAdminLabel: UILabel!
  @IBOutlet weak var badgeViewHeightLayout: NSLayoutConstraint!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var blogButton: UIButton!
  
  private let badgeViewDefaultHeight: CGFloat = 21
  
  var userViewModel: UserViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    assert(userViewModel != nil)
    updateUI()
  }
  
  private var isFirst = true
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard isFirst else {
      return
    }
    isFirst = false
    avatarImageView.layer.cornerRadius = avatarImageView.frame.width * 0.5
  }
  
  private func updateUI() {
    nameLabel.text = userViewModel.name ?? ""
    bioLabel.text = userViewModel.bio ?? ""
    locationLabel.text = userViewModel.location ?? ""
    loginLabel.text = userViewModel.login
    if userViewModel.siteAdmin {
      siteAdminLabel.text = "STAFF"
      badgeViewHeightLayout.constant = badgeViewDefaultHeight
    } else {
      badgeViewHeightLayout.constant = 0
    }
    userViewModel.asyncShowImage { [weak self] image in
      self?.avatarImageView.image = image
    }
    if let blog = userViewModel.blog {
      blogButton.setTitle(blog, for: .normal)
    } else {
      blogButton.setTitle("", for: .normal)
    }
  }
  
  @IBAction func closeBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func blogLinkBtnPressed(_ sender: Any) {
    guard let blog = userViewModel.blog, let url = URL(string: blog) else {
      return
    }
    UIApplication.shared.open(url)
  }
}
