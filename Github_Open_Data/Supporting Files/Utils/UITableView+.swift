//
//  UITableView+.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/29.
//  Copyright © 2020 JEROME. All rights reserved.
//

import UIKit

extension UITableView {
  func showFooterIndicator(style: UIActivityIndicatorView.Style = .gray, color: UIColor? = nil, scale: CGFloat = 1, paddingY: CGFloat = 0) {
    let spinner = UIActivityIndicatorView(style: .gray)
    if let color = color {
      spinner.color = color
    }
    spinner.scale(scale)
    spinner.startAnimating()
    spinner.frame = CGRect(x: 0, y: paddingY, width: bounds.width, height: spinner.newHeight + paddingY * 2)
    print("spinner.newHeight:\(spinner.newHeight), spinner.newWidth:\(spinner.newWidth)")
    
    tableFooterView = spinner
    tableFooterView?.isHidden = false
  }
}
