//
//  URL+appendQueryItemsBackport.swift
//
//
//  Created by Edon Valdman on 9/12/24.
//

import Foundation

extension URL {
    func appendingBackport(queryItems: [URLQueryItem]) -> URL {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
            return self.appending(queryItems: queryItems)
        } else {
            guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return self }
            
            var items = components.queryItems ?? []
            items.append(contentsOf: queryItems)
            components.queryItems = items
            
            if let newURL = components.url {
                return newURL
            } else {
                return self
            }
        }
    }
    
    mutating func appendBackport(queryItems: [URLQueryItem]) {
        self = self.appendingBackport(queryItems: queryItems)
    }
}
