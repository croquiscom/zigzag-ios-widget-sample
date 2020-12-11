//
//  Logger.swift
//  Bookshelf
//
//  Created by Den Jo on 2020/10/19.
//

import os.log

enum LogType: String {
    case info    = "[💬]"
    case warning = "[⚠️]"
    case error   = "[‼️]"
}

func log(_ type: LogType = .error, _ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
    var logMessage = ""
    
    // Add file, function name
    if let filename = file.split(separator: "/").map(String.init).last?.split(separator: ".").map(String.init).first {
        logMessage = "\(type.rawValue) [\(filename)  \(function)]\((type == .info) ? "" : " ✓\(line)")"
    }

    os_log("%s", "\(logMessage)  ➜  \(message ?? "")\n ‎‎")
    #endif
}
