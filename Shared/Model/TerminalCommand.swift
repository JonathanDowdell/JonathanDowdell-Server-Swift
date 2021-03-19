//
//  TerminalCommand.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/7/21.
//

import Foundation

enum TerminalCommand: Hashable {
    
    case cpuTemp(LoadOn)
    case coreCount(LoadOn)
    case cpuUsage(LoadOn)
    case userUsage(LoadOn)
    case systemUsage(LoadOn)
    case userNiceUsage(LoadOn)
    case ioWaitUsage(LoadOn)
    case memoryTotal(LoadOn)
    case freeMemoryTotal(LoadOn)
    case usedMemoryTotal(LoadOn)
    case cachedMemoryTotal(LoadOn)
    case osName(LoadOn)
    case osVersion(LoadOn)
    
    var value: String {
        switch self {
        case .cpuTemp(let loadedOn):
            switch loadedOn {
            case .device, .server:
                return "cat /sys/class/thermal/thermal_zone*/temp"
            }
            
        case .cpuUsage(let loadedOn):
            switch loadedOn {
            case .device:
                return "top -bn1 | grep 'Cpu(s)'"
            case .server:
                return "top -n 1 -b | awk '/^%Cpu/{print (100 - ($8+0)) / 100}'"
            }
            
        case .userUsage(let loadedOn):
            switch loadedOn {
            case .device:
                return "top -bn1 | grep 'Cpu(s)'"
            case .server:
                return "top -n 1 -b | awk '/^%Cpu/{print ($2+0.0)}'"
            }
            
        case .systemUsage(let loadedOn):
            switch loadedOn {
            case .device:
                return "top -bn1 | grep 'Cpu(s)'"
            case .server:
                return "top -n 1 -b | awk '/^%Cpu/{print ($4)}'"
            }
            
        case .userNiceUsage(let loadOn):
            switch loadOn {
            case .device:
                return "top -bn1 | grep 'Cpu(s)'"
            case .server:
                return "top -n 1 -b | awk '/^%Cpu/{print ($6)}'"
            }
            
            
        case .ioWaitUsage(let loadOn):
            switch loadOn {
            case .device:
                return "top -bn1 | grep 'Cpu(s)'"
            case .server:
                return "top -n 1 -b | awk '/^%Cpu/{print ($10)}'"
            }
            
        case .memoryTotal(let loadOn):
            switch loadOn {
            case .device:
                return "top -bn1 | grep 'MiB Mem'"
            case .server:
                return "top -n 1 -b | awk '/^MiB M/{print ($4)}'"
            }
            
            
        case .freeMemoryTotal(let loadOn):
            switch loadOn {
            case .device:
                return "top -bn1 | grep 'MiB Mem'"
            case .server:
                return "top -n 1 -b | awk '/^MiB M/{print ($6)}'"
            }
            
        case .coreCount(let loadOn):
            switch loadOn {
            case .device, .server:
                return "nproc"
            }
            
        case .usedMemoryTotal(let loadOn):
            switch loadOn {
            case .server:
                return "top -n 1 -b | awk '/^MiB M/{print ($8)}'"
            case .device:
                return "top -bn1 | grep 'MiB Mem'"
            }
            
        case .cachedMemoryTotal(let loadOn):
            switch loadOn {
            case .server:
                return "top -n 1 -b | awk '/^MiB M/{print ($10)}'"
            case .device:
                return "top -bn1 | grep 'MiB Mem'"
            }
        case .osName(let loadOn):
            switch loadOn {
            case .device:
                return "egrep '^(NAME)=' /etc/os-release | xargs" // Device
            case .server:
                return "egrep '^(NAME)=' /etc/os-release | xargs | awk '{print substr($0, 6, 40);}'" // Server
            }
        case .osVersion(let loadOn):
            switch loadOn {
            case .device:
                return "egrep '^(VERSION)=' /etc/os-release | xargs" // Device
            case .server:
                return "egrep '^(VERSION)=' /etc/os-release | xargs | awk '{print substr($0, 9, 40);}'" // Server
            }
        }
        // egrep '^(VERSION)=' /etc/os-release | grep -oP '^(VERSION)="\K[^"]+'
        
    }
    
    enum LoadOn: String, Codable {
        case server, device
    }
    
    static func stringToEnum(_ string: String, _ loadOn: LoadOn) -> TerminalCommand {
        switch string {
        case "cpuTemp":
            return .cpuTemp(loadOn)
        case "coreCount":
            return .coreCount(loadOn)
        case "cpuUsage":
            return .cpuUsage(loadOn)
        case "userUsage":
            return .userUsage(loadOn)
        case "systemUsage":
            return .systemUsage(loadOn)
        case "userNiceUsage":
            return .userNiceUsage(loadOn)
        case "ioWaitUsage":
            return .ioWaitUsage(loadOn)
        case "memoryTotal":
            return .memoryTotal(loadOn)
        case "freeMemoryTotal":
            return .freeMemoryTotal(loadOn)
        case "usedMemoryTotal":
            return .usedMemoryTotal(loadOn)
        case "cachedMemoryTotal":
            return .cachedMemoryTotal(loadOn)
        case "osName":
            return .osName(loadOn)
        case "osVersion":
            return .osVersion(loadOn)
        default:
            return .coreCount(loadOn)
        }
    }
}

