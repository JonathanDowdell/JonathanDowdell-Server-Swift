//
//  NestedCircles.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/4/21.
//

import SwiftUI

struct NestedUsageCircle: View {
    
    var loadAvg1Min: CGFloat?
    
    var loadAvg5Min: CGFloat?
    
    var loadAvg15Min: CGFloat?
    
    var body: some View {
        
        ZStack {
            Content(progressValue: loadAvg15Min)
            
            Content(progressValue: loadAvg1Min)
                .frame(width: 50/3, height: 50/3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Content(progressValue: loadAvg5Min)
                .frame(width: 50/1.5, height: 50/1.5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
    }
    
    struct Content: View {
        
        var progressValue: CGFloat?
        
        var offSet: CGFloat = 1
        
        var color: Color = .green
        
        var body: some View {
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color(.sRGB, red: 28/255, green: 27/255, blue: 29/255, opacity: 1))
                    .rotationEffect(Angle(degrees: 180 * 2.5))
                
                Circle()
                    .trim(from: 0, to: min((progressValue ?? 0.005) * offSet, 1))
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: 180 * 2.5))
                    .animation(.linear)
            }
        }
    }
}

struct NestedCircles_Previews: PreviewProvider {
    static var previews: some View {
        NestedUsageCircle()
            .preferredColorScheme(.dark)
            .frame(width: 50, height: 50, alignment: .center)
    }
}
