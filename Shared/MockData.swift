//
//  MockData.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/5/21.
//

import Foundation

class MockData {
    static var servers = [
        Server(name: "Raspberry Pi", host: "192.168.1.2", port: "22", showing: true, authentication: Authentication(user: "user", password: "", rsa: nil), createdDate: Date()),
        Server(name: "Raspberry Pi", host: "192.168.1.3", port: "22", showing: true, authentication: Authentication(user: "user", password: "", rsa: nil), createdDate: Date()),
        Server(id: "", name: "", host: "", port: "22", showing: true, authentication: Authentication(user: "", password: "", rsa: nil), createdDate: Date())
    ]
}
