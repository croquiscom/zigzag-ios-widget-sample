import Foundation

struct ImageURL {
    let url: URL
    let hash: String
}

extension ImageURL {
    
    init?(url: URL?, hash: Int) {
        guard let url = url else { return nil }
        self.url  = url
        self.hash = "\(hash)"
    }
}

extension ImageURL: Hashable {
    
    var rawValue: String {
        return "\(url.absoluteString)\(hash)"
    }
    
    var absoluteString: NSString {
        return url.absoluteString as NSString
    }
}

extension ImageURL: Equatable {
    
    static func == (lhs: ImageURL, rhs: ImageURL) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
