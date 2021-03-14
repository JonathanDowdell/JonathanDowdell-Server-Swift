//
//  CircleStatus.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/3/21.
//

import SwiftUI

struct CircleStat: View {
    
    var progressValue: CGFloat?
    
    var altProgressValue: CGFloat?
    
    var body: some View {
        
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .fill(Color(.sRGB, red: 28/255, green: 27/255, blue: 29/255, opacity: 1))
                
                Circle()
                    .trim(from: 0, to: min(altProgressValue ?? 0.0001, 1))
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.lightGrey)
                    .rotationEffect(Angle(degrees: 180 * 2.5))
                    .animation(.spring())
                
                Circle()
                    .trim(from: 0, to: min(progressValue ?? 0.005, 1))
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color(.sRGB, red: 44/255, green: 208/255, blue: 87/255, opacity: 1))
                    .rotationEffect(Angle(degrees: 180 * 2.5))
                    .animation(.spring())
                
                if let progressValue = progressValue {
                    Text("\(Int8(progressValue * 100))%")
                        .font(.caption2)
                        .foregroundColor(.lightGrey)
                } else {
                    Text("%")
                        .font(.caption2)
                        .foregroundColor(.lightGrey)
                        .transition(.opacity)
                }
                
                
            }
            
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleStat(progressValue: 0.005, altProgressValue: 0.005)
                .preferredColorScheme(.dark)
                .frame(width: 65, height: 65)
                .padding()
            
            CircleStat(progressValue: 0.005)
                .preferredColorScheme(.light)
                .frame(width: 65, height: 65)
                .padding()
        }
    }
}
