import SwiftUI

struct MainListView: View {
	@EnvironmentObject var router: Router
	@StateObject private var viewModel = TodoViewModel()
	@AppStorage("didFetchTodos") private var didFetchTodos = false

	// MARK: - Body
	var body: some View {
		VStack {
			title()
			searchArea()
			tasksArea()
			Spacer()
		}
		.bottomToolbar(taskCount: viewModel.todos.count) {
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

// MARK: - Components
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
		List(viewModel.todos) { todo in
			HStack(alignment: .top, spacing: 12) {
				checkButton(todo: todo)
				singleTask(todo: todo)
			}
			.padding(.vertical, 8)
            .contextMenu {
                Button {
                    router.go(to: .taskEditView)
                } label: {
                    Label("Редактировать", systemImage: "square.and.pencil")
                }
                
                ShareLink(item: todo.todo) {
                    Label("Поделиться", systemImage: "square.and.arrow.up")
                }

                Button(role: .destructive) {
                    viewModel.deleteTodo(todo)
                } label: {
                    Label("Удалить", systemImage: "trash")
                }
            }
		}
        .refreshable {
            viewModel.deleteAllTodosFromCoreData()
            viewModel.fetchAndStoreTodos()
        }
	}

	private func singleTask(todo: TodoItem) -> some View {
		VStack(alignment: .leading, spacing: 4) {
			HStack {
				Text("ID: \(todo.id)")
					.font(.system(size: 16))
					.fontWeight(todo.completed ? .regular : .bold)
					.strikethrough(todo.completed, color: .gray)
					.foregroundStyle(todo.completed ? .white.opacity(0.5) : .white)
				Spacer()
			}

			Text(todo.todo)
				.font(.system(size: 12))
				.fontWeight(.regular)
				.foregroundStyle(todo.completed ? .white.opacity(0.5) : .white)

			Text(formatDate(todo.date))
				.font(.system(size: 12))
				.fontWeight(.regular)
				.foregroundStyle(.white.opacity(0.5))
		}
	}

	private func checkButton(todo: TodoItem) -> some View {
		Button(
			action: {
				viewModel.toggleTodo(todo)
			},
			label: {
				Image(systemName: todo.completed ? "checkmark.circle" : "circle")
					.resizable()
					.scaledToFit()
					.frame(width: 24, height: 24)
					.foregroundColor(todo.completed ? .yellow : .gray)
			})
	}

	private func formatDate(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy"
		return formatter.string(from: date)
	}
}

#Preview {
	NavigationStack {
		MainListView()
			.environmentObject(Router())
	}
}
