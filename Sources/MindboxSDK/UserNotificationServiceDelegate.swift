
import Mindbox
import Foundation
import UserNotifications

final public class UserNotificationServiceDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    public let handlerDidTapPushNotificationService: HandlerDidTapPushNotificationService
    
    public init(
        handlerDidTapPushNotificationService: HandlerDidTapPushNotificationService
    ) {
        self.handlerDidTapPushNotificationService = handlerDidTapPushNotificationService
    }
    
    // Receive displayed notifications for iOS 10 devices.
    public func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification,  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handlerDidTapPushNotificationService.handler(with: response)
        completionHandler()
    }
}
