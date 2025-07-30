import SwiftUI

struct CheckButton: View {
    @Binding var completed: Bool
	let onClick: () -> Void

	var body: some View {
		Button(action: onClick) {
			Image(systemName: completed ? "checkmark.circle" : "circle")
				.resizable()
				.scaledToFit()
				.frame(width: 24, height: 24)
				.foregroundColor(completed ? .yellow : .gray)
		}
	}
}
