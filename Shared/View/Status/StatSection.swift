//
//  StatSection.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/4/21.
//

import SwiftUI

struct StatSection: View {
    
    @State var flipped = false
    
    var progressValue: CGFloat?
    
    var altProgressValue: CGFloat?
    
    var altInnerRadius: CGFloat?
    
    var altMiddleRadius: CGFloat?
    
    var altOuterRadius: CGFloat?
    
    let frontName: String
    
    let backName: String
    
    var body: some View {
        
        let flipDegrees = flipped ? 180.0 : 0
        
        ZStack {
            Content(progressValue: progressValue, altProgressValue: altProgressValue, name: frontName)
                .placedOnCard(Color.dynamicDark).flipRotate(flipDegrees).opacity(flipped ? 0.0 : 1.0)
            
            Content(progressValue: progressValue, altProgressValue: altProgressValue,
                    radius1: altInnerRadius,  loadAvg5Min: altMiddleRadius, loadAvg15Min: altOuterRadius,
                    name: backName)
                .placedOnCard(Color.dynamicDark).flipRotate(-180 + flipDegrees).opacity(flipped ? 1.0 : 0.0)
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
        
        var radius1: CGFloat?
        
        var loadAvg5Min: CGFloat?
        
        var loadAvg15Min: CGFloat?
        
        let name: String
        
        var frameSize: CGFloat = 50
        
        var body: some View {
            VStack {
                
                if (loadAvg5Min == nil || loadAvg15Min == nil) {
                    UsageCircle(progressValue: progressValue, altProgressValue: altProgressValue)
                        .frame(width: frameSize, height: frameSize, alignment: .center)
                } else {
                    NestedUsageCircle(loadAvg1Min: radius1, loadAvg5Min: loadAvg5Min, loadAvg15Min: loadAvg15Min)
                        .frame(width: frameSize, height: frameSize, alignment: .center)
                }
                
                Text(name)
                    .font(.caption2)
                    .padding(.top, 10)
                    .foregroundColor(.lightGrey)
            }
        }
    }
}
