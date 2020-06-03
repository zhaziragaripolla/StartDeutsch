//
//  APIClient.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/13/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

protocol APIClientProtocol{
    var session: URLSession { get }
    func get<T>(from endpoint: EndpointType) -> AnyPublisher<T, Error> where T: Decodable
}

final class APIClient: APIClientProtocol{

    let session: URLSession
    let requestBuilder: RequestBuilderProtocol
    let userDefaults = UserDefaults.standard

    private lazy var tokenRequest: URLRequest = {
        return requestBuilder.buildRequest(from: StartDeutschEndpoint.postToken)
    }()
    
    init(requestBuilder: RequestBuilderProtocol, session: URLSession = URLSession.shared){
        self.session = session
        self.requestBuilder = requestBuilder
    }

    /// Returns the result of making a call to a given endpoint.
    /// - Parameters:
    ///   - endpoint: The instance of EndpointType to make a call.
    /// - Returns: The result as a Publisher with Output of specified type T and Error.
    func get<T: Decodable>(from endpoint: EndpointType) -> AnyPublisher<T, Error> {
        var request = requestBuilder.buildRequest(from: endpoint)
        if let token = userDefaults.object(forKey: "token") as? String{
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return fetch(request).eraseToAnyPublisher()
    }

    /// Returns the result of executing and processing given request: AnyPublisher<Output, Failure>.
    /// - Parameters:
    ///   - request: The URLRequest to be executed by URLSession.
    /// - Returns: The type-erasing  AnyPublisher<Output, Failure> where Output of generic type T (conformable to Decodable protocol). Failure is conformed to Error protocol.
    fileprivate func fetch<T>(_ request: URLRequest) -> AnyPublisher<T, Error> where T: Decodable{
        return execute(request)
            .flatMap(maxPublishers: .max(1)){ data in decode(data) }
            .tryCatch{ error -> AnyPublisher<T, Error> in
                guard let apiError = error as? APIError,
                    apiError == .networking(statusCode: 401, detail: "") else {
                        throw error
                }
                print("Catching error: 401. Refreshing token🤔")
                return self.refreshToken()
                    .tryMap{ [unowned self] token-> AnyPublisher<T, Error> in
                        print("New token \(token.accessToken)!")
                        self.userDefaults.set(token.accessToken, forKey: "token")
                        var newRequest = request
                        newRequest.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
                        return self.fetch(newRequest)
            }.switchToLatest().eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }    
    
    /// Returns the result of refreshing token request : AnyPublisher<Output, Failure>.
    /// - Returns: The type-erasing  AnyPublisher<Output, Failure> where Output is a Token model(conformed to Decodable protocol). Failure is conformed to Error protocol.
    fileprivate func refreshToken() -> AnyPublisher<Token, Error> {
        sign(request: &tokenRequest)
        return execute(tokenRequest)
            .flatMap(maxPublishers: .max(1)){ data in decode(data) }
            .eraseToAnyPublisher()
    }
    
    /// Returns the signed request.
    /// - Parameters:
    /// - request: URLRequest to be signed.
    /// - Returns: URLRequest with authorization headers.
    fileprivate func sign(request: inout URLRequest){
        if let base64encoded = "\(Environment.clientId):\(Environment.clientSecret)".base64Encoded {
            request.addValue("Basic \(base64encoded)", forHTTPHeaderField: "Authorization")
        }
    }

    /// Returns the result of executing given request by URLSession: AnyPublisher<Output, Failure>.
    /// - Parameters:
    ///   - request: The URLRequest to be executed by URLSession.
    /// - Returns: The type-erasing  AnyPublisher<Output, Failure> where Output is a Data. Failure is conformed to Error protocol.
    fileprivate func execute(_ request: URLRequest)->AnyPublisher<Data, Error>{
        session.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap{
                data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.networking(statusCode: httpResponse.statusCode,
                                              detail: String(data:data, encoding: .utf8) ?? "")
                }
                print(String(data: data, encoding: .utf8)!)
                return data
            }
        .eraseToAnyPublisher()
    }

}



