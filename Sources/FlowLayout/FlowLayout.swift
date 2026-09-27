import SwiftUI

/// Horizontal alignment used for each row in a flow layout.
public enum FlowAlignment: Sendable {
    case leading
    case center
    case trailing
}

/// A lightweight SwiftUI layout that wraps subviews across multiple rows.
public struct FlowLayout: Layout {
    public var horizontalSpacing: CGFloat
    public var verticalSpacing: CGFloat
    public var alignment: FlowAlignment

    public init(
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8,
        alignment: FlowAlignment = .leading
    ) {
        self.horizontalSpacing = FlowLayoutConfiguration.normalizedSpacing(
            horizontalSpacing
        )
        self.verticalSpacing = FlowLayoutConfiguration.normalizedSpacing(
            verticalSpacing
        )
        self.alignment = alignment
    }

    public init(
        spacing: CGFloat,
        alignment: FlowAlignment = .leading
    ) {
        self.init(
            horizontalSpacing: spacing,
            verticalSpacing: spacing,
            alignment: alignment
        )
    }

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let sizes = subviews.map {
            $0.sizeThatFits(.unspecified)
        }

        return FlowLayoutEngine.layout(
            sizes: sizes,
            containerWidth: proposal.width ?? .infinity,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            alignment: alignment
        ).size
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let sizes = subviews.map {
            $0.sizeThatFits(.unspecified)
        }

        let result = FlowLayoutEngine.layout(
            sizes: sizes,
            containerWidth: bounds.width,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            alignment: alignment
        )

        for (index, frame) in result.frames.enumerated() {
            guard subviews.indices.contains(index) else { continue }

            subviews[index].place(
                at: CGPoint(
                    x: bounds.minX + frame.minX,
                    y: bounds.minY + frame.minY
                ),
                anchor: .topLeading,
                proposal: ProposedViewSize(
                    width: frame.width,
                    height: frame.height
                )
            )
        }
    }
}

enum FlowLayoutConfiguration {
    static func normalizedSpacing(_ spacing: CGFloat) -> CGFloat {
        guard spacing.isFinite else {
            return 0
        }

        return max(spacing, 0)
    }
}

struct FlowLayoutResult {
    let size: CGSize
    let frames: [CGRect]
}

enum FlowLayoutEngine {
    static func layout(
        sizes: [CGSize],
        containerWidth: CGFloat,
        horizontalSpacing: CGFloat,
        verticalSpacing: CGFloat,
        alignment: FlowAlignment
    ) -> FlowLayoutResult {
        guard !sizes.isEmpty else {
            return FlowLayoutResult(size: .zero, frames: [])
        }

        let maxWidth = normalizedContainerWidth(containerWidth)
        let hSpacing = FlowLayoutConfiguration.normalizedSpacing(horizontalSpacing)
        let vSpacing = FlowLayoutConfiguration.normalizedSpacing(verticalSpacing)

        var rows: [[Int]] = [[]]
        var rowWidths: [CGFloat] = [0]
        var rowHeights: [CGFloat] = [0]

        for (index, size) in sizes.enumerated() {
            let itemSize = normalizedSize(size)
            let currentRow = rows.count - 1
            let currentWidth = rowWidths[currentRow]
            let requiredSpacing = rows[currentRow].isEmpty ? 0 : hSpacing
            let proposedWidth = currentWidth + requiredSpacing + itemSize.width

            if !rows[currentRow].isEmpty && proposedWidth > maxWidth {
                rows.append([index])
                rowWidths.append(itemSize.width)
                rowHeights.append(itemSize.height)
            } else {
                rows[currentRow].append(index)
                rowWidths[currentRow] = proposedWidth
                rowHeights[currentRow] = max(
                    rowHeights[currentRow],
                    itemSize.height
                )
            }
        }

        let contentWidth = rowWidths.max() ?? 0
        let reportedWidth = maxWidth.isFinite
            ? min(contentWidth, maxWidth)
            : contentWidth

        let totalHeight = rowHeights.reduce(0, +)
            + CGFloat(max(rows.count - 1, 0)) * vSpacing

        var frames = Array(
            repeating: CGRect.zero,
            count: sizes.count
        )

        var y: CGFloat = 0

        for rowIndex in rows.indices {
            let row = rows[rowIndex]
            let rowWidth = rowWidths[rowIndex]
            let rowHeight = rowHeights[rowIndex]
            let availableWidth = maxWidth.isFinite
                ? maxWidth
                : rowWidth

            var x = startingX(
                alignment: alignment,
                availableWidth: availableWidth,
                rowWidth: rowWidth
            )

            for itemIndex in row {
                let itemSize = normalizedSize(sizes[itemIndex])

                frames[itemIndex] = CGRect(
                    x: x,
                    y: y,
                    width: itemSize.width,
                    height: itemSize.height
                )

                x += itemSize.width + hSpacing
            }

            y += rowHeight

            if rowIndex < rows.count - 1 {
                y += vSpacing
            }
        }

        return FlowLayoutResult(
            size: CGSize(
                width: reportedWidth,
                height: totalHeight
            ),
            frames: frames
        )
    }

    private static func startingX(
        alignment: FlowAlignment,
        availableWidth: CGFloat,
        rowWidth: CGFloat
    ) -> CGFloat {
        let remaining = max(availableWidth - rowWidth, 0)

        switch alignment {
        case .leading:
            return 0
        case .center:
            return remaining / 2
        case .trailing:
            return remaining
        }
    }

    private static func normalizedContainerWidth(
        _ width: CGFloat
    ) -> CGFloat {
        guard !width.isNaN else {
            return .infinity
        }

        if width == .infinity {
            return .infinity
        }

        return max(width, 0)
    }

    private static func normalizedSize(_ size: CGSize) -> CGSize {
        CGSize(
            width: normalizedDimension(size.width),
            height: normalizedDimension(size.height)
        )
    }

    private static func normalizedDimension(
        _ value: CGFloat
    ) -> CGFloat {
        guard value.isFinite else {
            return 0
        }

        return max(value, 0)
    }
}

#Preview {
    let tags = [
        "SwiftUI",
        "Layout",
        "Animation",
        "Accessibility",
        "Concurrency",
        "Design Systems",
        "iOS",
        "macOS"
    ]

    FlowLayout(
        horizontalSpacing: 8,
        verticalSpacing: 10
    ) {
        ForEach(tags, id: \.self) { tag in
            Text(tag)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(.thinMaterial)
                .clipShape(Capsule())
        }
    }
    .padding()
}
