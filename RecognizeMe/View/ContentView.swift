//
//  ContentView.swift
//  RecognizeMe
//
//  Created by Jasper Tan on 2/14/25.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    
    //Bool to enable sheet to add new contact details
    @State private var showAddContactView = false
    
    @State var contactList: [Contact] = []
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(contactList) { contact in
                    HStack {
                        contact.selectedImage
                            .resizable()
                            .scaledToFit()
                        
                        Text(contact.name)
                        
                    }
                }
            }
            .navigationTitle("RecognizeMe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Add User", systemImage: "person.crop.circle.badge.plus") {
                    showAddContactView = true
                }
            }
            .sheet(isPresented: $showAddContactView) {
                AddContactView(contactList: $contactList)
            }
        }
        
    }
}

#Preview {
    
    var contactList: [Contact] = []
    ContentView(contactList: contactList)
}
