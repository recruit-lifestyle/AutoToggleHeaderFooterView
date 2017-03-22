//
//  UIView+Constraint.swift
//  AutoToggleHeaderFooterView
//
//  Created by Tomoya Hayakawa on 2017/02/27.
//  Copyright (c) 2017 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit

extension UIViewController {
    func makeEdgesFitToLayoutGuide(view _view: UIView) {
        _view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: _view, attribute: .top, relatedBy: .equal,
                               toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: _view, attribute: .left, relatedBy: .equal,
                               toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: _view, attribute: .bottom, relatedBy: .equal,
                               toItem: bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: _view, attribute: .right, relatedBy: .equal,
                               toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
        ])
    }
}

extension UIView {
    func makeEdgesEqualToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                               toItem: superview, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal,
                               toItem: superview, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                               toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal,
                               toItem: superview, attribute: .right, multiplier: 1.0, constant: 0),
        ])
    }

    func makeCenterEqualToSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal,
                               toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal,
                               toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0),
        ])
    }
}
