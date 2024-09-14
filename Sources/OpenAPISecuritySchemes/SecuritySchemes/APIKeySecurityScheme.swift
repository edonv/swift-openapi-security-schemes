//
//  APIKeySecurityScheme.swift
//  
//
//  Created by Edon Valdman on 7/17/24.
//

import Foundation
import OpenAPIRuntime
import HTTPTypes
import HTTPTypesFoundation

import HTTPFieldTypes

public protocol APIKeySecurityScheme: SecurityScheme {
    /// The name of the header, query or cookie parameter to be used.
    static var name: String { get }
    
    /// The location of the API key.
    ///
    /// Valid values are "query", "header" or "cookie".
    static var `in`: APIKeySecuritySchemeLocation { get }
    
    /// The API key.
    var key: String { get }
}

public enum APIKeySecuritySchemeLocation: String, Hashable, Sendable, Codable {
    case query
    case header
    case cookie
}

extension APIKeySecurityScheme {
    public static var type: SecuritySchemeType { .apiKey }
    
    public func applyScheme(
        to operationID: String,
        request: inout HTTPRequest,
        body: inout HTTPBody?
    ) async throws {
        switch Self.in {
        case .query:
            // Adds the scheme to query
            let queryItem = URLQueryItem(name: Self.name, value: self.key)
            request.url?.appendBackport(queryItems: [queryItem])
            
        case .header:
            // Adds the header field with the provided key
            request.headerFields[.init(Self.name)!] = self.key
            
        case .cookie:
            // Adds the key to the Cookie header
            var cookieHeaderValue = request.headerFields.cookie ?? .init([])
            
            let cookie = HTTPCookie(name: Self.name, value: self.key)
            cookieHeaderValue.add(cookie: cookie)
            
            request.headerFields.cookie = cookieHeaderValue
        }
    }
}
