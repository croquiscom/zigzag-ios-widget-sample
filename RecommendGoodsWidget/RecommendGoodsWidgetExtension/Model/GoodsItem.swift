import UIKit

final class GoodsItem {
    let imageUrl: String
    let productUrl: String
    let title: String

    convenience init?(jsonObject: [String: Any]) {
        guard let imageUrl = jsonObject["image_url"] as? String,
              let productUrl = jsonObject["product_url"] as? String,
              let title = jsonObject["title"] as? String else {
            return nil
        }
        self.init(imageUrl: imageUrl, productUrl: productUrl, title: title)
    }

    init(imageUrl: String, productUrl: String, title: String) {
        self.imageUrl = imageUrl
        self.productUrl = productUrl
        self.title = title
    }
}

extension GoodsItem {
    static let first = GoodsItem(imageUrl: "https://cf.goods-image.s.alpha.zigzag.kr/thumb/01294/12945297.jpg?h=6cb9e76522",
                                 productUrl: "https://attrangs.co.kr/shop/view.php?index_no=59245&enterc=zig",
                                 title: "Sample 1")

    static let second = GoodsItem(imageUrl: "https://cf.goods-image.s.alpha.zigzag.kr/thumb/01297/12973025.jpg?h=01dbbc3217",
                                  productUrl: "https://attrangs.co.kr/shop/view.php?index_no=59309&enterc=zig",
                                  title: "Sample 2")

    static let third = GoodsItem(imageUrl: "https://cf.goods-image.s.alpha.zigzag.kr/thumb/01055/10553347.jpg?h=4771fbac4a",
                                 productUrl: "http://www.66girls.co.kr/product/detail.html?product_no=95700&mmkpl1=erudazig",
                                 title: "Sample 3")
}
