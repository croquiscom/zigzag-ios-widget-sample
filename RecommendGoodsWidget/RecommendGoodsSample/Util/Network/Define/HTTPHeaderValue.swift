//
//  HTTPHeaderValue.swift
//  Bookshelf
//
//  Created by Den Jo on 2020/10/19.
//

import Foundation

enum HTTPHeaderValue {
    case applicationJSON
    case urlEncoded
    case utf8
    case utf8Endcoded
    case applicationJsonUTF8
    case multipart(boundary: String)
}

extension HTTPHeaderValue {
    
    var rawValue: String {
        switch self {
        case .applicationJSON:          return "application/json"
        case .urlEncoded:               return "application/x-www-form-urlencoded"
        case .utf8:                     return "charset=utf-8"
        case .utf8Endcoded:             return "application/x-www-form-urlencoded;charset=utf-8"
        case .applicationJsonUTF8:      return "application/json;charset=utf-8"
        case .multipart(let boundary):  return "multipart/form-data; boundary=\(boundary)"
        }
    }
}
