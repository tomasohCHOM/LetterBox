import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var searchText: String = ""

    // Header
    private var Header: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            Text("LetterBox")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.primary)
                .colorInvert()
            
            HStack {
                TextField("Search your memories...", text: $searchText)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding()
        // gradient for header colors
        .background(LinearGradient(
            colors: [.pink, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
    }

    var body: some View {
        NavigationStack {
            // stack for the home page
            VStack(spacing: 0) {
                
                Header
                
                // memories
                List {
                    ForEach(items) { item in
                            Text("New memory")
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: addItem) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

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
