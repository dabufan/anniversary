import Foundation
import Combine

class AnniversaryStore: ObservableObject {
    @Published var anniversaries: [Anniversary]

    private static let userDefaultsKey = "Anniversaries"

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.userDefaultsKey) {
            if let decoded = try? JSONDecoder().decode([Anniversary].self, from: data) {
                self.anniversaries = decoded
                return
            }
        }
        self.anniversaries = []
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(anniversaries) {
            UserDefaults.standard.set(encoded, forKey: Self.userDefaultsKey)
        }
    }
}
