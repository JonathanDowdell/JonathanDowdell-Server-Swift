//
//  ServerRow.swift
//  Server Swift
//
//  Created by Mettaworldj on 3/5/21.
//

import SwiftUI

struct ServerRow: View {
    
    @Binding var server: Server
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(server.name)
                    .bold()
                
                Text("\(server.authentication.user)@\(server.host)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "terminal")
            })
            .foregroundColor(.accentColor)
        }
        .padding(.vertical, 8)
    }
}

struct ServerRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ServerRow(server: .constant(MockData.servers[0]))
                .preferredColorScheme(.light)
            
            ServerRow(server: .constant(MockData.servers[0]))
                .preferredColorScheme(.dark)
        }
    }
}
