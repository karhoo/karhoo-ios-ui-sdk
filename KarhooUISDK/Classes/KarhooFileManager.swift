//
//  KarhooFileManager.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 13.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

final class KarhooFileManager {

    static func getFromFile<T: Decodable>(_ fileName: String) -> T? {
        guard let data = readLocalFile(forName: fileName)
        else {
            return nil
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        }
        catch {
            print(error)
        }
        
        return nil
    }
    
    static private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.current.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        }
        catch {
            print(error)
        }
        
        return nil
    }
}
