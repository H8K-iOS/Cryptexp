import Foundation
import SwiftUI

final class HapticManager {
     static private let genrator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        genrator.notificationOccurred(type)
    }
}
