import SwiftUI
import SwiftData
import PhotosUI

struct AddCardView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

   // simple variable names
    @State var photo1: PhotosPickerItem?
    @State var data1: Data?

    @State var name : String=""
    @State var from:String = ""
     @State var event: String=""
    @State var date : Date=Date()

    @State var photo2: PhotosPickerItem?
      @State var data2: Data?

    var body: some View {
        NavigationStack {
            Form {
                Section("Card Info"){
                   TextField("Card Name", text: $name)
                    TextField("From", text: $from)
                   TextField("Event", text: $event)
                    DatePicker("Date Received", selection: $date, displayedComponents: .date)
                }

                Section("Front of card") {
                    // check if data exists first
                    if data1 != nil {
                       if let image = UIImage(data: data1!) {
                            Image(uiImage: image).resizable()
                                .scaledToFit()
                                 .frame(height: 200)
                                .cornerRadius(8)
                        }
                    }

                    PhotosPicker(selection: $photo1, matching: .images) {
                        // basic if else for label
                        if data1 == nil {
                            Label("Select Front Photo", systemImage: "photo")
                        } else {
                             Label("Change Front Photo", systemImage: "photo")
                        }
                    }
                }


                
                Section("Inside of card") {
                     if data2 != nil {
                        if let image = UIImage(data: data2!) {
                            Image(uiImage: image).resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                 .cornerRadius(8)
                        }
                    }

                    PhotosPicker(selection: $photo2, matching: .images) {
                        if data2 == nil {
                            Label("Select Inside Photo", systemImage: "photo")
                        } else {
                           Label("Change Inside Photo", systemImage: "photo")
                        }
                    }
                }
            }
            .navigationTitle("New Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                // Save Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveCard()
                    }
                    // only alloww save when you select an image for the card
                    .disabled(data1 == nil || name == "" || from == "" || data2 == nil || event == "")
                }
            }
            // turns the image into data and sets it to selected image variable async
            .task(id: photo1) {
                if let data = try? await photo1?.loadTransferable(type: Data.self) {
                    data1 = data
                }
            }

             .task(id: photo2) {
                if let data = try? await photo2?.loadTransferable(type: Data.self) {
                     data2 = data
                }
            }
        }
    }
    // saves card and adds it to context
    func saveCard() {
        if data1 != nil {
            let item = Item(timestamp: Date(), image: data1, insideimage: data2, cardName: name, sender: from, event: event, dateReceived: date)
            modelContext.insert(item)
            dismiss()
        }
    }
}


#Preview {
    AddCardView()
        .modelContainer(for: Item.self, inMemory: true)
}
