//
//  HTTPSecurityScheme.swift
//
//
//  Created by Edon Valdman on 7/17/24.
//

import Foundation
import OpenAPIRuntime
import HTTPTypes

public protocol HTTPSecurityScheme: SecurityScheme {
    /// The name of the HTTP Authorization scheme to be used in the `Authorization` header as defined in [[RFC7235](https://spec.openapis.org/oas/latest.html#bib-RFC7235)].
    ///
    /// The values used SHOULD be registered in the [IANA Authentication Scheme registry](https://www.iana.org/assignments/http-authschemes/http-authschemes.xhtml).
    static var scheme: HTTPSecuritySchemeName { get }
}

extension HTTPSecurityScheme {
    public static var type: SecuritySchemeType { .http }
    public static var headerName: String { "Authorization" }
}

// MARK: - BasicHTTPSecurityScheme

public protocol BasicHTTPSecurityScheme: HTTPSecurityScheme {
    var username: String { get }
    var password: String { get }
}

extension BasicHTTPSecurityScheme {
    public static var scheme: HTTPSecuritySchemeName { .basic }
    
    /// Concatenated as `"{user-id}:{password}".base64EncodedString()`
    private var _credentials: String {
        "\(username):\(password)"
            .data(using: .utf8)!
            .base64EncodedString()
    }
    
    public func applyScheme(
        toOperation operationId: String,
        request: inout HTTPRequest,
        body: inout HTTPBody?
    ) async throws {
        request.headerFields[.authorization] = "Basic \(_credentials)"
    }
}

// MARK: - BearerHTTPSecurityScheme

public protocol BearerHTTPSecurityScheme: HTTPSecurityScheme {
    static var format: HTTPSecuritySchemeName.BearerFormat? { get }
    var accessToken: String { get }
}

extension BearerHTTPSecurityScheme {
    public static var scheme: HTTPSecuritySchemeName { .bearer(format) }
    
    public func applyScheme(
        toOperation operationId: String,
        request: inout HTTPRequest,
        body: inout HTTPBody?
    ) async throws {
        request.headerFields[.authorization] = "Bearer \(accessToken)"
    }
}

public enum HTTPSecuritySchemeName: Hashable, Sendable, Codable {
    case basic
    
    case bearer(BearerFormat?)
    
    public enum BearerFormat: String, Hashable, Sendable, Codable {
        case jwt = "JWT"
    }
}
