//
//  RequestBuilder.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/13/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol RequestBuilderProtocol {
    func buildRequest(from endpoint: EndpointType)-> URLRequest
}

struct RequestBuilder: RequestBuilderProtocol {
    /// Returns the URLRequest based on given enumeration case.
    /// - Parameters:
    ///   - endpoint: The instance of EndpointType.
    /// - Returns: The produced URLRequest.
    public func buildRequest(from endpoint: EndpointType)-> URLRequest {
        var request = URLRequest(url: endpoint.baseUrl.appendingPathComponent(endpoint.path))
        request.httpMethod = endpoint.method.rawValue
        addQueryParameters(endpoint.task, request: &request)
        addAdditionalHeaders(endpoint.headers, request: &request)
        addBodyParameters(endpoint.body, request: &request)
        return request
    }
    /// Returns the URLRequest with given query parameters.
    /// - Parameters:
    ///   - queryParameters: Dictionary <String, String> to be added to the request.
    ///   - request: URLRequest to be changed.
    /// - Returns: URLRequest with added query paramters.
    fileprivate func addQueryParameters(_ queryParameters: HTTPQueryParameters?,
                                         request: inout URLRequest) {
        guard
            let parameters = queryParameters,
            var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) else {
                return
        }
        
        urlComponents.queryItems = parameters.compactMap({ (value) -> URLQueryItem? in
            return URLQueryItem(name: value.key, value: value.value)
        })
        
        if let unwrappedURL = urlComponents.url {
            request.url = unwrappedURL
        }
    }
    /// Returns the URLRequest with given additional headers.
    /// - Parameters:
    ///   - additionalHeaders: Dictionary <String, String> to be added to the request.
    ///   - request: URLRequest to be changed.
    /// - Returns: URLRequest with added headers.
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    /// Returns the URLRequest with given body parameters.
    /// - Parameters:
    ///   - bodyParameters: Dictionary <String, String> to be added to the request.
    ///   - request: URLRequest to be changed.
    /// - Returns: URLRequest with added body parameters.
    fileprivate func addBodyParameters(_ bodyParameters: HTTPBodyParameters?, request: inout URLRequest) {
        guard let parameters = bodyParameters else { return }
        request.httpBody = parameters.map{ "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
       }
    
}

