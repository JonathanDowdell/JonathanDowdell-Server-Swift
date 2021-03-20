//
//  StatusServerRowViewModel.swift
//  Server Swift (iOS)
//
//  Created by Mettaworldj on 3/5/21.
//

import Foundation
import Combine
import SwiftSH
import SwiftUI

class ObservableServerRowStatus: ObservableObject {
    
    @Published var serverLoaded = false
    
    @Published var server: Server
    
    @Published var serverStatistic = ServerStatistic()
    
    private let defaults = UserDefaults.standard
    
    private var authenticationChallenge: AuthenticationChallenge?
    
    private var command: Command?
    
    private let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    
    private var timerSubscription: Cancellable?
    
    init(with server: Server) {
        self.server = server
        connect()
    }
    
    deinit {
        print("DESTROYED==========>")
    }
    
    func startTimer() {
        timerSubscription = timer.sink(receiveValue: { (_) in
            self.updateData()
        })
    }
    
    func stopTimer() {
        timerSubscription = nil
    }
    
    func connect() {
        let username = server.authentication.user
        let password = server.authentication.password
        let host = server.host
        guard let port = UInt16(server.port) else { return }
        
        self.authenticationChallenge = .byPassword(username: username, password: password)
        self.command = Command(host: host, port: port)
    }
    
    func updateData() {
        guard let command = command else { return }
        
        DispatchQueue.global(qos: .background).async {
            command.connect()
                .authenticate(self.authenticationChallenge)
                .execute(self.terminalCommands()) { [weak self] (resultedCommand, data: String?, error) in
                    if let error = error {
                        print(error)
                    }
                    
                    guard let data = data else { return }
                    
                    DispatchQueue.main.async {
                        self?.aggregateData(data)
                    }
                }
        }
        
        
    }
    
    private func aggregateData(_ data: String) {
        guard let stats = ServerStatistic(data: data) else { return }
        withAnimation {
            self.serverStatistic = stats
            self.serverLoaded = true
        }
    }
    
    private func terminalCommands() -> String {
        // CPU Temperature Command
        guard let temperatureScaleRawValue = defaults.string(forKey: "TemperatureScale"),
              let temperatureScale = TemperatureScale(rawValue: temperatureScaleRawValue) else { return "" }
        let cpuTempCommand = "cat /sys/class/thermal/thermal_zone*/temp | awk '{print \(temperatureScale.rawValue)}' | sed 's/$/ Temp/'"
        
        // CPU & Memory Usage
        let cpuMemory = "top -b -n2 -d 3 | head -n 4"
        
        // CPU Core Count
        let cpuCoreCountCommand = "nproc | sed 's/$/ Core/'"
        
        // OS Infomation
        let osInfoCommand = "egrep '^(NAME)=|^(VERSION)=' /etc/os-release"
        
        
        return """
            \(cpuTempCommand) &&
            \(cpuMemory) &&
            \(cpuCoreCountCommand) &&
            \(osInfoCommand)
            """
    }
    
}
