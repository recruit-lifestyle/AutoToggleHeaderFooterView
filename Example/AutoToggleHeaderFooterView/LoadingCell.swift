//
//  LoadingCell.swift
//  AutoToggleHeaderFooterView
//
//  Created by Tomoya Hayakawa on 2017/02/28.
//  Copyright (c) 2017 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit

final class LoadingCell: UITableViewCell {

    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.addSubview(indicatorView)
        indicatorView.makeCenterEqualToSuperview()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
