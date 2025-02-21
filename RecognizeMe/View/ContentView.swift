//
//  ContentView.swift
//  RecognizeMe
//
//  Created by Jasper Tan on 2/14/25.
//

import PhotosUI
import SwiftUI
import SwiftData

struct ContentView: View {
    
    //Bool to enable sheet to add new contact details
    @State private var showAddContactView = false
    
    @Environment(\.modelContext) var modelContext
    @Query var contactList: [Contact] = []
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(contactList) { contact in
                    NavigationLink(value: contact) {
                        HStack {
                            if let image = contact.getImage() {
                                image
                                    .resizable()
                                    .scaledToFit()
                            }
                            
                            Text(contact.name)
                            
                        }
                    }
                }
                .onDelete { indexSet in
                    deleteContact(at: indexSet)
                }
            }
            .navigationTitle("RecognizeMe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Add User", systemImage: "person.crop.circle.badge.plus") {
                    showAddContactView = true
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showAddContactView) {
                AddContactView()
            }
            .navigationDestination(for: Contact.self) { contact in
                ContactDetailView(contact: contact)
            }
        }
        
    }
    
    func deleteContact(at offsets: IndexSet) {
        
        
        for offset in offsets {
            let contact = contactList[offset]
            
            modelContext.delete(contact)
        }
    }
}

#Preview {
    
    ContentView()
}
