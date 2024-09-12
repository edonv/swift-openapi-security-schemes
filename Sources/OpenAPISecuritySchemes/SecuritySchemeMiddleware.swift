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
    /// The type of `SecurityScheme` this middleware uses.
    ///
    /// It defaults to `Never`.
    associatedtype Scheme: SecurityScheme = Never
    
    /// An optional delegate that can be used to check if the scheme should be applied to an operation on a case-by-case basis.
    ///
    /// If used, the conforming middleware type should be a `class`, and this should be a `weak var`.
    ///
    /// If this and ``scheme-21xl3`` are both set, the scheme returned by ``SecuritySchemeMiddlewareDelegate/securityScheme(_:forOperation:)`` takes precedence over ``scheme-21xl3``. If the delegate function returns `nil`, then ``scheme-21xl3`` is used (if itself is non-`nil`).
    var delegate: (any SecuritySchemeMiddlewareDelegate)? { get set }
    
    /// An instance of the ``SecurityScheme`` to use for all operations.
    ///
    /// If `nil`, it won't apply a scheme to operation calls, unless ``delegate`` is set to a non-`nil` value.
    ///
    /// When ``Scheme`` is set to `Never`, this value is automatically set to `nil`.
    var scheme: Scheme? { get }
}

extension SecuritySchemeMiddleware where Scheme == Never {
    public var scheme: Never? { nil }
}

// MARK: - ClientMiddleware

extension SecuritySchemeMiddleware {
    /// Gets the security scheme to use for a given operation.
    ///
    /// This tries to use ``delegate`` first, but if it's either `nil` or its ``SecuritySchemeMiddlewareDelegate/securityScheme(_:forOperation:)`` function returns `nil`, it will fall back on ``scheme-21xl3``. If that is also `nil`, then no scheme is applied to the operation at all.
    private func _getScheme(for operationID: String) -> (any SecurityScheme)? {
        if let delegate,
           let operationScheme = delegate.securityScheme(self, forOperation: operationID) {
            return operationScheme
        } else if let scheme {
            return scheme
        } else {
            return nil
        }
    }
    
    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        // Apply security scheme to request before it is sent
        var request = request
        var body = body
        
        if let scheme = _getScheme(for: operationID) {
            try await scheme.applyScheme(to: operationID, request: &request, body: &body)
        }
        
        return try await next(request, body, baseURL)
    }
}

// MARK: - SecuritySchemeMiddlewareDelegate

public protocol SecuritySchemeMiddlewareDelegate: AnyObject, Sendable {
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
