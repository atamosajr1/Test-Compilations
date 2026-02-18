//
//  APIUtils.swift
//  PhotoTest
//
//  Created by JayR Atamosa on 3/9/23.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidResponse
    case invalidInput
    case invalidJSON
    case other(Error)
}

extension AnyPublisher where Output == Data, Failure == Error {
    func jsonObject() -> AnyPublisher<[String: Any], Failure> {
        tryMap { data -> [String: Any] in
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return jsonObject
            }
            
            throw APIError.invalidJSON
        }.eraseToAnyPublisher()
    }
    
    func jsonObjects() -> AnyPublisher<[[String: Any]], Failure> {
        tryMap { data -> [[String: Any]] in
            if let jsonObjects = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return jsonObjects
            }
            
            throw APIError.invalidJSON
        }.eraseToAnyPublisher()
    }
    
    func decode<T: Decodable>(jsonDecoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Failure> {
        tryMap { data -> T in
            return try jsonDecoder.decode(T.self, from: data)
        }.eraseToAnyPublisher()
    }
}
