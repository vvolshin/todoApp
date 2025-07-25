import SwiftUI

enum Route: Hashable {
    case mainListView
    case taskDetailsView
    case newTaskView
    case searchView
    case taskEditView

    @MainActor @ViewBuilder
    var view: some View {
        switch self {
        case .mainListView:
            MainListView()
        case .taskDetailsView:
            TaskDetailsView()
        case .newTaskView:
            NewTaskView()
        case .searchView:
            SearchView()
            case .taskEditView:
            TaskEditView()
        }
    }
}
