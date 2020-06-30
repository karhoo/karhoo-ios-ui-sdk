//
//  TableData.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

final class TableData<T> {

    private var sectionKeys: [String] = []
    private var sectionItems: [String: [T]] = [:]

    func setSection(key: String, to items: [T]) {
        if !sectionKeys.contains(key) {
            sectionKeys.append(key)
        }
        sectionItems[key] = items
    }

    func getSectionKeys() -> [String] {
        return sectionKeys
    }

    func getItems(section: Int) -> [T] {
        guard section >= 0 && section < sectionKeys.count else {
            return []
        }

        let key = sectionKeys[section]

        guard let items = sectionItems[key] else {
            return []
        }
        return items
    }

    func getItem(indexPath: IndexPath) -> T? {
        let items = getItems(section: indexPath.section)

        guard indexPath.row >= 0 && indexPath.row < items.count else {
            return nil
        }

        return items[indexPath.row]
    }

    func clearData() {
        sectionKeys = []
        sectionItems = [:]
    }
}
