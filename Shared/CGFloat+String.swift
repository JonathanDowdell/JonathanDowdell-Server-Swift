//
//  CGFloat+String.swift
//  Server Swift (iOS)
//
//  Created by Mettaworldj on 3/16/21.
//

import Foundation
import SwiftUI

extension CGFloat {
    init?(_ value: String) {
        guard let value = Double(value) else { return nil }
        self.init(value)
    }
}
