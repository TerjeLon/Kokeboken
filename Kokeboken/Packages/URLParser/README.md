# URLParser Package

A Swift package for parsing metadata from URLs, specifically designed for extracting recipe information from web pages.

## Features

- **URL Parsing**: Fetches and parses HTML content from URLs
- **Metadata Extraction**: Extracts title, image, and other metadata from web pages
- **Open Graph Support**: Supports Open Graph meta tags
- **Twitter Card Support**: Supports Twitter Card meta tags
- **Standard Meta Tags**: Falls back to standard HTML meta tags

## Usage

```swift
import URLParser

// Parse metadata from a URL
let url = URL(string: "https://example.com/recipe")!
let metadata = try await URLParser.parse(url: url)

// Access the metadata
print(metadata.title)  // Optional title
print(metadata.url)    // The parsed URL
print(metadata.image)  // Optional image URL
```

## Structure

- `MetaData.swift`: The metadata structure containing title, URL, and image
- `URLParser.swift`: The main parser implementation

## MetaData

The `MetaData` struct contains:
- `title: String?`: The title of the recipe or webpage
- `url: URL`: The URL that was parsed
- `image: URL?`: The image URL from the webpage metadata

