//
//  TemperatureScale.swift
//  Server Swift (iOS)
//
//  Created by Mettaworldj on 3/16/21.
//

import Foundation

enum TemperatureScale: String {
    case celsius = "$1/1000"
    case fahrenheit = "(($1/1000) * 1.8) + 32"
    case kelvin
}
