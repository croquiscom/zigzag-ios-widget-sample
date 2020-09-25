import Foundation
import Alamofire

final class NetworkManager {
    static var pageInfoQuery: String {
        return """
            query($page_id: String!) {
              page_info(page_id: $page_id) {
                    ui_item_list {
                    ... on UxGoodsCardItem {
                        image_url
                        product_url
                        title
                        price
                        zpay
                        log
                        aid
                      }
                  }
              }
            }
            """
    }

    static var pageInfoVariables: [String: Codable] {
        return ["page_id": "home_best"]
    }

    static func loadPageItems(completion: @escaping (Result<[GoodsItem], AFError>) -> Void) {
        var param: [String: Any] = [:]
        param["query"] = pageInfoQuery
        param["variables"] = pageInfoVariables
        param["ts"] = Date().timeIntervalSince1970 * 1000

        var header: HTTPHeaders {
            var headers: [String: String] = [:]
            headers["Croquis-Client-Version"] = "6.28.0"

            return HTTPHeaders(headers)
        }

        let req = AF.request("https://api.alpha.zigzag.kr/api/2/graphql",
                             method: .post,
                             parameters: param,
                             encoding: JSONEncoding.default,
                             headers: header)

        req.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = jsonObject["data"] as? [String: Any],
                       let pageInfo = data["page_info"] as? [String: Any],
                       let itemList = pageInfo["ui_item_list"] as? [[String: Any]] {
                        let goodsItems = itemList.compactMap(GoodsItem.init)
                        completion(.success(goodsItems))
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(.explicitlyCancelled))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
