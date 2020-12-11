//
//  API.swift
//  Bookshelf
//
//  Created by Den Jo on 2020/10/19.
//

import Foundation

enum API: Equatable {
    case autocomplete(keyword: String, page: UInt? = nil)
    case detail(isbn: String)
}

extension API {
    
    var url: URL {
        switch self {
        case .autocomplete(let keyword, let page):    return URL(string: "\(Host.bookshelf(server: server).rawValue)/1.0/search/\(keyword)\(page != nil ? "/\(page!)" : "")")!
        case .detail(let isbn):                       return URL(string: "\(Host.bookshelf(server: server).rawValue)/1.0/books/\(isbn)")!
        }
    }
}
