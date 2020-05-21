//
//  Parsing.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/21/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

/// Returns the result of decoding given data by JSONDecoder: AnyPublisher<Output, Failure>.
/// - Parameters:
///   - data: The json data to be decoded.
/// - Returns: The type-erasing  AnyPublisher<Output, Failure> where Output is a generic type and conformable to Decodable protocol. Failure is conformed to Error protocol.
func decode<T: Decodable>(_ data: Data)-> AnyPublisher<T, Error> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error -> APIError in
            print(error)
            return .decoding(detail: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}
