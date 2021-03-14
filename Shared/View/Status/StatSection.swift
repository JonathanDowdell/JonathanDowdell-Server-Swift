//
//  StatSection.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/4/21.
//

import SwiftUI

struct StatSection: View {
    
    var progressValue: CGFloat?
    
    var altProgressValue: CGFloat?
    
    @State var flipped = false
    
    let frameSize: CGFloat
    
    let name: String
    
    let altName: String
    
    var body: some View {
        
        let flipDegrees = flipped ? 180.0 : 0
        
        ZStack {
            Content(progressValue: progressValue, altProgressValue: altProgressValue, frameSize: frameSize, name: name, processType: StatSection.Content.ProcessType.CPU)
                .placedOnCard(Color.dynamicDark, frameSize: frameSize).flipRotate(flipDegrees).opacity(flipped ? 0.0 : 1.0)
            
            Content(progressValue: progressValue, altProgressValue: altProgressValue, frameSize: frameSize, name: altName, processType: StatSection.Content.ProcessType.Load)
                .placedOnCard(Color.dynamicDark, frameSize: frameSize).flipRotate(-180 + flipDegrees).opacity(flipped ? 1.0 : 0.0)
        }
        .onTapGesture {
            withAnimation {
                Vibration.light.vibrate()
                flipped.toggle()
            }
        }
        
    }
    
    
    struct Content: View {
        
        var progressValue: CGFloat?
        
        var altProgressValue: CGFloat?
        
        let frameSize: CGFloat
        
        let name: String
        
        var processType: ProcessType
        
        var body: some View {
            VStack {
                
                if processType == .CPU {
                    CircleStat(progressValue: progressValue, altProgressValue: altProgressValue)
                        .frame(width: frameSize, height: frameSize, alignment: .center)
                } else {
                    NestedCircleStat(progressValue: progressValue)
                        .frame(width: frameSize, height: frameSize, alignment: .center)
                }
                
                Text(name)
                    .font(.caption2)
                    .padding(.top, 10)
                    .foregroundColor(.lightGrey)
            }
        }
        
        enum ProcessType {
            case CPU
            case Load
        }
    }
}
