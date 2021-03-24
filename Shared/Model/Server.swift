//
//  Server.swift
//  Server Swift (iOS)
//
//  Created by Mettaworldj on 3/5/21.
//

import Foundation

struct Server: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var host: String
    var port: String
    var showing: Bool
    var authentication: Authentication
    var createdDate: Date
    
    mutating func copy(from server: Server) {
        self.id = server.id
        self.name = server.name
        self.host = server.host
        self.port = server.port
        self.showing = server.showing
        self.authentication = server.authentication
        self.createdDate = server.createdDate
    }
}
