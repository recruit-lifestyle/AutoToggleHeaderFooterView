//
//  TableViewDataSource.swift
//  AutoToggleHeaderFooterView
//
//  Created by Tomoya Hayakawa on 2017/02/28.
//  Copyright (c) 2017 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit

final class TableViewDataSource: NSObject, UITableViewDataSource {

    var dataLimit = 50
    var colors = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
    var data = [String]()

    private var initialData: [String] {
        return (1 ... 30).map { String($0) }
    }

    override init() {
        super.init()
        data = initialData
    }

    func resetData() {
        data = initialData
    }

    func appendNewData() {
        data += ((data.count + 1) ... (data.count + 10)).map { String($0) }
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return data.count
        case 1:
            return data.count < dataLimit ? 1 : 0
        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
            cell.textLabel?.text = data[indexPath.row]
            cell.backgroundColor = colors[indexPath.row % colors.count]
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
            return cell
        default:
            fatalError()
        }
    }
}
