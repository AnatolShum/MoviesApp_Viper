//
//  ExtensionString.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 12.03.2024.
//

import Foundation

extension String {
    func toData() -> Data {
        return Data(self.utf8)
    }
}
