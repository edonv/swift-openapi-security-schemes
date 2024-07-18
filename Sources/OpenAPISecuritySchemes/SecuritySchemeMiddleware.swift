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
    associatedtype Scheme: SecurityScheme = Never
    
    var scheme: Scheme? { get }
}

extension SecuritySchemeMiddleware where Scheme == Never {
    public var scheme: Never? { nil }
}

// MARK: - SecuritySchemeMiddlewareDelegate

public protocol SecuritySchemeMiddlewareDelegate: AnyObject {
    /// Asks the delegate what security scheme to use for any given operation.
    ///
    /// Because the return type uses `any`, you can use this function to return different schemes for different operations.
    ///
    /// This can be used in conjunction with ``SecuritySchemeMiddleware/scheme-21xl3``. This function's return value takes precendence over ``SecuritySchemeMiddleware/scheme-21xl3``, unless this returns `nil`.
    ///
    /// If `nil` is returned, no scheme will be applied.
    /// - Parameters:
    ///   - middleware: The ``SecuritySchemeMiddleware`` that this delegate belongs to..
    ///   - operationId: The identifier of the OpenAPI operation in question.
    /// - Returns: A ``SecurityScheme`` to apply to this operation, or `nil` to not apply any scheme.
    func securityScheme(
        _ middleware: any SecuritySchemeMiddleware,
        forOperation operationId: String
    ) -> (any SecurityScheme)?
}
