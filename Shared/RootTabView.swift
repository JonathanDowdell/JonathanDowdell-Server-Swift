//
//  RootTabView.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/3/21.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            StatusView()
                .tabItem {
                    Image(systemName: "gauge")
                    Text("Status")
                }
            
            PodView()
                .tabItem {
                    Image(systemName: "shippingbox")
                    Text("Pods")
                }
            
            ServerView()
                .tabItem {
                    Image(systemName: "xserve")
                    Text("Servers")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
