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

public enum APIKeySecuritySchemeLocation: String, Hashable, Sendable, Codable {
    case query
    case header
    case cookie
}

extension APIKeySecurityScheme {
    public static var type: SecuritySchemeType { .apiKey }
}
