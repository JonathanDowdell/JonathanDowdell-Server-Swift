//
//  ObservableServers.swift
//  Server Swift (iOS)
//
//  Created by Mettaworldj on 3/5/21.
//

import Foundation
import SwiftKeychainWrapper
import Combine

class ObservableServers: ObservableObject {
    
    @Published var servers = [Server]()
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let defaults = UserDefaults.standard
    var editingServer: Server?
    
    init() {
        let keys = KeychainWrapper.standard.allKeys()
        defaults.set(TemperatureScale.celsius.rawValue, forKey: "TemperatureScale")
        keys.forEach { (key) in
            if let rawServerData = KeychainWrapper.standard.data(forKey: key) {
                if let serverData = try? decoder.decode(Server.self, from: rawServerData) {
                    servers.append(serverData)
                }
            }
        }
    }
    
    func save(server: Server) -> Bool {
        let key = server.id
        if let rawServerData = try? encoder.encode(server) {
            servers.append(server)
            return KeychainWrapper.standard.set(rawServerData, forKey: key)
        }
        return false
    }
    
    func update(server: Server) -> Bool {
        guard let index = searchId(server.id) else { return false }
        servers[index].copy(from: server)
        let key = server.id
        if let rawServerData = try? encoder.encode(server) {
            return KeychainWrapper.standard.set(rawServerData, forKey: key)
        }
        return false
    }
    
    func remove(with index: Int) {
        let server = servers[index]
        let key = server.id
        KeychainWrapper.standard.remove(forKey: KeychainWrapper.Key(rawValue: key))
        servers.remove(at: index)
    }
    
    func remove(server: Server) {
        guard let index = searchId(server.id) else { return }
        let key = servers[index].id
        KeychainWrapper.standard.remove(forKey: KeychainWrapper.Key(rawValue: key))
        servers.remove(at: index)
    }
    
    func searchId(_ id: String) -> Int? {
        var targetIndex: Int?
        for (index, item) in servers.enumerated() {
            if item.id == id {
                targetIndex = index
                break
            }
        }
        return targetIndex
    }
}
