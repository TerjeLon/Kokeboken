# Assets Package

A Swift package containing asset-related code for the Kokeboken application, including colors, margins, and corner radiuses.

## Features

- **Colors**: Centralized color definitions for consistent theming
- **Margins**: Standardized spacing and margin values
- **Radiuses**: Consistent corner radius values for rounded corners

## Usage

```swift
import Assets

// Using colors
Text("Hello")
    .foregroundColor(Assets.Colors.primary)

// Using margins
VStack {
    Text("Content")
}
.padding(Assets.Margins.lg)

// Using radiuses
RoundedRectangle(cornerRadius: Assets.Radiuses.lg)
```

## Structure

- `Colors.swift`: Color definitions
- `Margins.swift`: Spacing and margin values
- `Radiuses.swift`: Corner radius values
- `Assets.swift`: Main entry point

