//
//  NetworkError.swift
//  BookShelf
//
//  Created by Den Jo on 2020/10/31.
//

import Foundation

struct NetworkError {
    let code: Int?
    let statusCode: HTTPStatusCode
    
    private let message: String?
}

extension NetworkError {
    
    init(message: String?) {
        self.message = message
        
        code       = nil
        statusCode = .none
    }
    
    init(data: Response) {
        code       = data.code
        message    = data.message
        statusCode = data.statusCode
    }
}

extension NetworkError: LocalizedError {
    
    public var localizedDescription: String? {
        return message
    }

    public var errorDescription: String? {
        return message
    }
    
    public var failureReason: String? {
        return message
    }
}
