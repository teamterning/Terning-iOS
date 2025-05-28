//
//  UserDefaultWrapper.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation

@propertyWrapper struct UserDefaultWrapper<T> {
    
    var wrappedValue: T? {
        get {
            return UserDefaults.standard.object(forKey: self.key) as? T
        }
        
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else { UserDefaults.standard.setValue(newValue, forKey: key) }
        }
    }
    
    private let key: String
    
    init(key: String) {
        self.key = key
    }
}

@propertyWrapper
struct NonOptionalUserDefaultWrapper<T> {
    private let key: String
    private let defaultValue: T

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
