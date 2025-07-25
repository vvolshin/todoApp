import SwiftUI

struct SearchView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = TodoViewModel()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            TextField("Enter query", text: $viewModel.searchQuery)
                .focused($isTextFieldFocused)
                .keyboardType(.alphabet)
                .padding()
                .background(.ownGray)
                .cornerRadius(8)
                .shadow(radius: 10)
                .padding()
            Spacer()
            
            
            List(viewModel.todos, id: \.id) { todo in
                VStack(alignment: .leading) {
                    Text(todo.todo)
                        .font(.headline)
                    Text("ID: \(todo.id)")
                        .font(.subheadline)
                }
            }
            .listStyle(.plain)

            Spacer()
        }
        .onAppear() {
            isTextFieldFocused = true
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    router.goBack()
                }, label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                    .foregroundStyle(.yellow)
                })
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
            .environmentObject(Router())
    }
}
