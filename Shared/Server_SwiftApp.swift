//
//  Server_SwiftApp.swift
//  Shared
//
//  Created by Mettaworldj on 3/3/21.
//

import SwiftUI
import SwiftKeychainWrapper

@main
struct Server_SwiftApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(ObservableServers())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
