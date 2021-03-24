//
//  ServerView.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/3/21.
//

import SwiftUI
import Network

struct ServerView: View {
    
    @EnvironmentObject var observedServers: ObservableServers
    
    @State private var showingServerCreationView = false
    
    @State private var showingServerEditView = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: ServerSettingsView(),
                    label: {
                        HStack {
                            Text("Settings")
                                .foregroundColor(.accentColor)
                            
                            Spacer()
                            
                            Image(systemName: "cloud.fill")
                            .foregroundColor(.green)
                        }
                    })
                
                NavigationLink(
                    destination: Text("Destination"),
                    label: {
                        HStack {
                            Text("Keychain")
                                .foregroundColor(.accentColor)
                        }
                    })
                
                Section(header: Text("SERVERS").font(.caption)) {
                    ForEach(observedServers.servers, id: \.self) { server in
                        ServerRow(server: server)
                            .onTapGesture {
                                print(server.name)
                            }
                            .sheet(isPresented: $showingServerEditView, content: {
                                ServerCreationView(server: observedServers.editingServer!, showingView: $showingServerEditView)
                            })
                            .contextMenu(ContextMenu(menuItems: {
                                Button(action: {
                                    observedServers.editingServer = server
                                    showingServerEditView = true
                                }, label: {
                                    Text("Edit")
                                })
                                Button(action: {
                                    observedServers.remove(server: server)
                                }, label: {
                                    Text("Remove")
                                })
                            }))
                    }
//                    ForEach(observedServers.servers.filter{ $0.showing }.indices, id: \.self) { index in
//                        ServerRow(server: observedServers.servers[index])
//                            .sheet(isPresented: $showingServerEditView, content: {
//                                ServerCreationView(server: $observedServers.servers[index], showingView: $showingServerEditView)
//                            })
//                            .contextMenu(ContextMenu(menuItems: {
//                                Button(action: {
//                                    showingServerEditView = true
//                                    print(observedServers.servers[index])
//                                }, label: {
//                                    Text("Edit")
//                                })
//                                Button(action: {
//                                    observedServers.remove(with: index)
//                                }, label: {
//                                    Text("Remove")
//                                })
//                            }))
//                    }
                }
            }
            .listStyle(InsetListStyle())
            .navigationTitle("Servers")
            .navigationBarItems(trailing: Button(action: {showingServerCreationView.toggle()}, label: {
                Text("Add")
            }))
            .sheet(isPresented: $showingServerCreationView) {
                ServerCreationView(showingView: $showingServerCreationView)
            }
        }
    }
}

struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        ServerView()
    }
}

