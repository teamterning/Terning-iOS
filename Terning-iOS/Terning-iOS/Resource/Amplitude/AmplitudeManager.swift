//
//  AmplitudeManager.swift
//  Terning-iOS
//
//  Created by 이명진 on 10/17/24.
//

import Foundation
import AmplitudeSwift

public struct AmplitudeManager {
    static public let shared: Amplitude = {
        // DEBUG 모드 체크
        #if DEBUG
        let isDebugMode = true
        #else
        let isDebugMode = false
        #endif
        
        // Configuration 생성 (DEBUG 모드에서는 optOut 활성화)
        let configuration = Configuration(
            apiKey: Config.AMPLITUDE_API_KEY,
            optOut: isDebugMode  // DEBUG 모드에서는 추적 완전 비활성화
        )
        
        // DEBUG 모드 로그
        if isDebugMode {
            print("🔍 [DEBUG] Amplitude 추적 비활성화됨 (optOut: true)")
        }
        
        return Amplitude(configuration: configuration)
    }()
    
    private init() {}
}

public extension Amplitude {
    func track(eventType: AmplitudeEventType, eventProperties: [String: Any]? = nil) {
        #if DEBUG
        print("🔍 [DEBUG] Amplitude 이벤트: \(eventType.rawValue)")
        #endif
        
        let eventType: String = eventType.rawValue
        AmplitudeManager.shared.track(eventType: eventType, eventProperties: eventProperties)
        #endif
    }
}