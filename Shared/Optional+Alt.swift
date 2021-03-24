//
//  Optional+Alt.swift
//  Server Swift (iOS)
//
//  Created by Mettaworldj on 3/23/21.
//

import SwiftUI

extension Optional {
    func alt<T>(_ lhs: Binding<T>?, rhs: T) -> Binding<T> {
        Binding(
            get: { lhs?.wrappedValue ?? rhs },
            set: { lhs?.wrappedValue = $0 }
        )
    }
}
