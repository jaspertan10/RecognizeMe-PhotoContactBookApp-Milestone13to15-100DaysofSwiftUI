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
    @State private var startLocation: Coordinate2D?
    @State private var locationMet: Coordinate2D?
    
    @State private var highlightMissingEntries: Bool = false
    
    @State private var showMapSheet: Bool = false
    
    let locationFetcher: LocationFetcher
    
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
                    
                    if let _ = locationMet {
                        Text("Location met")
                            
                        MapView(location: $startLocation, locationMet: $locationMet)
                            .frame(height: 300)
                    }
                    else {
                        Button("Set location met") {
                            if let userLocation = locationFetcher.lastKnownLocation {
                                print("Your location is \(userLocation)")
                                startLocation = Coordinate2D(userLocation)
                                showMapSheet = true
                            } else {
                                print("Your location is unknown")
                            }
                        }
                        .foregroundStyle(highlightMissingEntries ? .red : .blue)
                    }
                }
            }
            .navigationTitle("Add Contact")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard((!name.isEmpty) && (selectedImage != nil) && (locationMet != nil)) else {
                            highlightMissingEntries = true
                            return
                        }
                        
                        if let imageData {
                            let newContact = Contact(name: name, photo: imageData, location: locationMet ?? nil)
                            modelContext.insert(newContact)
                            dismiss()
                        }
                    }
                }
            }
            .onChange(of: pickerItem) {
                Task {
                    await loadImage(pickerItem: pickerItem)
                }
            }
            .sheet(isPresented: $showMapSheet) {
                
                //Initially go in to MapView with location containing the position for MapCameraPosition
                //After marking a location within MapView, the location (since binded) will have the new marked location. Indicating where user met the contact.
                MapView(location: $startLocation, locationMet: $locationMet)
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
    AddContactView(locationFetcher: LocationFetcher())
}
