//
//  TableViewController3.swift
//  AutoToggleHeaderFooterView
//
//  Created by Tomoya Hayakawa on 2017/03/10.
//  Copyright (c) 2017 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit
import AutoToggleHeaderFooterView

final class TableViewController3: UIViewController, UITableViewDelegate {

    static let name = "TableView+Footer"

    private var loadDelay = TimeInterval(1.0)

    private let dataSource = TableViewDataSource()
    private let footer = SampleHeaderFooterView(height: 40)

    private var autoToggleView: AutoToggleHeaderFooterView!
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self.dataSource
        table.delegate = self
        table.separatorStyle = .none
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MainCell")
        table.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCell")
        return table
    }()

    deinit {
        print("deinit: " + TableViewController3.name)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = type(of: self).name
        view.backgroundColor = .white

        // Initialize with any header or footer
        autoToggleView = AutoToggleHeaderFooterView(header: nil, footer: footer)
        autoToggleView.addScrollView(tableView)

        // Add to any view
        view.addSubview(autoToggleView)

        // If scrollview under the translucent NavigationBar, use this.
        // And call `AutoToggleHeaderFooterView.register(scrollView:) at `viewDidLayoutSubviews`.
//        autoToggleView.makeEdgesEqualToSuperview()

        // Or not under the NavigationBar
        automaticallyAdjustsScrollViewInsets = false
        makeEdgesFitToLayoutGuide(view: autoToggleView)
    }

    private func loadMoreData(completion: (() -> Void)?) {
        DispatchQueue.global().asyncAfter(deadline: .now() + loadDelay) { [weak self] in
            self?.dataSource.appendNewData()
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    // MARK: - ScrollViewDelegate

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {

        /// Have to call `showHeaderFooter(withDuration:completion:)` before scroll to top
        autoToggleView.showHeaderFooter(withDuration: 0.3)
        return true
    }

    // MARK: - TableViewDelegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        guard let cell = cell as? LoadingCell else { return }
        cell.indicatorView.startAnimating()
        loadMoreData(completion: {
            cell.indicatorView.stopAnimating()
            tableView.reloadData()
        })
    }
}
