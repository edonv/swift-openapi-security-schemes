//
//  SecurityError.swift
//
//
//  Created by Edon Valdman on 9/12/24.
//

import Foundation

public enum SecurityError: Error, Hashable, Sendable {
    case invalidSecurity(operationID: String)
}
