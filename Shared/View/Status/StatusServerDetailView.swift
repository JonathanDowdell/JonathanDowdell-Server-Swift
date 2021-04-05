//
//  StatusServerDetailView.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/13/21.
//

import SwiftUI

struct StatusServerDetailView: View {
    
    @ObservedObject private(set) var observableServerRowStatus: ObservableServerRowStatus
    
    var body: some View {
        ScrollView {
            HStack {
                Text("\(observableServerRowStatus.serverStatistic.osName ?? "") \(observableServerRowStatus.serverStatistic.osVersion ?? "")")
                    .font(.caption)
                    .foregroundColor(.lightGrey)
                Spacer()
            }
            LazyVStack {
                GroupBox {
                    VStack {
                        HStack(alignment: .top) {
                            HStack(alignment: .lastTextBaseline, spacing: 2) {
                                Text("4")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .foregroundColor(.primary)
                                Text("%")
                                    .font(.system(.footnote, design: .rounded))
                                    .foregroundColor(.lightGrey)
                                    .bold()
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                HStack(alignment: .center, spacing: 4) {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.red)
                                        .frame(width: 5, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    Text("SYS")
                                        .font(.system(.caption2, design: .rounded))
                                        .foregroundColor(.lightGrey)
                                }
                                
                                HStack(spacing: 2) {
                                    Text("\(Int8(observableServerRowStatus.serverStatistic.systemUsage ?? 0))")
                                        .font(.system(.footnote, design: .rounded))
                                    Text("%")
                                        .font(.system(.footnote, design: .rounded))
                                        .foregroundColor(.lightGrey)
                                        .bold()
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                HStack(alignment: .center, spacing: 4) {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.green)
                                        .frame(width: 5, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    Text("USER")
                                        .font(.system(.caption2, design: .rounded))
                                        .foregroundColor(.lightGrey)
                                }
                                
                                HStack(spacing: 2) {
                                    Text("\(Int8(observableServerRowStatus.serverStatistic.userUsage ?? 0))")
                                        .font(.system(.footnote, design: .rounded))
                                    Text("%")
                                        .font(.system(.footnote, design: .rounded))
                                        .foregroundColor(.lightGrey)
                                        .bold()
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                HStack(alignment: .center, spacing: 4) {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.purple)
                                        .frame(width: 5, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    Text("IOWAIT")
                                        .font(.system(.caption2, design: .rounded))
                                        .foregroundColor(.lightGrey)
                                }
                                
                                HStack(spacing: 2) {
                                    Text("\(Int8(observableServerRowStatus.serverStatistic.ioWaitUsage ?? 0))")
                                        .font(.system(.footnote, design: .rounded))
                                    Text("%")
                                        .font(.system(.footnote, design: .rounded))
                                        .foregroundColor(.lightGrey)
                                        .bold()
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                HStack(alignment: .center, spacing: 4) {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.yellow)
                                        .frame(width: 5, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    Text("STEAL")
                                        .font(.system(.caption2, design: .rounded))
                                        .foregroundColor(.lightGrey)
                                }
                                
                                HStack(spacing: 2) {
                                    Text("\(Int8(observableServerRowStatus.serverStatistic.stealUsage ?? 0))")
                                        .font(.system(.footnote, design: .rounded))
                                    Text("%")
                                        .font(.system(.footnote, design: .rounded))
                                        .foregroundColor(.lightGrey)
                                        .bold()
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        .fixFlickering()
        .navigationTitle(observableServerRowStatus.server.name)
        .padding(.horizontal)
        .onDisappear {
            observableServerRowStatus.canStopTimer = true
        }
    }
}

struct StatusServerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatusServerDetailView(observableServerRowStatus: ObservableServerRowStatus(with: MockData.servers[0]))
                .preferredColorScheme(.dark)
            
            StatusServerDetailView(observableServerRowStatus: ObservableServerRowStatus(with: MockData.servers[0]))
                .preferredColorScheme(.light)
        }
    }
}
