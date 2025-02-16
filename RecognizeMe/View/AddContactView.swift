//
//  AddContactView.swift
//  RecognizeMe
//
//  Created by Jasper Tan on 2/16/25.
//

import PhotosUI
import SwiftUI

struct AddContactView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var contactList: [Contact]
    
    //Stores photo selected using PhotosPicker
    @State private var pickerItem: PhotosPickerItem?
    
    //Stores selected image as a SwiftUI Image
    @State private var selectedImage: Image?
    
    @State private var name = ""
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section("Contact Info") {
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFit()
                        } else {
                            ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo"))
                        }
                    }
                    
                    TextField("Contact Name", text: $name)
                }
                
                Section {
                    Button("Save") {
                        if let pickerItem {
                            if let selectedImage {
                                contactList.append(Contact(name: name, pickerItem: pickerItem, selectedImage: selectedImage))
                                dismiss()
                            }
                        }
                    }
                }
            }
            .onChange(of: pickerItem) {
                Task {
                    selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                }
            }
            .navigationTitle("Add Contact")
        }
    }
}

#Preview {
    @Previewable @State var contactList: [Contact] = []
    AddContactView(contactList: $contactList)
}
