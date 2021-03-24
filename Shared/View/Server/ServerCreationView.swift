//
//  ServerCreationView.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/8/21.
//

import SwiftUI

struct ServerCreationView: View {
    
    @EnvironmentObject var observableServers: ObservableServers
    
//    private(set) var server: Binding<Server>?
    
    private(set) var server: Server?
    
    @Binding private(set) var showingView: Bool
    
    @State private(set) var name: String = ""
    
    @State private(set) var host: String = ""
    
    @State private(set) var port: String = ""
    
    @State private(set) var user: String = ""
    
    @State private(set) var password: String = ""
    
    @State private(set) var showing: Bool = true
    
//    init(server: Binding<Server>, showingView: Binding<Bool>) {
//        self.server = server
//        self._showingView = showingView
//        self._name = State(initialValue: server.name.wrappedValue)
//        self._host = State(initialValue: server.host.wrappedValue)
//        self._port = State(initialValue: server.port.wrappedValue)
//        self._user = State(initialValue: server.authentication.user.wrappedValue)
//        self._password = State(initialValue: server.authentication.password.wrappedValue)
//        self._showing = State(initialValue: server.showing.wrappedValue)
//    }
    
    init(server: Server, showingView: Binding<Bool>) {
        self.server = server
        print(server.name)
        self._showingView = showingView
        self._name = State(initialValue: server.name)
        self._host = State(initialValue: server.host)
        self._port = State(initialValue: server.port)
        self._user = State(initialValue: server.authentication.user)
        self._password = State(initialValue: server.authentication.password)
        self._showing = State(initialValue: showing)
    }
    
    init(showingView: Binding<Bool>) {
        self._showingView = showingView
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Name")
                    TextField("Display Name", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Host")
                    TextField("IP or Domain", text: $host)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Port")
                    TextField("Default 22", text: $port)
                        .multilineTextAlignment(.trailing)
                }
                
                Section(header: Text("AUTHENTICATION")) {
                    HStack {
                        Text("User")
                        TextField("Username", text: $user)
                            .autocapitalization(.none)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Password")
                        SecureField("Password", text: $password)
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
                    
                    Toggle("", isOn: $showing)
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
            }), trailing: Button(action: save, label: {
                Text("Save")
                    .bold()
            }))
        }
    }
    
    private func save() {
        if server == nil {
            let auth = Authentication(user: user, password: password, rsa: nil)
            let server = Server(name: name, host: host, port: port, showing: showing, authentication: auth, createdDate: Date())
            let _ = observableServers.save(server: server)
            showingView = false
        } else {
            guard var editingServer = server else { return }
            editingServer.name = name
            editingServer.host = host
            editingServer.port = port
            editingServer.authentication.user = user
            editingServer.authentication.password = password
            editingServer.showing = showing
            print(editingServer)
            let _ = observableServers.update(server: editingServer)
            showingView = false
//            guard let existingServer = server else { return }
//            existingServer.name.wrappedValue = name
//            existingServer.host.wrappedValue = host
//            existingServer.port.wrappedValue = port
//            existingServer.authentication.user.wrappedValue = user
//            existingServer.authentication.password.wrappedValue = password
//            existingServer.showing.wrappedValue = showing
//            let _ = observableServers.update(server: existingServer.wrappedValue)
//            showingView = false
        }
    }
}

struct ServerCreationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ServerCreationView(server: MockData.servers[1], showingView: .constant(true))
                .preferredColorScheme(.light)
            
            
            ServerCreationView(server: MockData.servers[1], showingView: .constant(true))
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

