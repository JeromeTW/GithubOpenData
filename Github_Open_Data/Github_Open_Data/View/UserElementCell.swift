//
//  UserElementCell.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/28.
//  Copyright © 2020 JEROME. All rights reserved.
//

import UIKit

class UserElementCell: UITableViewCell {
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var badgeView: UIView!
  @IBOutlet weak var siteAdminLabel: UILabel!
  
  @IBOutlet weak var badgeViewHeightLayout: NSLayoutConstraint!
  private let badgeViewDefaultHeight: CGFloat = 21
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func resetUI() {
    avatarImageView.image = nil
    nameLabel.text = ""
    siteAdminLabel.text = ""
    badgeViewHeightLayout.constant = 0
  }
  
  func updateUI(viewModel: UserElementViewModel) {
    nameLabel.text = viewModel.name
    if viewModel.siteAdmin {
      siteAdminLabel.text = "STAFF"
      badgeViewHeightLayout.constant = badgeViewDefaultHeight
    }
    viewModel.download { [weak self] data in
      if let image = UIImage(data: data) {
        self?.avatarImageView.image = image
      } else {
        print("Cannot download image.")
      }
    }
  }
}
