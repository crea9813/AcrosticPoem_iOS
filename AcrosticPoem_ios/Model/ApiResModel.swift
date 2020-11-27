//
//  ApiResModel.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/18.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Foundation

class ApiResModel : Codable {
    var result : String? = nil
    var statusCode : Int = 0
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = (try? container.decode(Int.self, forKey: .statusCode)) ?? -1
        result = try? container.decode(String.self, forKey: .result)
    }
    
    private enum CodingKeys: String, CodingKey {
        case statusCode
        case result
    }
}
