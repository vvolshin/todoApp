import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case badServerResponse
    case noData
    case decodingError
}
