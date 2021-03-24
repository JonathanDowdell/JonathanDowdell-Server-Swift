//
//  CircleStatus.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/3/21.
//

import SwiftUI

struct UsageCircle: View {
    
    var progressValue: CGFloat?
    
    var altProgressValue: CGFloat?
    
    var body: some View {
        
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .fill(Color.dynamicOpaqueGrey)
                
                Circle()
                    .trim(from: 0, to: min(calculateUsage(altProgressValue), 1))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color(.sRGB, red: 142/255, green: 141/255, blue: 148/255, opacity: 0.3))
                    .rotationEffect(Angle(degrees: 180 * 2.5))
                    .animation(.spring())
                
                Circle()
                    .trim(from: 0, to: min(calculateUsage(progressValue), 1))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(assignColor())
                    .rotationEffect(Angle(degrees: 180 * 2.5))
                    .animation(.spring())
                
                if let progressValue = progressValue {
                    Text("\(Int8(progressValue))%")
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
    
    func calculateUsage(_ value: CGFloat?) -> CGFloat {
        guard let value = value else { return 0.005}
        let calculatedValue = value / 100
        guard calculatedValue != 0 else {
            return 0.005
        }
        return calculatedValue
    }
    
    func assignColor() -> Color {
        let greenColor = Color(.sRGB, red: 44/255, green: 208/255, blue: 87/255, opacity: 1)
        
        guard let progressValue = progressValue else { return .clear }
        switch progressValue {
        case 0...50:
            return greenColor
        case 51...70:
            return .yellow
        case 71...:
            return .red
        default:
            return greenColor
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UsageCircle(progressValue: 0.005, altProgressValue: 0.005)
                .preferredColorScheme(.dark)
                .frame(width: 65, height: 65)
                .padding()
            
            UsageCircle(progressValue: 0.005)
                .preferredColorScheme(.light)
                .frame(width: 65, height: 65)
                .padding()
        }
    }
}
