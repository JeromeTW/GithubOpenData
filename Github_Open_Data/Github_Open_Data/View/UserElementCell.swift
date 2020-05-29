//
//  UserElementCell.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/28.
//  Copyright © 2020 JEROME. All rights reserved.
//

import UIKit

class UserElementCell: UITableViewCell {
  @IBOutlet weak var customContentView: UIView!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var loginLabel: UILabel!
  @IBOutlet weak var badgeView: UIView!
  @IBOutlet weak var siteAdminLabel: UILabel!
  
  @IBOutlet weak var badgeViewHeightLayout: NSLayoutConstraint!
  private let badgeViewDefaultHeight: CGFloat = 21
  private var viewModel: UserElementViewModel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func resetUI() {
    avatarImageView.image = nil
    loginLabel.text = ""
    siteAdminLabel.text = ""
    badgeViewHeightLayout.constant = 0
    
    contentView.backgroundColor = .clear
    
    customContentView.layer.borderWidth = 1
    customContentView.layer.borderColor = UIColor.lightGray.cgColor
    
    customContentView.layer.shadowColor = UIColor.lightGray.cgColor
    customContentView.layer.shadowOpacity = 0.8
    customContentView.layer.shadowOffset = CGSize(width: 0, height: 1)
  }
  
  func updateUI(viewModel: UserElementViewModel) {
    loginLabel.text = viewModel.login
    self.viewModel = viewModel
    if viewModel.siteAdmin {
      siteAdminLabel.text = "STAFF"
      badgeViewHeightLayout.constant = badgeViewDefaultHeight
    }

    viewModel.asyncShowImage { [weak self] image,downloadingVM in
      guard let strongSelf = self else { return }
      guard strongSelf.viewModel === downloadingVM else {
        return
      }
      strongSelf.avatarImageView.layer.cornerRadius = strongSelf.avatarImageView.frame.width * 0.5
      strongSelf.avatarImageView.image = image
    }
  }
}
