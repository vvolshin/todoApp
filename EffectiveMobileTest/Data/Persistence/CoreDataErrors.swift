enum CoreDataErrors: Error, CustomStringConvertible {
	case todoNotFound
	case failedToLoad(Error)
	case failedToSave(Error)
	case failedToUpdate(Error)
	case failedToDelete(Error)
	case failedToSearch(Error)

	var description: String {
		switch self {
			case .todoNotFound:
				return "Todo not found"
			case .failedToLoad(let error):
				return "Failed to load todo: \(error.localizedDescription)"
			case .failedToSave(let error):
				return "Failed to save todo: \(error.localizedDescription)"
			case .failedToUpdate(let error):
				return "Failed to update todo: \(error.localizedDescription)"
			case .failedToDelete(let error):
				return "Failed to delete todo: \(error.localizedDescription)"
			case .failedToSearch(let error):
				return "Failed to search todo: \(error.localizedDescription)"
		}
	}
}
