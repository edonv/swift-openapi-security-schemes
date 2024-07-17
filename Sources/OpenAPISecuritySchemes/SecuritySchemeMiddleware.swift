//
//  SecuritySchemeMiddleware.swift
//
//
//  Created by Edon Valdman on 7/17/24.
//

import Foundation
import OpenAPIRuntime

public protocol SecuritySchemeMiddleware: ClientMiddleware {
    associatedtype Scheme: SecurityScheme
    
    var scheme: Scheme { get }
}
