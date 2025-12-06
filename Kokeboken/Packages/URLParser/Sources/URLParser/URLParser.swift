import Foundation

/// A parser for extracting metadata from URLs
@available(iOS 17.0, *)
public enum URLParser {
    /// Parses metadata from a given URL
    /// - Parameter url: The URL to parse
    /// - Returns: A MetaData object containing title, URL, and image
    /// - Throws: An error if the URL cannot be fetched or parsed
    public static func parse(url: URL) async throws -> MetaData {
        // Fetch the HTML content
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let html = String(data: data, encoding: .utf8) else {
            throw URLError(.badServerResponse)
        }
        
        // Extract metadata from HTML
        let title = extractTitle(from: html) ?? extractMetaTag(from: html, property: "og:title") ?? extractMetaTag(from: html, name: "twitter:title")
        let imageString = extractMetaTag(from: html, property: "og:image") ?? extractMetaTag(from: html, name: "twitter:image") ?? extractMetaTag(from: html, name: "image")
        let imageURL = imageString.flatMap { URL(string: $0, relativeTo: url) }
        
        return MetaData(title: title, url: url, image: imageURL)
    }
    
    // MARK: - Private Helpers
    
    /// Extracts the title from HTML
    private static func extractTitle(from html: String) -> String? {
        let pattern = #"<title[^>]*>([^<]+)</title>"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
              let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
              let range = Range(match.range(at: 1), in: html) else {
            return nil
        }
        return String(html[range]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Extracts a meta tag value from HTML
    private static func extractMetaTag(from html: String, property: String? = nil, name: String? = nil) -> String? {
        let pattern: String
        if let property = property {
            pattern = #"<meta[^>]*property=["']\(property)["'][^>]*content=["']([^"']+)["']"#
        } else if let name = name {
            pattern = #"<meta[^>]*name=["']\(name)["'][^>]*content=["']([^"']+)["']"#
        } else {
            return nil
        }
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
              let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
              let range = Range(match.range(at: 1), in: html) else {
            return nil
        }
        return String(html[range]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

