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
    
    @Published var cpuTemp: Int?
    
    @Published var userUage: CGFloat?
    
    @Published var cpuUsage: CGFloat?
    
    @Published var systemUsage: CGFloat?
    
    @Published var userNiceUsage: CGFloat?
    
    @Published var ioWaitUsage: CGFloat?
    
    @Published var coreCount: Int16?
    
    @Published var memoryTotal: CGFloat?
    
    @Published var freeMemoryTotal: CGFloat?
    
    @Published var usedMemoryTotal: CGFloat?
    
    @Published var cachedMemoryTotal: CGFloat?
    
    @Published var osName: String?
    
    @Published var osVersion: String?
    
    @Published var serverLoaded = false
    
    @Published var server: Server
    
    @Published var serverStatistic: ServerStatistic?
    
    private let defaults = UserDefaults.standard
    
    private var authenticationChallenge: AuthenticationChallenge?
    
    private var command: Command?
    
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
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
    
    @objc func updateData() {
        guard let command = command else { return }
        
        command.connect()
            .authenticate(self.authenticationChallenge)
            .execute(terminalCommands()) { [weak self] (resultedCommand, data: String?, error) in
                guard error == nil else {
                    print("Error ==> \(String(describing: error))")
                    return
                }
                
                print(data ?? "")
                guard let data = data else { return }
                
                self?.aggregateData(data)
                
                
//                guard let dataArray = data?.components(separatedBy: "\n"),
//                      let loadOn = self?.server.loadOn,
//                      let dataDict = self?.aggregateDataToDict(dataArray, loadOn: loadOn)
//                else { return }
//
//                withAnimation(.spring()) { self?.serverLoaded = true }
//
//                DispatchQueue.main.async {
//                    self?.aggregateDataForUse(dataDict, loadedOn: loadOn)
//                }
            }
    }
    
    private func aggregateData(_ data: String) {
        let serverStatistics = ServerStatistic(data: data)
        print(serverStatistics)
    }
    
    private func generateRunnable(_ loadOn: TerminalCommand.LoadOn) -> String {
        return  """
        \(TerminalCommand.cpuTemp(loadOn).value) &&
        \(TerminalCommand.coreCount(loadOn).value) &&
        \(TerminalCommand.cpuUsage(loadOn).value) &&
        \(TerminalCommand.userUsage(loadOn).value) &&
        \(TerminalCommand.systemUsage(loadOn).value) &&
        \(TerminalCommand.userNiceUsage(loadOn).value) &&
        \(TerminalCommand.ioWaitUsage(loadOn).value) &&
        \(TerminalCommand.memoryTotal(loadOn).value) &&
        \(TerminalCommand.freeMemoryTotal(loadOn).value) &&
        \(TerminalCommand.usedMemoryTotal(loadOn).value) &&
        \(TerminalCommand.cachedMemoryTotal(loadOn).value) &&
        \(TerminalCommand.osName(loadOn).value) &&
        \(TerminalCommand.osVersion(loadOn).value)
        """
    }
    
    private func filterData(_ data: String, by filter: String) -> CGFloat {
        guard let filterIndex = data.range(of: filter)?.lowerBound else { return 0.0001 }
        let rawData = data[..<filterIndex].suffix(6).trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .letters)
        guard let data = Double(rawData) else { return 0.0001 }
        return CGFloat(data)
    }
    
    private func filterData(_ data: String, from start: String, to end: String) -> CGFloat {
        guard let startIndex = data.range(of: start) else { return 0.0001 }
        guard let endIndex = data.range(of: end) else { return 0.0001 }
        let rawData = data[startIndex.upperBound..<endIndex.lowerBound].trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .letters)
        guard let data = Double(rawData) else { return 0.0001 }
        return CGFloat(data)
    }
    
    private func filterData(_ data: String, from start: String, to end: String) -> String {
        guard let startIndex = data.range(of: start) else { return "" }
        guard let endIndex = data.range(of: end) else { return "" }
        let rawData = data[startIndex.upperBound..<endIndex.lowerBound].trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .letters)
        return rawData
    }
    
    private func dataToNumber(_ data: String) -> Double {
        guard let number = Double(data) else { return 0.0001 }
        return number
    }
    
    private func terminalCommands() -> String {
        // CPU Temperature Command // data[0]
        guard let temperatureScaleRawValue = defaults.string(forKey: "TemperatureScale"),
              let temperatureScale = TemperatureScale(rawValue: temperatureScaleRawValue) else { return "" }
        let cpuTempCommand = "cat /sys/class/thermal/thermal_zone*/temp | awk '{print \(temperatureScale.rawValue)}'"
        
        // CPU & Memory Usage // data[1...4]
        let cpuMemory = "top -b -n2 -d 3 | head -n 4"
        
        // CPU Core Count // data[5]
        let cpuCoreCountCommand = "nproc"
        
        // OS Infomation // data[6]
        let osInfoCommand = "egrep '^(NAME)=|^(VERSION)=' /etc/os-release"
        
        
        
//        let cpuTempCommand = "cat /sys/class/thermal/thermal_zone*/temp | awk '{print \(temperatureScale.rawValue)}'"
//
//        // CPU Usage Command // data[1-2]
//        let cpuUsageCommand = "cat /proc/stat | awk '/^cpu /{print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11}'"
//
//        // CPU Load Command // data[3]
//        let cpuLoadCommand = "cat /proc/loadavg | awk '{print $1, $2, $3}'"
//
//        // CPU Core Count // data[4]
//        let cpuCoreCountCommand = "nproc"
//
//        // Memory Usage Command // data[5-6]
//        let memoryUsageCommand = "free -m | grep -E 'Mem:|Swap:'"
//
//        // Uptime Command
//        let uptimeCommand = "uptime | awk '{print $3, $4}' | sed 's/,//g'"
        
        
        
        return """
            \(cpuTempCommand) &&
            \(cpuMemory) &&
            \(cpuCoreCountCommand) &&
            \(osInfoCommand)
            """
    }
    
    private func aggregateDataForUse(_ dataDict:[TerminalCommand:String], loadedOn: TerminalCommand.LoadOn) {
        dataDict.keys.forEach { (key) in
            guard let rawData = dataDict[key] else { return }
            
            switch key {
            case .cpuTemp(_):
                
                switch loadedOn {
                case .server, .device:
                    let tempValue = Int(rawData.prefix(2))
                    withAnimation { self.cpuTemp = tempValue }
                }
                
            case .coreCount(_):
                
                if self.coreCount == nil {
                    switch loadedOn {
                    case .server, .device:
                        self.coreCount = Int16(rawData)
                    }
                }
                
            case .cpuUsage(_):
                
                switch loadedOn {
                case .server:
                    let cpuUsage = CGFloat(self.dataToNumber(rawData))
                    self.cpuUsage = cpuUsage
                case .device:
                    let cpuUsage = (100 - self.filterData(rawData, by: "id")) / 100
                    self.cpuUsage = cpuUsage
                }
                
            case .userUsage(_):
                
                switch loadedOn {
                case .server:
                    self.userUage = CGFloat(self.dataToNumber(rawData))
                case .device:
                    self.userUage = self.filterData(rawData, by: "ua")
                }
                
            case .systemUsage(_):
                
                switch loadedOn {
                case .server:
                    self.systemUsage = CGFloat(self.dataToNumber(rawData))
                case .device:
                    self.systemUsage = self.filterData(rawData, by: "sy")
                }
                
            case .userNiceUsage(_):
                
                switch loadedOn {
                case .server:
                    self.userNiceUsage = CGFloat(self.dataToNumber(rawData))
                case .device:
                    self.userNiceUsage = self.filterData(rawData, by: "ni")
                }
                
            case .ioWaitUsage(_):
                
                switch loadedOn {
                case .server:
                    self.ioWaitUsage = CGFloat(self.dataToNumber(rawData))
                case .device:
                    self.ioWaitUsage = self.filterData(rawData, by: "ni")
                }
                
            case .memoryTotal(_):
                
                if self.memoryTotal == nil {
                    switch loadedOn {
                    case .server:
                        self.memoryTotal = CGFloat(self.dataToNumber(rawData))
                    case .device:
                        self.memoryTotal = self.filterData(rawData, from: ":", to: "total")
                    }
                }
                
            case .freeMemoryTotal(_):
                
                switch loadedOn {
                case .server:
                    self.freeMemoryTotal = CGFloat(self.dataToNumber(rawData))
                case .device:
                    self.freeMemoryTotal = self.filterData(rawData, from: "l,", to: "free")
                }
                
            case .usedMemoryTotal(_):
                
                switch loadedOn {
                case .server:
                    self.usedMemoryTotal = CGFloat(self.dataToNumber(rawData))
                case .device:
                    self.usedMemoryTotal = self.filterData(rawData, from: "e,", to: "used")
                }
                
            case .cachedMemoryTotal(_):
                switch loadedOn {
                case .server:
                    self.cachedMemoryTotal = CGFloat(self.dataToNumber(rawData))
                case .device:
                    self.cachedMemoryTotal = self.filterData(rawData, from: "ed,", to: "buff/cache")
                }
            case .osName(_):
                switch loadedOn {
                case .server:
                    self.osName = String(rawData)
                case .device:
                    guard let startIndex = rawData.range(of: "NAME=")?.upperBound else { return }
                    let rawData = rawData[startIndex...]
                    self.osName = String(rawData)
                }
            case .osVersion(_):
                switch loadedOn {
                case .server:
                    self.osVersion = String(rawData)
                case .device:
                    guard let startIndex = rawData.range(of: "VERSION=")?.upperBound else { return }
                    let rawData = rawData[startIndex...]
                    self.osVersion = String(rawData)
                }
            }
        }
    }
    
    // TODO : Make Dynamic
    private func aggregateDataToDict(_ data: [String], loadOn: TerminalCommand.LoadOn) -> [TerminalCommand:String] {
        var dict = [TerminalCommand:String]()
        if data.count >= 11 {
            dict[.cpuTemp(loadOn)] = data[0]
            dict[.coreCount(loadOn)] = data[1]
            dict[.cpuUsage(loadOn)] = data[2]
            dict[.userUsage(loadOn)] = data[3]
            dict[.systemUsage(loadOn)] = data[4]
            dict[.userNiceUsage(loadOn)] = data[5]
            dict[.ioWaitUsage(loadOn)] = data[6]
            dict[.memoryTotal(loadOn)] = data[7]
            dict[.freeMemoryTotal(loadOn)] = data[8]
            dict[.usedMemoryTotal(loadOn)] = data[9]
            dict[.cachedMemoryTotal(loadOn)] = data[10]
            dict[.osName(loadOn)] = data[11]
            dict[.osVersion(loadOn)] = data[12]
        }
        
        return dict
    }
}
