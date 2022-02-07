
import Foundation

struct Book: Codable {
    let id: Int
    let title: String
    let desc: String
    let link: String
    let date: Date
    
    // 서버쪽키와 내가 decoding할 키의 형식이 가르기 때문에 Custom Mapping을 해준다.
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case desc = "description"
        case link = "yes24Link"
        case date = "publicationDate"
    }
}

struct BookList: Codable {
    let list: [Book]
    let totalCount: Int
    let code: Int
    let message: String?
}

struct BookDetail: Codable {
    let book: Book
    let code: Int
    let message: String?
}
