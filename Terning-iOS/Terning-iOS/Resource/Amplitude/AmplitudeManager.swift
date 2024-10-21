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
        let eventType: String = eventType.rawValue
        
        AmplitudeManager.shared.track(eventType: eventType, eventProperties: eventProperties, options: nil)
    }
}
