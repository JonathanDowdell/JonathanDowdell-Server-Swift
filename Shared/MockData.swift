//
//  MockData.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/5/21.
//

import Foundation

class MockData {
    static var servers = [
        Server(name: "Raspberry Pi", host: "192.168.1.2", port: "22", showing: true, loadOn: TerminalCommand.LoadOn.device, authentication: Authentication(user: "user", password: "", rsa: nil)),
        Server(name: "Raspberry Pi", host: "192.168.1.3", port: "22", showing: true, loadOn: TerminalCommand.LoadOn.server, authentication: Authentication(user: "user", password: "", rsa: nil)),
        Server(name: "", host: "", port: "22", showing: true, loadOn: TerminalCommand.LoadOn.server, authentication: Authentication(user: "", password: "", rsa: nil))
    ]
}
