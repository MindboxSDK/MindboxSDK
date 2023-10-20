
import Mindbox
import UserNotifications

final public class HandlerDidTapPushNotificationService {
	
	public var presentAdvertising: ((PushModel) -> Void)?
	
	public var pushModel: PushModel?
	
	public func handler(with response: UNNotificationResponse){
		let userInfo = response.notification.request.content.userInfo
		guard let pushModel = parse(with: userInfo) else { return }
		Mindbox.shared.pushClicked(response: response)
		if self.presentAdvertising == nil {
			self.pushModel = pushModel
		} else {
			self.presentAdvertising?(pushModel)
		}
	}
	
	private func parse(with userInfo: [AnyHashable : Any]) -> PushModel? {
		
		let pushType = PUSHType(with: userInfo)
		
		var pushModel = PushModel(
			homeUrl: nil,
			clickUrl: nil,
			pathUrl: nil,
			pushType: pushType
		)
		
		switch pushType {
			case .homeReturnURL(let homeUrl, let clickUrlString):
				pushModel.homeUrl = homeUrl
				pushModel.clickUrl = clickUrlString
				
			case .addPathHomeReturnURL(let homeUrl, let pathUrl):
				pushModel.homeUrl = homeUrl
				pushModel.pathUrl = pathUrl
				
			case .addPath(let pathUrl):
				pushModel.pathUrl = pathUrl
				
			case .simple(let clickUrl):
				pushModel.clickUrl = clickUrl
				
			case .telegram(let clickUrl):
				pushModel.clickUrl = clickUrl
				
			case .none:
				break
		}
		
		return pushModel
	}
	
	public struct PushModel {
		public var homeUrl: URL?
		public var clickUrl: URL?
		public var pathUrl: String?
		public let pushType: PUSHType
		
		public init(
			homeUrl: URL?,
			clickUrl: URL?,
			pathUrl: String?,
			pushType: PUSHType
		) {
			self.homeUrl = homeUrl
			self.clickUrl = clickUrl
			self.pathUrl = pathUrl
			self.pushType = pushType
		}
	}
	
	public enum PUSHType {
		case homeReturnURL(URL, URL)
		case addPathHomeReturnURL(URL, String)
		case addPath(String)
		case simple(URL)
		case telegram(URL)
		case none
		
		public init(with userInfo: [AnyHashable : Any]) {
			let payload = (userInfo["payload"] as? String) ?? ""
			let clickUrlString = (userInfo["clickUrl"] as? String) ?? ""
			
			if payload.hasPrefix("http"), let homeUrl = URL(string: payload), clickUrlString.hasPrefix("http"), let clickUrlString = URL(string: clickUrlString)  {
				self = .homeReturnURL(homeUrl, clickUrlString)
			} else if !clickUrlString.hasPrefix("http"), !clickUrlString.isEmpty, payload.isEmpty  {
				self = .addPath(clickUrlString)
			} else if !clickUrlString.hasPrefix("http"), let homeUrl = URL(string: payload), !clickUrlString.isEmpty  {
				self = .addPathHomeReturnURL(homeUrl, clickUrlString)
			} else if let clickUrl = URL(string: clickUrlString), !clickUrl.isTelegram() {
				self = .simple(clickUrl)
			} else if let clickUrl = URL(string: clickUrlString), clickUrl.isTelegram() {
				self = .telegram(clickUrl)
			} else {
				self = .none
			}
		}
	}
	
	
	public init() {}
}
