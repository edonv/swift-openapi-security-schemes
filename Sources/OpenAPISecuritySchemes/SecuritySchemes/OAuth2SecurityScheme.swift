//
//  OAuth2SecurityScheme.swift
//  
//
//  Created by Edon Valdman on 9/15/24.
//

import Foundation
import OpenAPIRuntime
import HTTPTypes

public protocol OAuth2SecurityScheme: BearerHTTPSecurityScheme {
    var implicitFlow: OAuth2Flows.Implicit { get }
    var passwordFlow: OAuth2Flows.Password { get }
    var clientCredentialsFlow: OAuth2Flows.ClientCredentials { get }
    var authorizationCodeFlow: OAuth2Flows.AuthorizationCode { get }
}

private protocol OAuth2FlowBaseProtocol: Hashable, Sendable {
    /// The URL to be used for obtaining refresh tokens.
    ///
    /// The OAuth2 standard requires the use of TLS.
    var refreshURL: URL { get }
    
    /// The available scopes for the OAuth2 security scheme.
    ///
    /// A map between the scope name and a short description for it. The map *MAY* be empty.
    var scopes: [String: String] { get }
}

private protocol OAuth2FlowAuthURLProtocol: OAuth2FlowBaseProtocol {
    /// The authorization URL to be used for this flow.
    ///
    /// The OAuth2 standard requires the use of TLS.
    var authorizationURL: URL { get }
}

private protocol OAuth2FlowTokenURLProtocol: OAuth2FlowBaseProtocol {
    /// The token URL to be used for this flow.
    ///
    /// The OAuth2 standard requires the use of TLS.
    var tokenURL: URL { get }
}

public enum OAuth2Flows {
    public struct Implicit: OAuth2FlowAuthURLProtocol {
        public let authorizationURL: URL
        public let refreshURL: URL
        public let scopes: [String: String]
        
        public init(
            authorizationURL: URL,
            refreshURL: URL,
            scopes: [String: String]
        ) {
            self.authorizationURL = authorizationURL
            self.refreshURL = refreshURL
            self.scopes = scopes
        }
    }
    
    public struct Password: OAuth2FlowTokenURLProtocol {
        public let tokenURL: URL
        public let refreshURL: URL
        public let scopes: [String: String]
        
        public init(
            tokenURL: URL,
            refreshURL: URL,
            scopes: [String: String]
        ) {
            self.tokenURL = tokenURL
            self.refreshURL = refreshURL
            self.scopes = scopes
        }
    }
    
    public struct ClientCredentials: OAuth2FlowTokenURLProtocol {
        public let tokenURL: URL
        public let refreshURL: URL
        public let scopes: [String: String]
        
        public init(
            tokenURL: URL,
            refreshURL: URL,
            scopes: [String: String]
        ) {
            self.tokenURL = tokenURL
            self.refreshURL = refreshURL
            self.scopes = scopes
        }
    }
    
    public struct AuthorizationCode: OAuth2FlowTokenURLProtocol, OAuth2FlowAuthURLProtocol {
        public let tokenURL: URL
        public let authorizationURL: URL
        public let refreshURL: URL
        public let scopes: [String: String]
        
        public init(
            tokenURL: URL,
            authorizationURL: URL,
            refreshURL: URL,
            scopes: [String: String]
        ) {
            self.tokenURL = tokenURL
            self.authorizationURL = authorizationURL
            self.refreshURL = refreshURL
            self.scopes = scopes
        }
    }
}

extension OAuth2SecurityScheme {
    public static var type: SecuritySchemeType { .oauth2 }
}
