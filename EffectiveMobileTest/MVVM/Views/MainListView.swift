import SwiftUI

struct MainListView: View {
	@EnvironmentObject var router: Router
	@StateObject private var viewModel = MainListVM()
	@AppStorage("didFetchTodos") private var didFetchTodos = false

	// MARK: - Body
	var body: some View {
		VStack {
			title()
			searchArea()
			tasksArea()
			Spacer()
		}
		.mainListToolbar(taskCount: viewModel.todos.count) {
			router.go(to: .newTaskView)
		}
		.onAppear {
			if !didFetchTodos {
				viewModel.fetchAndStoreTodos()
				didFetchTodos = true
			}
			else {
				viewModel.loadFromCoreData()
			}
		}
	}
}

// MARK: - View components
extension MainListView {
	private func title() -> some View {
		HStack {
			Text("Задачи")
				.font(.system(size: 34))
				.fontWeight(.bold)
				.foregroundStyle(.white)
			Spacer()
		}
		.padding(.horizontal)
	}

	private func searchArea() -> some View {
		Button(
			action: {
				router.go(to: .searchView)
			},
			label: {
				HStack {
					Image(systemName: "magnifyingglass")
						.resizable()
						.scaledToFit()
						.foregroundStyle(Color.secondary)
						.frame(width: 17, height: 17)

					Text("Search")
						.font(.system(size: 17))
						.foregroundStyle(Color.secondary)

					Spacer()

					Image(systemName: "microphone.fill")
						.resizable()
						.scaledToFit()
						.foregroundStyle(Color.secondary)
						.frame(width: 17, height: 17)
				}
				.padding()
				.background {
					RoundedRectangle(cornerRadius: 10)
						.fill(.ownGray)
				}
				.padding(.horizontal)
			})
	}

	private func tasksArea() -> some View {
		List($viewModel.todos, id: \.id) { $todo in
			HStack(alignment: .top, spacing: 12) {
				CheckButton(completed: $todo.completed) {
					viewModel.toggleTodo(todo)
				}
				singleTaskContent(todo: todo)
			}
			.padding(.vertical, 8)
			.contextMenu {
				TodoContextMenu(todo: todo, viewModel: viewModel, router: router)
			}
		}
		.refreshable {
			viewModel.deleteAllTodosFromCoreData()
			viewModel.fetchAndStoreTodos()
		}
	}
}

// MARK: - List row components
extension MainListView {
	private func singleTaskContent(todo: TodoItem) -> some View {
		VStack(alignment: .leading, spacing: 4) {
			taskIdText(todo: todo)
			taskTodoText(todo)
			taskDateText(todo)
		}
	}

	private func taskIdText(todo: TodoItem) -> some View {
		HStack {
			Text("ID: \(todo.id)")
				.font(.system(size: 16))
				.fontWeight(todo.completed ? .regular : .bold)
				.strikethrough(todo.completed, color: .gray)
				.foregroundStyle(todo.completed ? .white.opacity(0.5) : .white)
			Spacer()
		}
	}

	private func taskTodoText(_ todo: TodoItem) -> some View {
		Text(todo.todo)
			.font(.system(size: 12))
			.fontWeight(.regular)
			.foregroundStyle(todo.completed ? .white.opacity(0.5) : .white)
	}

	private func taskDateText(_ todo: TodoItem) -> some View {
		Text(todo.date.formatDate())
			.font(.system(size: 12))
			.fontWeight(.regular)
			.foregroundStyle(.white.opacity(0.5))
	}
}

// MARK: - Preview
#Preview {
	NavigationStack {
		MainListView()
			.environmentObject(Router())
	}
}
