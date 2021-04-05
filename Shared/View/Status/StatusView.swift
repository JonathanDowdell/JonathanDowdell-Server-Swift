//
//  StatusView.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/3/21.
//

import SwiftUI

struct StatusView: View {
    
    @EnvironmentObject var observedServers: ObservableServers
    
    var body: some View {
        
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 50) {
                    ForEach(observedServers
                                .servers
                                .filter{ $0.showing }
                                .sorted{ $0.createdDate < $1.createdDate },
                            id: \.self) { server in
                        StatusServerRow(observableServerRowStatus: ObservableServerRowStatus(with: server))
                    }
                }
                .padding(.top, 25)
                .padding(.bottom, 50)
            }
            .fixFlickering()
            .navigationTitle("Status")
            .navigationBarItems(trailing: HStack(spacing: 20) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "chevron.left.slash.chevron.right")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                })
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "bolt.circle")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                })
            })
        }
        
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}


extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
