//
//  UIView+.swift
//  Github_Open_Data
//
//  Created by JEROME on 2020/5/29.
//  Copyright © 2020 JEROME. All rights reserved.
//

import UIKit

extension UIView {
  public func scale(_ scale: CGFloat) {
    transform = CGAffineTransform(scaleX: scale, y: scale)
  }
  
  /// Helper to get pre transform frame
  public var originalFrame: CGRect {
    let currentTransform = transform
    transform = .identity
    let originalFrame = frame
    transform = currentTransform
    return originalFrame
  }
  
  /// Helper to get point offset from center
  public func centerOffset(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x - center.x, y: point.y - center.y)
  }
  
  /// Helper to get point back relative to center
  public func pointRelativeToCenter(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x + center.x, y: point.y + center.y)
  }
  
  /// Helper to get point relative to transformed coords
  public func newPointInView(_ point: CGPoint) -> CGPoint {
    // get offset from center
    let offset = centerOffset(point)
    // get transformed point
    let transformedPoint = offset.applying(transform)
    // make relative to center
    return pointRelativeToCenter(transformedPoint)
  }
  
  public var newTopLeft: CGPoint {
    return newPointInView(originalFrame.origin)
  }
  
  public var newTopRight: CGPoint {
    var point = originalFrame.origin
    point.x += originalFrame.width
    return newPointInView(point)
  }
  
  public var newBottomLeft: CGPoint {
    var point = originalFrame.origin
    point.y += originalFrame.height
    return newPointInView(point)
  }
  
  public var newBottomRight: CGPoint {
    var point = originalFrame.origin
    point.x += originalFrame.width
    point.y += originalFrame.height
    return newPointInView(point)
  }
  
  public var newWidth: CGFloat {
    return newTopRight.x - newTopLeft.x
  }
  
  public var newHeight: CGFloat {
    return newBottomLeft.y - newTopLeft.y
  }
}
