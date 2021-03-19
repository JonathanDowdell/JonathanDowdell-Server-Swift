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
            LazyVStack {
                
            }
        }.navigationTitle(observableServerRowStatus.osVersion ?? "")
    }
}

struct StatusServerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StatusServerDetailView(observableServerRowStatus: ObservableServerRowStatus(with: MockData.servers[0]))
    }
}
