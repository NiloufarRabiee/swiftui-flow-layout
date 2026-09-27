import SwiftUI
import FlowLayout

struct TagCloudExample: View {
    private let tags = [
        "SwiftUI",
        "Accessibility",
        "Animation",
        "Layout",
        "Concurrency",
        "Design Systems",
        "iOS",
        "macOS",
        "Open Source"
    ]

    var body: some View {
        FlowLayout(
            horizontalSpacing: 8,
            verticalSpacing: 10,
            alignment: .leading
        ) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }
        }
        .padding()
    }
}
