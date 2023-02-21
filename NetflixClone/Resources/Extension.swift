//
//  Extension.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-20.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
