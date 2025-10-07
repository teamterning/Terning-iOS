//
//  AmplitudeManager.swift
//  Terning-iOS
//
//  Created by 이명진 on 10/17/24.
//

import Foundation
import AmplitudeSwift

public struct AmplitudeManager {
    static public let shared = Amplitude(configuration: Configuration(apiKey: Config.AMPLITUDE_API_KEY))
    
    private init() {}
}

public extension Amplitude {
    func track(eventType: AmplitudeEventType, eventProperties: [String: Any]? = nil) {
        #if DEBUG
        // Debug 모드에서는 로깅하지 않음
        return
        #else
        let eventType: String = eventType.rawValue
        AmplitudeManager.shared.track(eventType: eventType, eventProperties: eventProperties)
        #endif
    }
}
