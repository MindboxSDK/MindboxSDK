
import UserNotifications
import Mindbox
import UIKit

final public class UserNotificationService: NSObject {
    
    // MARK: - DI
    private var notificationCenter  = UNUserNotificationCenter.current()
    private let userNotificationServiceDelegate: UserNotificationServiceDelegate
    
    public init(
        userNotificationServiceDelegate: UserNotificationServiceDelegate
    ) {
        self.userNotificationServiceDelegate = userNotificationServiceDelegate
    }
    
    // MARK: - private methods
    
    private func subscribeDelegates(){
        notificationCenter.delegate = userNotificationServiceDelegate
    }
    
    public func setup(application: UIApplication, completionHandler: @escaping (Bool) -> Void){
        self.subscribeDelegates()
        self.requestUser(
            application: application,
            completionHandler: completionHandler
        )
    }
    
    // MARK: - public methods
    
    public func requestUser(application: UIApplication, completionHandler: @escaping (Bool) -> Void){
        application.applicationIconBadgeNumber = 0
        application.registerForRemoteNotifications()
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        notificationCenter.requestAuthorization(
            options: authOptions,
            completionHandler: { allowed, error in
                completionHandler(allowed)
                print(error?.localizedDescription ?? "localizedDescription nil")
                Mindbox.shared.notificationsRequestAuthorization(granted: allowed)
            })
    }
}
