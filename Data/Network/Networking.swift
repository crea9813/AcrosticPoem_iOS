//
//  Networking.swift
//  Data
//
//  Created by Supermove on 2023/03/03.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import Moya

final class Network<Target: TargetType>: MoyaProvider<Target> {
    
    init(plugins: [PluginType] = [/*NetworkLoggerPlugin()*/]) {
        let session = MoyaProvider<Target>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        session.sessionConfiguration.timeoutIntervalForResource = 10
        super.init(session: session, plugins: plugins)
    }
    
    func request(
        _ target: Target,
        _ timeout : Int = 8,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        
        return self.rx.request(target)
            .catchAPIError(PoemError.self)
            .do(
                onSuccess: { value in
                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                    print(message)
                },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                            print(message)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            print(message)
                        } else {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))"
                            print(message)
                        }
                    } else {
                        let message = "FAILURE: \(requestString)\n\(error)"
                        print(message)
                    }
                },
                onSubscribed: {
                    let message = "REQUEST: \(requestString)"
                    print(message)
                }
            )
        }
}


extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func catchAPIError(_ type: PoemError.Type) -> Single<Element> {
        return flatMap { response in
            guard (200...299).contains(response.statusCode) else {
                throw PoemError.unknown
            }
            
            return .just(response)
            
        }
    }
}
