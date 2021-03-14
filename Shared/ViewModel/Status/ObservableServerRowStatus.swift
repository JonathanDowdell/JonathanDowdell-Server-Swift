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
    
    @Published var serverLoaded = false
    
    @Published var server: Server
    
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
            .execute(generateRunnable(server.loadOn)) { [weak self] (resultedCommand, data: String?, error) in
                guard error == nil else {
                    print("Error ==> \(String(describing: error))")
                    return
                }
                
                guard let dataArray = data?.components(separatedBy: "\n"),
                      let loadOn = self?.server.loadOn,
                      let dataDict = self?.aggregateDataToDict(dataArray, loadOn: loadOn)
                      else { return }
                
                withAnimation(.spring()) { self?.serverLoaded = true }
                
                DispatchQueue.main.async {
                    self?.aggregateDataForUse(dataDict, loadedOn: loadOn)
                }
            }
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
        \(TerminalCommand.cachedMemoryTotal(loadOn).value)
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
    
    private func dataToNumber(_ data: String) -> Double {
        guard let number = Double(data) else { return 0.0001 }
        return number
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
            }
        }
    }
    
    // TODO : Make Dynamic
    private func aggregateDataToDict(_ data: [String], loadOn: TerminalCommand.LoadOn) -> [TerminalCommand:String] {
        var dict = [TerminalCommand:String]()
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
        return dict
    }
}
