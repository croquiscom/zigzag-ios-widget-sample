//
//  Response.swift
//  Bookshelf
//
//  Created by Den Jo on 2020/10/19.
//

import Foundation

struct Response {
    let url: URL
    let headerFields: [AnyHashable : Any]
    var data: Data?                = nil
    var code: Int?                 = nil
    var message: String?           = nil
    var statusCode: HTTPStatusCode = .none
}

extension Response {
    
    init?(data: Data?, urlResponse: URLResponse?, error: Error?) {
        guard let urlResponse = urlResponse as? HTTPURLResponse, let url = urlResponse.url else { return nil }
        
        self.url          = url
        self.headerFields = urlResponse.allHeaderFields
        self.data         = data
        
        guard error == nil else {
            statusCode = .badRequest
            message    = NSLocalizedString("Please check your network connection or try again.", comment: "")
            return
        }
    
        statusCode = HTTPStatusCode(rawValue: urlResponse.statusCode) ?? .none
        message    = statusCode.isSuccess == true ? nil : NSLocalizedString("Please check your network connection or try again.", comment: "")
        
        
        guard let data = data, let responseStatus = try? JSONDecoder().decode(ResponseStatus.self, from: data) else { return }
        message = message ?? responseStatus.message
        code    = responseStatus.code
    }
}

extension Response: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return """
                Response
                HTTP status: \(statusCode.rawValue)
                URL: \(url.absoluteString)\n
                HeaderField
                \(headerFields.debugDescription))\n
                Data
                \(String(data: data ?? Data(), encoding: .utf8) ?? "")
                \n
                """
    }
}
