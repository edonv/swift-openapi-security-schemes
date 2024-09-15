//
//  Never+SecurityScheme.swift
//
//
//  Created by Edon Valdman on 7/18/24.
//

import Foundation
import OpenAPIRuntime
import HTTPTypes

extension Never: SecurityScheme {
    public static let type: SecuritySchemeType = .apiKey
    
    public func applyScheme(
        to operationID: String,
        request: inout HTTPTypes.HTTPRequest,
        body: inout OpenAPIRuntime.HTTPBody?
    ) async throws {}
    
    public func validateScheme(
        for operationID: String,
        request: HTTPRequest,
        body: HTTPBody?
    ) async throws {}
}
