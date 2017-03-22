//
//  WebViewController.swift
//  AutoToggleHeaderFooterView
//
//  Created by Tomoya Hayakawa on 2017/02/21.
//  Copyright (c) 2017 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit
import WebKit
import AutoToggleHeaderFooterView

final class WebViewController: UIViewController {

    static let name = "WebView+UIViewController"

    let webView = WKWebView(frame: .zero)
    private let header = SampleHeaderFooterView(height: 80)
    private let footer = SampleHeaderFooterView(height: 40)

    fileprivate lazy var autoToggleView: AutoToggleHeaderFooterView = {
        let assistant = AutoToggleHeaderFooterView(header: self.header, footer: self.footer)
        assistant.addSubview(self.webView)
        assistant.register(scrollView: self.webView.scrollView)
        return assistant
    }()

    deinit {
        print("deinit: " + WebViewController.name)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = type(of: self).name
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false

        webView.scrollView.delegate = self

        view.addSubview(autoToggleView)
        makeEdgesFitToLayoutGuide(view: autoToggleView)

        webView.makeEdgesEqualToSuperview()
        webView.load(URLRequest(url: URL(string: "https://www.recruit-lifestyle.co.jp/")!))
    }
}

extension WebViewController: UIScrollViewDelegate {
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {

        /// Have to call `showHeaderFooter(withDuration:completion:)` before scroll to top
        autoToggleView.showHeaderFooter(withDuration: 0.3)
        return false
    }
}
