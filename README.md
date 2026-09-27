# FlowLayout

[![CI](https://github.com/NiloufarRabiee/swiftui-flow-layout/actions/workflows/ci.yml/badge.svg)](https://github.com/NiloufarRabiee/swiftui-flow-layout/actions/workflows/ci.yml)
![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
![iOS](https://img.shields.io/badge/iOS-16%2B-blue)
![macOS](https://img.shields.io/badge/macOS-13%2B-blue)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A lightweight reusable **SwiftUI flow layout for wrapping tags, chips, filters, and dynamic views across multiple rows**.

Built with the native SwiftUI `Layout` protocol. No `GeometryReader` workaround is required.

## Features

- Native SwiftUI `Layout`
- Automatic row wrapping
- Configurable horizontal spacing
- Configurable vertical spacing
- Leading alignment
- Center alignment
- Trailing alignment
- Dynamic content support
- No third-party dependencies
- No `GeometryReader` hacks
- iOS and macOS support
- Swift Package Manager support

## Requirements

- iOS 16+
- macOS 13+
- Swift 5.9+

## Installation

### Swift Package Manager

In Xcode:

1. Open your project.
2. Go to **File > Add Package Dependencies...**
3. Enter:

```
https://github.com/NiloufarRabiee/swiftui-flow-layout
```

4. Add the `FlowLayout` package to your app target.

Then import it:

```swift
import FlowLayout
```

## Basic Usage

```swift
FlowLayout(spacing: 8) {
    ForEach(tags, id: \.self) { tag in
        Text(tag)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.thinMaterial)
            .clipShape(Capsule())
    }
}
```

When the current row runs out of horizontal space, the next view automatically moves to a new row.

## Independent Spacing

```swift
FlowLayout(
    horizontalSpacing: 8,
    verticalSpacing: 12
) {
    ForEach(items) { item in
        Chip(item.title)
    }
}
```

## Alignment

### Leading

```swift
FlowLayout(
    spacing: 8,
    alignment: .leading
) {
    content
}
```

### Center

```swift
FlowLayout(
    spacing: 8,
    alignment: .center
) {
    content
}
```

### Trailing

```swift
FlowLayout(
    spacing: 8,
    alignment: .trailing
) {
    content
}
```

Alignment is applied independently to each row.

## Dynamic Content

Because `FlowLayout` uses SwiftUI's native layout system, it works naturally with dynamic data:

```swift
FlowLayout(spacing: 8) {
    ForEach(searchResults) { result in
        Text(result.name)
            .padding(8)
            .background(.regularMaterial)
            .clipShape(Capsule())
    }
}
```

## How It Works

`FlowLayout` conforms to SwiftUI's `Layout` protocol.

During measurement, it:

1. Measures each subview.
2. Adds views to the current row while they fit.
3. Starts a new row when the next view would exceed the proposed width.
4. Tracks each row's width and tallest item.
5. Applies row alignment.
6. Places each subview at its calculated position.

This keeps layout behavior inside SwiftUI's layout system instead of measuring view geometry from the outside.

## API

```swift
FlowLayout(
    horizontalSpacing: 8,
    verticalSpacing: 8,
    alignment: .leading
)
```

Or use the convenience initializer:

```swift
FlowLayout(
    spacing: 8,
    alignment: .center
)
```

## Example

A complete tag-cloud example is included in:

```
Examples/TagCloudExample.swift
```

## Testing

The package includes unit tests for:

- Row wrapping
- Leading placement
- Center alignment
- Trailing alignment
- Empty content
- Spacing normalization

Run:

```bash
swift test
```

GitHub Actions CI is included.

## Contributing

Contributions and improvements are welcome.

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is available under the MIT License.

See [LICENSE](LICENSE).

---

Created by **Niloufar Rabiee**
