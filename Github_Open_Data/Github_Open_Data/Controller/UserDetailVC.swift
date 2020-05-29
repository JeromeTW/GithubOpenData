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
  
  private func updateUI() {
    nameLabel.text = userViewModel.name
    bioLabel.text = userViewModel.bio
    loginLabel.text = userViewModel.login
    if userViewModel.siteAdmin {
      siteAdminLabel.text = "STAFF"
      badgeViewHeightLayout.constant = badgeViewDefaultHeight
    }
    userViewModel.asyncShowImage { [weak self] image in
      self?.avatarImageView.image = image
    }
  }
  
  @IBAction func closeBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func blogLinkBtnPressed(_ sender: Any) {
    // TODO: Open Safari
  }
}
