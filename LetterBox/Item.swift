import SwiftData
import SwiftUI

@Model
final class Item {
    var timestamp: Date
    @Attribute(.externalStorage) var image: Data?
    // storing images now
    init(timestamp: Date, image: Data? = nil) {
        self.timestamp = timestamp
        self.image = image
    }
}
