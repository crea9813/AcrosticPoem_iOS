//
//  PoemError.swift
//  Domain
//
//  Created by Supermove on 2023/03/03.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import Foundation

public enum PoemError: Error {
    case apiKeyExpired
    case emptyData
    case decodingFailed
    case unknown
    case with(message: String)
    
    public init(message: String) {
        switch message {
        case "api_key_expired": self = .apiKeyExpired
        case "empty_data": self = .emptyData
        case "decoding_failed": self = .decodingFailed
        default: self = message.isEmpty ? .unknown : .with(message: message)
        }
    }
}
