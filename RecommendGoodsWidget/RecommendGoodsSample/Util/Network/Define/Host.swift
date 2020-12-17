//
//  Host.swift
//  Bookshelf
//
//  Created by Den Jo on 2020/10/19.
//

import Foundation

var server: Host.Server = .stage

enum Host {
    enum Server {
        case development
        case stage
        case production
    }
    
    case bookshelf(server: Server)
}

extension Host {
   
    // Raw value
    var rawValue: String {
        switch self {
    #if DEBUG
        case .bookshelf(let server):  return server.rawValue
        
    #else
        case .bookshelf(_):           return "https://api.itbook.store"
    #endif
        }
    }
    
    
    // URL
    var url: URL {
        return URL(string: self.rawValue)!
    }
    
    
    init?(rawValue: String?) {
        guard let rawValue = rawValue else { return nil }
        
        switch rawValue {
    #if DEBUG
        case Host.bookshelf(server: .development).rawValue:   self = .bookshelf(server: .development)
        case Host.bookshelf(server: .stage).rawValue:         self = .bookshelf(server: .stage)
        case Host.bookshelf(server: .production).rawValue:    self = .bookshelf(server: .production)
            
    #else
        case Host.bookshelf(server: .development).rawValue:   self = .bookshelf(server: .production)
        case Host.bookshelf(server: .stage).rawValue:         self = .bookshelf(server: .production)
        case Host.bookshelf(server: .production).rawValue:    self = .bookshelf(server: .production)
    #endif
        
        default:                                              return nil
        }
    }
}

extension Host.Server {
    
    var rawValue: String {
        switch self {
        #if DEBUG
        case .development: return "https://api.itbook.store"
        case .stage:       return "https://api.itbook.store"
        case .production:  return "https://api.itbook.store"
        
        #else
        case .development: return "https://api.itbook.store"
        case .stage:       return "https://api.itbook.store"
        case .production:  return "https://api.itbook.store"
        #endif
        }
    }
}

extension Host.Server: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension Host.Server: CustomDebugStringConvertible {
    
    var debugDescription: String {
        #if DEBUG
        switch self {
        case .development:  return "Development server"
        case .stage:        return "Stage server"
        case .production:   return "Production server"
        }
        
        #else
        return ""
        #endif
    }
}
