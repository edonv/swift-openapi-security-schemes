//
//  OAuthSecurityScheme.swift
//  
//
//  Created by Edon Valdman on 9/15/24.
//

import Foundation
import OpenAPIRuntime
import HTTPTypes

public protocol OAuthSecurityScheme: BearerHTTPSecurityScheme {
    var implicitFlow: OAuthFlows.Implicit { get }
    var passwordFlow: OAuthFlows.Password { get }
    var clientCredentialsFlow: OAuthFlows.ClientCredentials { get }
    var authorizationCodeFlow: OAuthFlows.AuthorizationCode { get }
}

private protocol OAuthFlowBaseProtocol: Hashable, Sendable {
    /// The URL to be used for obtaining refresh tokens.
    ///
    /// The OAuth2 standard requires the use of TLS.
    var refreshURL: URL { get }
    
    /// The available scopes for the OAuth2 security scheme.
    ///
    /// A map between the scope name and a short description for it. The map *MAY* be empty.
    var scopes: [String: String] { get }
}

private protocol OAuthFlowAuthURLProtocol: OAuthFlowBaseProtocol {
    /// The authorization URL to be used for this flow.
    ///
    /// The OAuth2 standard requires the use of TLS.
    var authorizationURL: URL { get }
}

private protocol OAuthFlowTokenURLProtocol: OAuthFlowBaseProtocol {
    /// The token URL to be used for this flow.
    ///
    /// The OAuth2 standard requires the use of TLS.
    var tokenURL: URL { get }
}

public enum OAuthFlows {
    public struct Implicit: OAuthFlowAuthURLProtocol {
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
    
    public struct Password: OAuthFlowTokenURLProtocol {
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
    
    public struct ClientCredentials: OAuthFlowTokenURLProtocol {
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
    
    public struct AuthorizationCode: OAuthFlowTokenURLProtocol, OAuthFlowAuthURLProtocol {
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

extension OAuthSecurityScheme {
    public static var type: SecuritySchemeType { .oauth2 }
}
