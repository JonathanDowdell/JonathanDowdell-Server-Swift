//
//  Server.swift
//  Server Swift (iOS)
//
//  Created by Mettaworldj on 3/5/21.
//

import Foundation

struct Server: Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var host: String
    var port: String
    var showing: Bool
    var authentication: Authentication
    var createdDate: Date
    
    
    func copy() -> Server {
        return self
    }
}
