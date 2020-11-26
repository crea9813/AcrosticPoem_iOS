//
//  Constant.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/26.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Foundation

final class Constant {
    private let defaults = UserDefaults.standard
    
    static let shared = Constant()
    static let emptyValue = "empty_value"
    
    var token : String {
        get {
            return defaults.string(forKey: Key.token.wrappedValue) ?? ""
        }
        set {
            defaults.set(newValue,forKey: Key.token.wrappedValue)
        }
    }
}

extension Constant {
    
    private enum Key {
        static let token = ConfigurationKey(key: "token")
    }
    
    @propertyWrapper
    struct ConfigurationKey {
        private var key : String
        init(key: String){
            self.key = key
        }
        var wrappedValue: String {
            get {
                key
            }
            set { self.key = newValue }
        }
    }
}
