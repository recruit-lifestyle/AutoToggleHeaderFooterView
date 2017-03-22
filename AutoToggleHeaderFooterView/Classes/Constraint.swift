//
//  Constraint.swift
//  Pods
//
//  Created by Tomoya Hayakawa on 2017/03/01.
//  Copyright (c) 2017 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit

struct Constraint {
    static func make(_ view1: Any, _ attr1: NSLayoutAttribute, _ relation: NSLayoutRelation, to view2: Any?, _ attr2: NSLayoutAttribute, multiplier: CGFloat = 1.0, constant c: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation,
                                            toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
        if let priority = priority {
            constraint.priority = priority
        }

        return constraint
    }

    static func make(_ view1: Any, edgesEqualTo view2: Any, multiplier: CGFloat = 1.0, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        let constraints = [
            NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .top, multiplier: multiplier, constant: 0),
            NSLayoutConstraint(item: view1, attribute: .left, relatedBy: .equal, toItem: view2, attribute: .left, multiplier: multiplier, constant: 0),
            NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: multiplier, constant: 0),
            NSLayoutConstraint(item: view1, attribute: .right, relatedBy: .equal, toItem: view2, attribute: .right, multiplier: multiplier, constant: 0)
        ]
        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }

        return constraints 
    }

    static func make(_ view: Any, width relation: NSLayoutRelation, to constant: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: relation, toItem: nil, attribute: .width, multiplier: 1.0, constant: constant)
        if let priority = priority {
            constraint.priority = priority
        }

        return constraint
    }

    static func make(_ view: Any, height relation: NSLayoutRelation, to constant: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: relation, toItem: nil, attribute: .height, multiplier: 1.0, constant: constant)
        if let priority = priority {
            constraint.priority = priority
        }

        return constraint
    }
}
