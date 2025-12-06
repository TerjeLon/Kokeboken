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
        
        // Try multiple image meta tag sources
        let imageString = extractMetaTag(from: html, property: "og:image") 
            ?? extractMetaTag(from: html, name: "twitter:image")
            ?? extractMetaTag(from: html, name: "twitter:image:src")
            ?? extractMetaTag(from: html, name: "image")
            ?? extractMetaTag(from: html, property: "image")
        
        // Resolve image URL (handles both absolute and relative URLs)
        let imageURL: URL?
        if let imageString = imageString {
            // Clean up the URL string (remove whitespace, handle encoding)
            let cleanedImageString = imageString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Try to create URL directly first (for absolute URLs)
            if let absoluteURL = URL(string: cleanedImageString) {
                imageURL = absoluteURL
            } else if let relativeURL = URL(string: cleanedImageString, relativeTo: url) {
                // Try as relative URL
                imageURL = relativeURL.absoluteURL
            } else {
                // Try URL-encoding the string in case it has special characters
                if let encodedString = cleanedImageString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let encodedURL = URL(string: encodedString) {
                    imageURL = encodedURL
                } else {
                    imageURL = nil
                }
            }
        } else {
            imageURL = nil
        }
        
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
        // Find all meta tags
        let metaTagPattern = #"<meta[^>]*>"#
        guard let metaRegex = try? NSRegularExpression(pattern: metaTagPattern, options: .caseInsensitive) else {
            return nil
        }
        
        let htmlRange = NSRange(html.startIndex..., in: html)
        let matches = metaRegex.matches(in: html, range: htmlRange)
        
        // Check each meta tag
        for match in matches {
            guard let tagRange = Range(match.range, in: html) else { continue }
            let tagString = String(html[tagRange])
            
            // Check if this tag has the property/name we're looking for
            var hasTargetAttribute = false
            if let searchProperty = property {
                let escapedProperty = NSRegularExpression.escapedPattern(for: searchProperty)
                let propertyAttrPattern = "property\\s*=\\s*[\"']\(escapedProperty)[\"']"
                if tagString.range(of: propertyAttrPattern, options: [.caseInsensitive, .regularExpression]) != nil {
                    hasTargetAttribute = true
                }
            } else if let searchName = name {
                let escapedName = NSRegularExpression.escapedPattern(for: searchName)
                let nameAttrPattern = "name\\s*=\\s*[\"']\(escapedName)[\"']"
                if tagString.range(of: nameAttrPattern, options: [.caseInsensitive, .regularExpression]) != nil {
                    hasTargetAttribute = true
                }
            }
            
            if hasTargetAttribute {
                // Extract content from this tag (handles any attribute order)
                // Pattern handles both single and double quotes, and URLs with special characters
                let contentPattern = "content\\s*=\\s*[\"']([^\"']+)[\"']"
                if let contentRegex = try? NSRegularExpression(pattern: contentPattern, options: .caseInsensitive) {
                    let tagRange = NSRange(tagString.startIndex..., in: tagString)
                    if let contentMatch = contentRegex.firstMatch(in: tagString, range: tagRange),
                       contentMatch.numberOfRanges > 1,
                       let contentRange = Range(contentMatch.range(at: 1), in: tagString) {
                        let extractedContent = String(tagString[contentRange])
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .replacingOccurrences(of: "&amp;", with: "&")
                            .replacingOccurrences(of: "&lt;", with: "<")
                            .replacingOccurrences(of: "&gt;", with: ">")
                            .replacingOccurrences(of: "&quot;", with: "\"")
                            .replacingOccurrences(of: "&#39;", with: "'")
                        return extractedContent
                    }
                }
            }
        }
        
        return nil
    }
}

