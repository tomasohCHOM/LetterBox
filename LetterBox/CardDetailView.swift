import SwiftUI
import SwiftData

struct CardDetailView: View {
   let item: Item

    var body: some View {
        ScrollView {
             VStack(spacing: 20) {

                // gets the image data for the item and shows it big as long as there is data for it
                if item.image != nil {
                     let image = UIImage(data: item.image!)!
                     Image(uiImage: image).resizable()
                    .scaledToFit()
                     .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }

                if item.insideimage != nil {
                     let image = UIImage(data: item.insideimage!)!
                    Image(uiImage: image)
                        .resizable()
                         .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                         .shadow(radius: 5)
                }

                // show the info for the image like from event recieved and created
                 VStack(alignment: .leading, spacing: 8) {
                    Text(item.cardName).font(.title2.weight(.bold))
                    Text("From \(item.sender)")
                        .font(.body)
                       .foregroundColor(.secondary)

                Text("Event: \(item.event)")
                         .font(.body)
                        .foregroundColor(.secondary)

                    Text("Received: \(item.dateReceived, format: .dateTime.weekday().month().day().year().hour().minute())")
                        .font(.body)
                         .foregroundColor(.secondary)
                    
                     Text("Created: \(item.timestamp, format: .dateTime.weekday().month().day().year().hour().minute())")
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
