import SwiftData
import SwiftUI

struct CardDetailView: View {
    let item: Item

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // gets the image data for the item and shows it big as long as there is data for it
                if let data = item.image, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }

                // show the info for the image, just the timestamp right now
                VStack(alignment: .leading, spacing: 8) {
                    Text("Card Captured")
                        .font(.title2.weight(.bold))

                    Text(
                        item.timestamp,
                        format: .dateTime.weekday().month().day().year().hour()
                            .minute()
                    )
                    .font(.body)
                    .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Card")
        .navigationBarTitleDisplayMode(.inline)
    }
}
