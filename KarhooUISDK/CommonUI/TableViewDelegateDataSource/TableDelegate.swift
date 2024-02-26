//
//  TableDelegate.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

class TableDelegate<T>: NSObject, UITableViewDelegate {

    typealias SelectionCallback = (T) -> Void
    typealias ReachedBottomCallback = (Bool) -> Void
    private let estimatedFooterHeight: CGFloat = 50

    private let tableData: TableData<T>

    private var selectionCallback: SelectionCallback?
    private var bottomCallback: ReachedBottomCallback?
    private var footerView: UIView?
    private var paginationEnabled: Bool

    init(tableData: TableData<T> = TableData<T>(),
         paginationEnabled: Bool = false) {
        self.paginationEnabled = paginationEnabled
        self.tableData = tableData
    }

    func setSection(key: String, to items: [T]) {
        tableData.setSection(key: key, to: items)
    }

    func set(selectionCallback: SelectionCallback?) {
        self.selectionCallback = selectionCallback
    }
    
    func set(reachedBottom: ReachedBottomCallback?) {
        self.bottomCallback = reachedBottom
    }

    func set(footerView: UIView) {
        self.footerView = footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = tableData.getItem(indexPath: indexPath) else {
            return
        }
        selectionCallback?(item)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        guard footerView != nil else {
            return 0
        }
        return estimatedFooterHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if paginationEnabled {
            if tableView.numberOfRows(inSection: 0) - indexPath.row == 1 {
                bottomCallback?(true)
            }
        }
    }
}
