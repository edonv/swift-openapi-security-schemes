//
//  SecurityScheme.swift
//
//
//  Created by Edon Valdman on 7/17/24.
//

import Foundation

// MARK: - SecurityScheme

/// Don't conform to this protocol directly. Instead, use one of the sub-protocols, depending on the ``type``.
///
/// See also: <https://spec.openapis.org/oas/latest.html#security-scheme-object>
public protocol SecurityScheme {
    /// The type of the security scheme.
    ///
    /// Valid values are "apiKey", "http", "mutualTLS", "oauth2", "openIdConnect".
    static var type: SecuritySchemeType { get }
    
    /// A description for security scheme.
    ///
    /// CommonMark syntax MAY be used for rich text representation.
    static var description: String? { get }
}

extension SecurityScheme {
    static public var description: String? { nil }
}

public enum SecuritySchemeType: String, Hashable, Sendable, Codable {
    case apiKey
    case http
    case mutualTLS
    case oauth2
    case openIdConnect
}
