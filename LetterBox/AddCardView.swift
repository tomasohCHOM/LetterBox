import PhotosUI
import SwiftData
import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: Data?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                // show the image once someone or like user selects it
                if let selectedImage, let uiImage = UIImage(data: selectedImage)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(12)
                } else {
                    ContentUnavailableView(
                        "No Photo Selected",
                        systemImage: "photo.badge.plus"
                    )
                }

                // button to pick photos
                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Select Photo", systemImage: "photo")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
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
                    .disabled(selectedImage == nil)
                }
            }
            // turns the image into data and sets it to selected image variable
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(
                    type: Data.self
                ) {
                    selectedImage = data
                }
            }
        }
    }
    // saves card and adds it to context
    func saveCard() {
        guard let data = selectedImage else { return }
        let newItem = Item(timestamp: Date(), image: data)
        modelContext.insert(newItem)
        dismiss()
    }
}

#Preview {
    AddCardView()
        .modelContainer(for: Item.self, inMemory: true)
}
