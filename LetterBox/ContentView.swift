import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    // get the data using swiftdata
    @Query private var items: [Item]
    @State private var searchText: String = ""
    @State private var showAddView = false
    // Header
    private var Header: some View {
        
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
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                Header
                
                // cards
                List {
                    ForEach(items) { item in
                        NavigationLink(destination: CardDetailView(item: item)) {
                            HStack {
                                // Display the image if there are items to show someone
                                if let data = item.image, let uiImage = UIImage(data: data) {
                                    // put the image in the stack itme
                                    Image(uiImage: uiImage)
                                        .resizable()
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
    private func deleteItems(offsets: IndexSet) {
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
