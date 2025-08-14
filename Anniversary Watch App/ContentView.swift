import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var anniversaries: [Anniversary]

    @State private var isAddingNewAnniversary = false

    var body: some View {
        NavigationView {
            List {
                ForEach(anniversaries) { anniversary in
                    NavigationLink(destination: AnniversaryDetailView(anniversary: anniversary)) {
                        HStack {
                            Image(systemName: anniversary.category.iconName)
                                .foregroundColor(.accentColor)
                            Text(anniversary.title)
                        }
                    }
                }
                .onDelete(perform: deleteAnniversaries)
            }
            .navigationTitle("Anniversaries")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isAddingNewAnniversary = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingNewAnniversary) {
                AddAnniversaryView(isPresented: $isAddingNewAnniversary)
            }
        }
    }

    private func deleteAnniversaries(at offsets: IndexSet) {
        for offset in offsets {
            let anniversary = anniversaries[offset]
            NotificationManager.shared.cancelNotification(for: anniversary)
            modelContext.delete(anniversary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: Anniversary.self, inMemory: true)
    }
}
