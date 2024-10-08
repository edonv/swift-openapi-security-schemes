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
    
    public func validateScheme(
        for operationID: String,
        request: HTTPRequest,
        body: HTTPBody?
    ) async throws {
        switch Self.in {
        case .query:
            // Checks the query for correct scheme
            guard let url = request.url,
                  let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  let items = components.queryItems else { break }
            
            let queryItem = URLQueryItem(name: Self.name, value: self.key)
            guard items.contains(queryItem) else {
                throw SchemeError(operationID: operationID, request: request)
            }
            
        case .header:
            // Checks the header fields for the provided key
            guard request.headerFields.contains(where: {
                $0.name.canonicalName == Self.name
                && $0.value == self.key
            }) else {
                throw SchemeError(operationID: operationID, request: request)
            }
            
        case .cookie:
            // Checks the header fields for the provided key
            guard let cookieField = request.headerFields.cookie?[Self.name],
                  cookieField.value == self.key else {
                throw SchemeError(operationID: operationID, request: request)
            }
        }
    }
}
