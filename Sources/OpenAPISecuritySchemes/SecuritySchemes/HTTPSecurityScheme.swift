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
        "Basic " + "\(username):\(password)"
            .data(using: .utf8)!
            .base64EncodedString()
    }
    
    public func applyScheme(
        toOperation operationID: String,
        request: inout HTTPRequest,
        body: inout HTTPBody?
    ) async throws {
        request.headerFields[.authorization] = _credentials
    }
}

// MARK: - BearerHTTPSecurityScheme

public protocol BearerHTTPSecurityScheme: HTTPSecurityScheme {
    /// A hint to the client to identify how the bearer token is formatted.
    ///
    /// Bearer tokens are usually generated by an authorization server, so this information is primarily for documentation purposes.
    ///
    /// This defaults to `nil`.
    static var bearerFormat: HTTPSecuritySchemeName.BearerFormat? { get }
    
    /// The OAuth2-generated access token used to authorize requests.
    var accessToken: String { get }
}

extension BearerHTTPSecurityScheme {
    static var bearerFormat: HTTPSecuritySchemeName.BearerFormat? { nil }
    public static var scheme: HTTPSecuritySchemeName { .bearer(bearerFormat) }
    
    /// `access_token`
    ///
    /// `BearerFormat` is a hint to the client to identify how the bearer token is formatted.
    ///
    /// Bearer tokens are usually generated by an authorization server, so this information is primarily for documentation purposes.
    ///
    /// add option to pass the token in the header (default), form-encoded body parameter (only if Content-Type == `application/x-www-form-urlencoded`, method is not GET, https://datatracker.ietf.org/doc/html/rfc6750#section-2.2), or query parameter (`access_token` query field, with `Cache-Control` header set to `no-store`)
    private var _credentials: String {
//        switch self.location {
//        case .header:
        return "Bearer \(accessToken)"
//        case .formEncodedBody:
//
//        case .queryParameter:
//
//        }
    }
    
    public func applyScheme(
        toOperation operationID: String,
        request: inout HTTPRequest,
        body: inout HTTPBody?
    ) async throws {
//        switch self.location {
//        case .header:
        request.headerFields[.authorization] = _credentials
//        case .formEncodedBody:
//
//        case .queryParameter:
//
//        }
    }
}

public enum HTTPSecuritySchemeName: Hashable, Sendable, Codable {
    case basic
    
    case bearer(BearerFormat?)
    
    public enum BearerFormat: String, Hashable, Sendable, Codable {
        case jwt = "JWT"
    }
}
