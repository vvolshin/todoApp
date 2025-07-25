import Foundation

struct TodoResponse: Codable {
    let todos: [TodoItem]
    var total: Int
    var skip: Int
    let limit: Int
}

struct TodoItem: Identifiable {
    let id: Int
    var todo: String
    var completed: Bool
    let userId: Int
    var date: Date = Date()
}

extension TodoItem: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, todo, completed, userId
    }
}
