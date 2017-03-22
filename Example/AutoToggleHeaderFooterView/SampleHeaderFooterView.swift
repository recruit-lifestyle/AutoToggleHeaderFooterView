//
//  SampleHeaderFooterView.swift
//  AutoToggleHeaderFooterView
//
//  Created by Tomoya Hayakawa on 2017/02/28.
//  Copyright (c) 2017 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit

final class SampleHeaderFooterView: UIView {

    init(height: CGFloat) {
        super.init(frame: .zero)
        frame.size.height = height
        backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.7982047872)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
