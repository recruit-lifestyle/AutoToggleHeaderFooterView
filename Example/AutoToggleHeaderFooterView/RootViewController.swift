//
//  RootViewController.swift
//  AutoToggleHeaderFooterView
//
//  Created by Tomoya Hayakawa on 02/20/2017.
//  Copyright (c) 2017 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit
import AutoToggleHeaderFooterView

class RootViewController: UITableViewController {

    let titles: [String] = [
        TableViewController1.name,
        TableViewController2.name,
        TableViewController3.name,
        WebViewController.name,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return titles.count
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = titles[indexPath.row]

        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController: UIViewController

        switch titles[indexPath.row] {
        case TableViewController1.name:
            viewController = TableViewController1()

        case TableViewController2.name:
            viewController = TableViewController2()

        case TableViewController3.name:
            viewController = TableViewController3()

        case WebViewController.name:
            viewController = WebViewController()

        default:
            viewController = UIViewController()
        }

        navigationController?.pushViewController(viewController, animated: true)
    }
}
