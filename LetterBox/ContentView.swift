import SwiftData
import SwiftUI

struct HomeView: View {
   @Environment(\.modelContext) var modelContext
    // get the data using swiftdata
   @Query var items: [Item]
    @State var searchText: String = ""
     @State var showAddView = false

    @State var currentEvent: String = "All"
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
                        //  filter menu for filtering by event
                     Menu {
                         // get all types of events
                         ForEach(getEventList(), id: \.self) { eventName in
                             Button(eventName) {
                                 currentEvent = eventName
                             }
                         }
                     } label: {
                         // free icon
                         Image(systemName: "line.3.horizontal.decrease.circle.fill")
                             .foregroundColor(currentEvent == "All" ? .gray : .purple)
                             .font(.title2)
                            }
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

                // cards, shows by filter if there is one
                List {
                    ForEach(filterItems()) { item in
                         NavigationLink(destination: CardDetailView(item: item)) {
                            HStack {
                                // Display the image if there are items to show someone
                                if let data = item.image, let image = UIImage(data: data) {
                                    Image(uiImage: image)
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
     func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                 modelContext.delete(items[index])
            }
        }
    }
    
    
    // gets a list of every event by sorting through them
    func getEventList() -> [String] {
            var eventList = ["All"]
            
            for item in items {
                // makes sure there are no duplicates
                if !eventList.contains(item.event) {
                    eventList.append(item.event)
                }
            }
            return eventList
        }
    
    // filters throughh the items and grabs ones that match selected search properties
    func filterItems() -> [Item] {
            var result: [Item] = []
            
            for item in items {
                var matchesSearch = true
                var matchesEvent = true
                // matches item even if case is weird
                if searchText != "" {
                    if !item.cardName.lowercased().contains(searchText.lowercased()) {
                        matchesSearch = false
                    }
                }
                
                // also checks if they filter by events or not
                if currentEvent != "All" {
                    if item.event != currentEvent {
                        matchesEvent = false
                    }
                }
                
                if matchesSearch && matchesEvent {
                    result.append(item)
                }
            }
            
            return result
        }
}

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}
