import SwiftUI

enum Route: Hashable {
	case mainListView
	case newTaskView
	case searchView
	case taskEditView(task: TodoItem)

	@MainActor @ViewBuilder
	var view: some View {
		switch self {
			case .mainListView:
				MainListView()
			case .newTaskView:
				NewTaskView()
			case .searchView:
				SearchView()
			case .taskEditView(let task):
				EditTaskView(task: task)
		}
	}
}
