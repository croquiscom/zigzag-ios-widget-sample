//
//  URLRequestExtension.swift
//  Bookshelf
//
//  Created by Den Jo on 2020/10/19.
//

import Foundation
import CommonCrypto
import UIKit

extension URLRequest {
    
    // MARK: - Initializer
    init(httpMethod: HTTPMethod, url: API) {
        self.init(httpMethod: httpMethod, url: url.url)
    }
    
    init(url: ImageURL) {
        self.init(url: url.url)
    }
    
    init(httpMethod: HTTPMethod, url: URL) {
        self.init(url: url)
        
        // Set request
        self.httpMethod = httpMethod.rawValue
        timeoutInterval = 90.0
        
        guard let host = url.host, server.rawValue.contains(host) else { return }
        let os         = "iOS"
        let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        
        let userAgent = "AppName Bookshelf; OS \(os); BundleIdentifier \(Bundle.main.bundleIdentifier ?? ""); AppVersion \(appVersion); SystemVersion \(UIDevice.current.systemVersion); DeviceModel \(UIDevice.current.model);"
        setValue(userAgent, forHTTPHeaderField: HTTPHeaderField.userAgent.rawValue)
        setValue("gzip",    forHTTPHeaderField: "Accept-Encoding")
        
        guard let systemLanguageCode = Locale.preferredLanguages.first else { return }
        setValue(systemLanguageCode, forHTTPHeaderField: "Accept-Language")
    }
    
    
    // MARK: - Function
    mutating func add(value: HTTPHeaderValue, field: HTTPHeaderField) {
        addValue(value.rawValue, forHTTPHeaderField: field.rawValue)
    }
    
    mutating func add(value: String, field: HTTPHeaderField) {
        addValue(value, forHTTPHeaderField: field.rawValue)
    }
}
 

extension URLRequest {
    
    var debugDescription: String {
        return """
               Request
               URL
               \(httpMethod ?? "") \(url?.absoluteString ?? "")\n
               HeaderField
               \(allHTTPHeaderFields?.debugDescription ?? "")\n
               Body
               \(String(data: httpBody ?? Data(), encoding: .utf8) ?? "")
               \n\n
               """
    }
}
