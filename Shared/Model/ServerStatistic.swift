//
//  ServerStatistic.swift
//  Server Swift (iOS)
//
//  Created by Mettaworldj on 3/16/21.
//

import Foundation
import SwiftUI

struct ServerStatistic {
    var uptime: Int?
    var cpuTemp: CGFloat?
    var cpuUsage: CGFloat?
    var userUsage: CGFloat?
    var systemUsage: CGFloat?
    var userNiceUsage: CGFloat?
    var idleUsage: CGFloat?
    var ioWaitUsage: CGFloat?
    var stealUsage: CGFloat?
    var cpuLoad: [Double] = [Double]()
    var coreCount: Int16?
    var memoryTotal: CGFloat?
    var freeMemoryTotal: CGFloat?
    var usedMemoryTotal: CGFloat?
    var cachedMemoryTotal: CGFloat?
    var osName: String?
    var osVersion: String?
    var loads: [Double?] = [Double?]()
    
}

extension ServerStatistic {
    init?(data: String) {
        let dataComponents = data.components(separatedBy: "\n")
        let cpuUsageComponents = dataComponents[3].components(separatedBy: " ")
        let cpuLoadComponents = dataComponents[1].components(separatedBy: " ")
        let memoryComponents = dataComponents[4].components(separatedBy: " ")
        let osInfoComponents = dataComponents[6...7]
        
        
        // Uptime // [1]
        self.uptime = Int(cpuLoadComponents[4])
        
        // CPU Temp // [0]
        self.cpuTemp = CGFloat(dataComponents[0].trimmingCharacters(in: .whitespacesAndNewlines))
        
        // CPU Loads
        self.loads = (search(for: "average", in: cpuLoadComponents) as [String])
            .map({$0.doubleValue})
        
        // User Usage // [3]
        self.userUsage = CGFloat(search(for: "us", in: cpuUsageComponents))
        
        // System Usage
        self.systemUsage = CGFloat(search(for: "sy", in: cpuUsageComponents))
        
        // User Nice Usage
        self.userNiceUsage = CGFloat(search(for: "ni", in: cpuUsageComponents))
        
        // Idle Usage
        self.idleUsage = CGFloat(search(for: "id", in: cpuUsageComponents))
        
        // CPU Usage
        self.cpuUsage = 100 - (self.idleUsage ?? 0)
        
        // ioWait Usage
        self.ioWaitUsage = CGFloat(search(for: "wa", in: cpuUsageComponents))
        
        // Steal Usage
        self.stealUsage =  CGFloat(search(for: "st", in: cpuUsageComponents))
        
        // Core Count
        self.coreCount = Int16(dataComponents[5])
        
        // Memory Total
        self.memoryTotal = CGFloat(search(for: "total", in: memoryComponents))
        
        // Free Memory Total
        self.freeMemoryTotal = CGFloat(search(for: "free", in: memoryComponents))
        
        // Used Memory Total
        self.usedMemoryTotal = CGFloat(search(for: "used", in: memoryComponents))
        
        // Cached Memory Total
        self.cachedMemoryTotal = CGFloat(search(for: "buffcache", in: memoryComponents))
        
        // OS Name
        self.osName = osInfoComponents.first?.components(separatedBy: "\"").dropFirst().first
        
        // OS Version
        self.osVersion = osInfoComponents.last?.components(separatedBy: "\"").dropFirst().first
        
    }
    
    private func search(for field: String, in array: [String]) -> String {
        guard !array.isEmpty else {
            return ""
        }
        
        var targetIndex: Int = -1
        let enumeratableArray = array.enumerated()
        
        for (i, element) in enumeratableArray {
            let filteredElement = element.trimmingCharacters(in: .punctuationCharacters).replacingOccurrences(of: "/", with: "")
            if filteredElement == field {
                for j in (0...i).reversed() {
                    if (array[j].doubleValue != nil) {
                        targetIndex = j
                        break
                    }
                }
                break
            }
        }
        
        guard targetIndex > 0 else {
            return ""
        }
        
        return array[targetIndex]
    }
    
    private func search(for field: String, in array: [String]) -> [String] {
        guard !array.isEmpty else {
            return [String]()
        }
        
        var returnArray = [String]()
        
        let enumeratableArray = array.enumerated()
        
        for (i, element) in enumeratableArray {
            let filteredElement = element.trimmingCharacters(in: .punctuationCharacters).replacingOccurrences(of: "/", with: "")
            if filteredElement == field {
                for j in ((i + 1)..<array.count) {
                    let item = array[j].trimmingCharacters(in: .punctuationCharacters)
                    if item.doubleValue != nil {
                        returnArray.append(item)
                    } else {
                        break
                    }
                }
            }
        }
        
        return returnArray
    }
}


extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension String {
    struct NumFormatter {
        static let instance = NumberFormatter()
    }
    
    var doubleValue: Double? {
        return NumFormatter.instance.number(from: self)?.doubleValue
    }
    
    var integerValue: Int? {
        return NumFormatter.instance.number(from: self)?.intValue
    }
    
    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
              ,leftRange.upperBound <= rightRange.lowerBound else { return nil }
        
        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }
}

