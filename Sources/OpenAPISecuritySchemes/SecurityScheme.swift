//
//  SecurityScheme.swift
//
//
//  Created by Edon Valdman on 7/17/24.
//

import Foundation

import OpenAPIRuntime
import HTTPTypes

// MARK: - SecurityScheme

/// Don't conform to this protocol directly. Instead, use one of the sub-protocols, depending on the ``type``.
///
/// See also: <https://spec.openapis.org/oas/latest.html#security-scheme-object>
public protocol SecurityScheme {
    /// The type of the security scheme.
    ///
    /// Valid values are "apiKey", "http", "mutualTLS", "oauth2", "openIdConnect".
    static var type: SecuritySchemeType { get }
    
    /// Applies this `SecurityScheme` to an outgoing request.
    /// - Parameters:
    ///   - operationID: The identifier of the outgoing OpenAPI operation.
    ///   - request: The HTTP outgoing request to modify.
    ///   - body: The HTTP outgoing request body to modify, if there is one.
    func applyScheme(
        to operationID: String,
        request: inout HTTPRequest,
        body: inout HTTPBody?
    ) async throws
}

public enum SecuritySchemeType: String, Hashable, Sendable, Codable {
    case apiKey
    case http
    case mutualTLS
    case oauth2
    case openIdConnect
}
