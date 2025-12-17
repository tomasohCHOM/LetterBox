import SwiftData
import SwiftUI

@Model
final class Item {
    var timestamp: Date
    @Attribute(.externalStorage) var image: Data?
    @Attribute(.externalStorage) var insideimage: Data?
    var cardName: String
    var sender: String
    var event: String
    var dateReceived: Date
    // storing images now
    init(timestamp: Date = Date(), image: Data? = nil, insideimage: Data? = nil, cardName:String = "", sender: String = "", event: String = "", dateReceived: Date = Date()) {
        self.timestamp = timestamp
        self.image = image
        self.insideimage = insideimage
        self.cardName = cardName
        self.sender = sender
        self.event = event
        self.dateReceived = dateReceived
}
}
