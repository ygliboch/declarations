//
//  UITableViewCellExtension.swift
//  Declarations
//
//  Created by Yaroslava Hlibochko on 24.12.2019.
//  Copyright © 2019 Yaroslava Hlibochko. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    var tableView: UITableView? {
        return self.next(of: UITableView.self)
    }

    var indexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
}
