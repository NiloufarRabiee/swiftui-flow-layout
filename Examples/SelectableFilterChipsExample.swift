import SwiftUI
import FlowLayout

struct SelectableFilterChipsExample: View {
    private let filters = [
        "All",
        "SwiftUI",
        "Design",
        "Accessibility",
        "Concurrency",
        "Open Source"
    ]

    @State private var selectedFilters: Set<String> = ["All"]

    var body: some View {
        FlowLayout(
            horizontalSpacing: 8,
            verticalSpacing: 10
        ) {
            ForEach(filters, id: \.self) { filter in
                Button {
                    toggle(filter)
                } label: {
                    Text(filter)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            selectedFilters.contains(filter)
                                ? Color.accentColor.opacity(0.18)
                                : Color.secondary.opacity(0.10)
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }

    private func toggle(_ filter: String) {
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter)
        } else {
            selectedFilters.insert(filter)
        }
    }
}
