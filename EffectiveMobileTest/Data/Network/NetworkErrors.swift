enum NetworkErrors: Error, CustomStringConvertible {
    case invalidURL
    case requestFailed(Error)
    case badServerResponse
    case noData
    case decodingError(Error)

    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let underlyingError):
            return "Request failed: \(underlyingError.localizedDescription)"
        case .badServerResponse:
            return "Bad server response"
        case .noData:
            return "No data returned"
        case .decodingError(let decodingError):
            return "Decoding error: \(decodingError.localizedDescription)"
        }
    }
}
