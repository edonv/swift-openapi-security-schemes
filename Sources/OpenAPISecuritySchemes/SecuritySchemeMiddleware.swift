//
//  SecuritySchemeMiddleware.swift
//
//
//  Created by Edon Valdman on 7/17/24.
//

import Foundation
import OpenAPIRuntime
import HTTPTypes

/// Generic middleware for using with an OpenAPI spec's `securityScheme`.
public protocol SecuritySchemeMiddleware: ClientMiddleware {
    associatedtype Scheme: SecurityScheme
    
    var scheme: Scheme { get }
}
