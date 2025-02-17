//
//  AddContactView.swift
//  RecognizeMe
//
//  Created by Jasper Tan on 2/16/25.
//

import PhotosUI
import SwiftUI
import SwiftData

struct AddContactView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var contactList: [Contact]
    
    // Image related var
    @State private var pickerItem: PhotosPickerItem? //Stores photo selected using PhotosPicker
    @State private var selectedImage: Image? //Stores selected image as a SwiftUI Image
    @State private var imageData: Data? //Stores selected image as a Data type
    
    @State private var name = ""
    
    @State private var highlightMissingEntries: Bool = false
    
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
                            if (highlightMissingEntries && selectedImage == nil) {
                                ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo"))
                                    .foregroundStyle(.red)
                            }
                            else {
                                ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo"))
                            }
                        }
                    }
                    
                    TextField("Contact Name", text: $name)
                        .background(highlightMissingEntries && name.isEmpty ? .red : .clear)
                }
                
                Section {
                    Button("Save") {
                        
                        guard((!name.isEmpty) && (selectedImage != nil)) else {
                            highlightMissingEntries = true
                            return
                        }
                        
                        if let imageData {
                            let newContact = Contact(name: name, photo: imageData)
                            modelContext.insert(newContact)
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Add Contact")
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(.red)
            }
            .onChange(of: pickerItem) {
                Task {
                    await loadImage(pickerItem: pickerItem)
                }
            }
        }
    }
    
    func loadImage(pickerItem: PhotosPickerItem?) async {
        do {
            if let data = try await pickerItem?.loadTransferable(type: Data.self) {
                imageData = data
                if let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}

#Preview {
    AddContactView()
}
