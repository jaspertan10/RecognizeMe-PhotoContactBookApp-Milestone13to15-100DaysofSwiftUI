//
//  ContactDetailView.swift
//  RecognizeMe
//
//  Created by Jasper Tan on 2/16/25.
//

import SwiftUI
import SwiftData

struct ContactDetailView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let contact: Contact
    
    var body: some View {
        ScrollView {
            if let image = contact.getImage() {
                image
                    .resizable()
                    .scaledToFit()
            }
            
            Text(contact.name)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    ContactDetailView(contact: Contact(name: <#T##String#>, photo: nil))
//}
