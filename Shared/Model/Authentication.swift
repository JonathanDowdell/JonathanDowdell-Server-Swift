//
//  Authentication.swift
//  Server Swift (iOS)
//
//  Created by Mettaworldj on 3/5/21.
//

import Foundation

struct Authentication: Codable, Hashable {
    var user: String
    var password: String
    var rsa: String?
}
