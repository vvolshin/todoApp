import Combine
import Foundation

struct NetworkAgent {
	static let shared = NetworkAgent()
	private init() {}

	private let baseURL = "https://dummyjson.com"

	func fetchTodos() -> AnyPublisher<[TodoItem], NetworkError> {
		guard let url = URL(string: "\(baseURL)/todos") else {
			return Fail(error: .invalidURL).eraseToAnyPublisher()
		}

		return URLSession.shared.dataTaskPublisher(for: url)
			.tryMap { data, response in
				guard let httpResponse = response as? HTTPURLResponse,
					(200...299).contains(httpResponse.statusCode)
				else {
					throw NetworkError.badServerResponse
				}
				return data
			}
			.decode(type: TodoResponse.self, decoder: JSONDecoder())
			.map { $0.todos }
			.mapError { error in
				if let decodingError = error as? DecodingError {
					print("Decoding failed: \(decodingError)")
					return .decodingError
				}
				else if let networkError = error as? NetworkError {
					return networkError
				}
				else {
					return .requestFailed(error)
				}
			}
			.eraseToAnyPublisher()
	}
}
