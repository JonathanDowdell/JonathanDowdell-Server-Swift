//
//  SectionedStatCircle.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/19/21.
//

import SwiftUI

struct SectionedStatCircle: View {
    
    var mainUsage: CGFloat = 0.3
    
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: mainUsage + 0.06, to: min(1, 1))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .square, lineJoin: .miter))
                .foregroundColor(Color(.sRGB, red: 28/255, green: 27/255, blue: 29/255, opacity: 1))
                .rotationEffect(Angle(degrees: 180 * 2.5))
                .animation(.spring())
            
            Circle()
                .trim(from: 0, to: min(mainUsage, 1))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .square, lineJoin: .miter))
                .foregroundColor(Color(.sRGB, red: 44/255, green: 208/255, blue: 87/255, opacity: 1))
                .rotationEffect(Angle(degrees: 180 * 2.5))
                .animation(.spring())
        }
    }
}

struct SectionedStatCircle_Previews: PreviewProvider {
    static var previews: some View {
        SectionedStatCircle()
            .frame(width: 50, height: 50, alignment: .center)
            .preferredColorScheme(.dark)
    }
}
