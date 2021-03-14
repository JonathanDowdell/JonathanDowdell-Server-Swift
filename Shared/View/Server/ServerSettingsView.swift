//
//  ServerSettings.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/5/21.
//

import SwiftUI

struct ServerSettingsView: View {
    
    @State var isOn = true
    
    var body: some View {
        List {
            Section(header: Text("GENERAL")) {
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        HStack {
                            Text("Appearance")
                            Spacer()
                            Text("Auto")
                                .foregroundColor(.gray)
                        }
                    })
            }
            
            Section(header: Text("FEATURES")) {
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Text("Terminal")
                    })
                
                HStack {
                    Text("Unlock with Face ID")
                    
                    Toggle("", isOn: $isOn)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Settings")
    }
}

struct ServerSettings_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ServerSettingsView()
                    .preferredColorScheme(.light)
            }
            
            NavigationView {
                ServerSettingsView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
