//
//  ServerCreationView.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/8/21.
//

import SwiftUI

struct ServerCreationView: View {
    
    @EnvironmentObject var observableServers: ObservableServers
    
    @State var server = MockData.servers[2]
    
    @Binding var showingView: Bool
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Name")
                    TextField("Display Name", text: $server.name)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Host")
                    TextField("IP or Domain", text: $server.host)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Port")
                    TextField("Default 22", text: $server.port)
                        .multilineTextAlignment(.trailing)
                }
                
                Section(header: Text("AUTHENTICATION")) {
                    HStack {
                        Text("User")
                        TextField("Username", text: $server.authentication.user)
                            .autocapitalization(.none)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Password")
                        SecureField("Password", text: $server.authentication.password)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(footer: Text("")) {
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            HStack {
                                Text("SSH Key")
                                Spacer()
                                Text("Auto")
                                    .foregroundColor(.gray)
                            }
                        })
                }
                
                HStack {
                    Text("Show in Status")
                    
                    Toggle("", isOn: $server.showing)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Add Server")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                showingView = false
            }, label: {
                Text("Cancel")
                    .bold()
            }), trailing: Button(action: {
                let _ = observableServers.save(server: server)
                showingView = false
            }, label: {
                Text("Save")
                    .bold()
            }))
        }
    }
    
}

struct ServerCreationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            ServerCreationView(showingView: .constant(true))
                .preferredColorScheme(.light)
            
            
            ServerCreationView(showingView: .constant(true))
                .preferredColorScheme(.dark)
            
        }
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
