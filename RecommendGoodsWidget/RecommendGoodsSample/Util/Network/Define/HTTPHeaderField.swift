//
//  HTTPHeaderField.swift
//  Bookshelf
//
//  Created by Den Jo on 2020/10/19.
//

import Foundation

enum HTTPHeaderField: String {
    case contentType   = "Content-Type"
    case contentLength = "Content-Length"
    case accept        = "Accept"
    case userAgent     = "User-Agent"
}
