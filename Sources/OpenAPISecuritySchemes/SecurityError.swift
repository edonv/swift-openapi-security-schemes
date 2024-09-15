//
//  SecurityError.swift
//
//
//  Created by Edon Valdman on 9/12/24.
//

import Foundation
import HTTPTypes

public struct SecuritySchemeError<S: SecurityScheme>: Error, Hashable, Sendable {
    public let scheme: SecuritySchemeType
    
    public let operationID: String
    
    public let request: HTTPRequest
    
    init(
        scheme: S.Type = S.self,
        operationID: String,
        request: HTTPRequest
    ) {
        self.scheme = S.type
        self.operationID = operationID
        self.request = request
    }
}
