
import Foundation
struct PostingStudentLocationResponse : Codable {
    var createdAt : String
    var objectId : String
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)!
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)!
    }
    
}
