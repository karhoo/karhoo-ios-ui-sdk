//
//  TableDataSource.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

final class TableDataSource<T>: NSObject, UITableViewDataSource {

    typealias CellConfigurationCallback = (T, UITableViewCell, IndexPath) -> Void

    private let reuseIdentifier: String

    private let tableData: TableData<T>

    private var cellConfigurationClosure: CellConfigurationCallback?

    init(reuseIdentifier: String, tableData: TableData<T> = TableData<T>()) {
        self.reuseIdentifier = reuseIdentifier
        self.tableData = tableData
    }

    func setSection(key: String, to items: [T]) {
        tableData.setSection(key: key, to: items)
    }

    func set(cellConfigurationCallback: CellConfigurationCallback?) {
        cellConfigurationClosure = cellConfigurationCallback
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.getSectionKeys().count
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let items = tableData.getItems(section: section)
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.isUserInteractionEnabled = false

        if let item = tableData.getItem(indexPath: indexPath) {
            cellConfigurationClosure?(item, cell, indexPath)
        }

        return cell
    }
}
