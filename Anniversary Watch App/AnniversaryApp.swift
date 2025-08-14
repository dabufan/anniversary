import SwiftUI
import SwiftData

@main
struct Anniversary_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }
        }
        .modelContainer(for: Anniversary.self)
    }
}
