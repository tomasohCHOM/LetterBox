import SwiftData
import SwiftUI

struct HomeView: View {
   @Environment(\.modelContext) var modelContext
    // get the data using swiftdata
   @Query var items: [Item]
    @State var searchText: String = ""
     @State var showAddView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // header with title and search box
                 VStack(alignment: .leading, spacing: 10) {
                    // title text
                    Text("LetterBox")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)

                    // search bar
                    HStack {
                         TextField("Search your memories...", text: $searchText)
                    }
                    .padding(10)
                     .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding()
                 .background(LinearGradient(
                    colors: [.pink, .purple],
                    startPoint: .topLeading,
                     endPoint: .bottomTrailing
                ))

                // cards
                List {
                    ForEach(items) { item in
                         NavigationLink(destination: CardDetailView(item: item)) {
                            HStack {
                                // Display the image if there are items to show someone
                                if item.frontImage != nil {
                                   // put the image in the stack itme
                                    let image = UIImage(data: item.frontImage!)!
                                    Image(uiImage: image).resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                         .clipShape(RoundedRectangle(cornerRadius: 8))
                                }

                                // holds the info for the card, shows the title and the timestamp and who its from along with event
                                VStack(alignment: .leading) {
                                    Text(item.cardName)
                                         .font(.headline)
                                    Text(item.timestamp, format: .dateTime)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                     Text("From \(item.sender) for \(item.event)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                     .onDelete(perform: deleteItems)
                }
                .listStyle(.plain)
            }
            // top buttons edit and add a card
            .toolbar {
                 ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddView = true }) {
                         Image(systemName: "plus")
                    }
                }
            }

            .sheet(isPresented: $showAddView) {
                 AddCardView()
            }
        }
    }

    // deleted selected item
     func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                 modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}
