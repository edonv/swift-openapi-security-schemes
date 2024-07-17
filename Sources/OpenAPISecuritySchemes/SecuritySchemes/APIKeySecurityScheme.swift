//
//  APIKeySecurityScheme.swift
//  
//
//  Created by Edon Valdman on 7/17/24.
//

import Foundation

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

extension APIKeySecurityScheme {
    public static var type: SecuritySchemeType { .apiKey }
}

public enum APIKeySecuritySchemeLocation: String, Hashable, Sendable, Codable {
    case query
    case header
    case cookie
}

// MARK: - SecuritySchemeMiddleware
import OpenAPIRuntime
import HTTPTypes

extension SecuritySchemeMiddleware where Scheme: APIKeySecurityScheme {
    internal func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        
        switch Scheme.in {
        case .query:
            var path = request.path ?? ""
            if path.contains("?") {
                path.append("&")
            } else {
                path.append("?")
            }
            
            path.append("\(Scheme.name)=\(self.scheme.key)")
            
        case .header:
            // Adds the header field with the provided key
            request.headerFields[.init(Scheme.name)!] = self.scheme.key
            
        case .cookie:
            request.headerFields[.cookie] = self.scheme.key
        }
        
        return try await next(request, body, baseURL)
    }
}
