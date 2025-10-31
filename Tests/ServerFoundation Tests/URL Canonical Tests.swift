//
//  URL Canonical Tests.swift
//  coenttb-server
//
//  Created by Coen ten Thije Boonkkamp on 23/07/2025.
//

@testable import ServerFoundation
import Foundation
import Testing

@Suite("URL Canonical Tests")
struct URLCanonicalTests {

    @Test("URL canonical updates host only")
    func urlCanonicalUpdatesHostOnly() throws {
        let originalURL = URL(string: "https://example.com/path?query=value")!
        let result = try URL.canonical(url: originalURL, canonicalHost: "canonical.com")

        #expect(result.host == "canonical.com")
        #expect(result.path == "/path")
        #expect(result.query == "query=value")
        #expect(result.scheme == "https")
    }

    @Test("URL canonical updates host and port")
    func urlCanonicalUpdatesHostAndPort() throws {
        let originalURL = URL(string: "https://example.com:8080/path")!
        let result = try URL.canonical(url: originalURL, canonicalHost: "canonical.com:9090")

        #expect(result.host == "canonical.com")
        #expect(result.port == 9090)
        #expect(result.path == "/path")
        #expect(result.scheme == "https")
    }

    @Test("URL canonical clears existing port when no port specified")
    func urlCanonicalClearsExistingPortWhenNoPortSpecified() throws {
        let originalURL = URL(string: "https://example.com:8080/path")!
        let result = try URL.canonical(url: originalURL, canonicalHost: "canonical.com")

        #expect(result.host == "canonical.com")
        #expect(result.port == nil)
        #expect(result.path == "/path")
    }

    @Test("URL canonical handles host with default port")
    func urlCanonicalHandlesHostWithDefaultPort() throws {
        let originalURL = URL(string: "https://example.com/path")!
        let result = try URL.canonical(url: originalURL, canonicalHost: "canonical.com:443")

        #expect(result.host == "canonical.com")
        #expect(result.port == 443)
    }

    @Test("URL canonical rejects invalid port")
    func urlCanonicalRejectsInvalidPort() {
        let originalURL = URL(string: "https://example.com/path")!

        #expect(throws: URLCanonicalError.invalidPort("invalid")) {
            try URL.canonical(url: originalURL, canonicalHost: "canonical.com:invalid")
        }
    }

    @Test("URL canonical rejects empty canonical host")
    func urlCanonicalRejectsEmptyCanonicalHost() {
        let originalURL = URL(string: "https://example.com/path")!

        #expect(throws: URLCanonicalError.emptyHost) {
            try URL.canonical(url: originalURL, canonicalHost: "")
        }
    }

    @Test("URL canonical handles multiple colons in host")
    func urlCanonicalHandlesMultipleColonsInHost() {
        let originalURL = URL(string: "https://example.com/path")!

        #expect(throws: URLCanonicalError.invalidPort("8080:extra")) {
            try URL.canonical(url: originalURL, canonicalHost: "canonical.com:8080:extra")
        }
    }

    @Test("URL canonical preserves fragment and query")
    func urlCanonicalPreservesFragmentAndQuery() throws {
        let originalURL = URL(string: "https://example.com/path?query=value#fragment")!
        let result = try URL.canonical(url: originalURL, canonicalHost: "canonical.com:8080")

        #expect(result.host == "canonical.com")
        #expect(result.port == 8080)
        #expect(result.query == "query=value")
        #expect(result.fragment == "fragment")
    }

    @Test("URL canonical rejects IPv6 addresses (not supported)")
    func urlCanonicalRejectsIPv6Addresses() {
        let originalURL = URL(string: "https://example.com/path")!

        #expect(throws: URLCanonicalError.malformedIPv6) {
            try URL.canonical(url: originalURL, canonicalHost: "[::1]")
        }

        #expect(throws: URLCanonicalError.malformedIPv6) {
            try URL.canonical(url: originalURL, canonicalHost: "[::1]:8080")
        }

        #expect(throws: URLCanonicalError.malformedIPv6) {
            try URL.canonical(url: originalURL, canonicalHost: "[2001:db8::1]")
        }
    }

    @Test("URL canonical rejects invalid port ranges")
    func urlCanonicalRejectsInvalidPortRanges() throws {
        let originalURL = URL(string: "https://example.com/path")!

        #expect(throws: URLCanonicalError.portOutOfRange(0)) {
            try URL.canonical(url: originalURL, canonicalHost: "host:0")
        }

        #expect(throws: URLCanonicalError.portOutOfRange(65536)) {
            try URL.canonical(url: originalURL, canonicalHost: "host:65536")
        }

        let resultValid = try URL.canonical(url: originalURL, canonicalHost: "host:65535")
        #expect(resultValid.port == 65535)
    }
}
