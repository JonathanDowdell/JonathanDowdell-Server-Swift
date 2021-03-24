//
//  ReadWriteSection.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/4/21.
//

import SwiftUI


struct ReadWriteSection: View {
    
    let name: String
    
    let upSpeed = Int.random(in: 0...999)
    
    let downSpeed = Int.random(in: 0...999)
    
    @State var flipped = false
    
    var frameSize: CGFloat = 50
    
    var body: some View {
        
        let flipDegrees = flipped ? 180.0 : 0
        
        ZStack {
            Content(frameSize: frameSize, name: name, upSpeed: upSpeed, downSpeed: downSpeed)
                .placedOnCard(Color.dynamicDark, frameSize: frameSize).flipRotate(flipDegrees).opacity(flipped ? 0.0 : 1.0)
            
            Content(frameSize: frameSize, name: name, upSpeed: upSpeed, downSpeed: downSpeed)
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
        
        let frameSize: CGFloat
        
        let name: String
        
        let upSpeed: Int
        
        let downSpeed: Int
        
        var body: some View {
            VStack {
                VStack {
                    HStack(alignment: .bottom, spacing: 1) {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 8, height: 8, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.lightGrey)
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 8, height: 8, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.lightGrey)
                    }
                    
                    HStack(alignment: .bottom, spacing: 3) {
                        Text("\(upSpeed)")
                            .font(.custom("RobotoMono-Regular", fixedSize: 15))
                        Text("M")
                            .font(.custom("RobotoMono-Regular", fixedSize: 12))
                            .foregroundColor(.lightGrey)
                    }
                    
                    HStack(alignment: .bottom, spacing: 3) {
                        Text("\(downSpeed)")
                            .font(.custom("RobotoMono-Regular", fixedSize: 15))
                        Text("M")
                            .font(.custom("RobotoMono-Regular", fixedSize: 12))
                            .foregroundColor(.lightGrey)
                    }
                }
                .fixedSize()
                .frame(width: frameSize, height: frameSize, alignment: .center)
                
                
                Spacer()
                
                Text(name)
                    .font(.caption2)
                    .padding(.top, 10)
                    .foregroundColor(.lightGrey)
            }
        }
    }
}
