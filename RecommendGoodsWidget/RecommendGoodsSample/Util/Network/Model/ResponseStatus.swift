//
//  ResponseStatus.swift
//  Bookshelf
//
//  Created by Den Jo on 2020/10/19.
//

import Foundation

struct ResponseStatus {
    let code: Int?
    let message: String?
}

extension ResponseStatus {
    
    init(data: Data?, urlResponse: HTTPURLResponse?) {
        guard let data = data, let responseStatus = try? JSONDecoder().decode(ResponseStatus.self, from: data) else {
            message = NSLocalizedString("Please check your network connection or try again.", comment: "")
            code = nil
            return
        }
        
        message = responseStatus.message
        code    = responseStatus.code
    }
}

extension ResponseStatus: Decodable {
    
    private enum Key: String, CodingKey {
        case code
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { code    = try container.decode(Int.self, forKey: .code)       } catch { code = nil }
        do { message = try container.decode(String.self, forKey: .message) } catch { message = nil }
    }
}
