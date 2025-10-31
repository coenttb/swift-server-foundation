//
//  LogHandler Tests.swift
//  coenttb-server
//
//  Created by Coen ten Thije Boonkkamp on 23/07/2025.
//

@testable import ServerFoundation
import Foundation
import Logging
import Testing

@Suite("LogHandler Tests")
struct LogHandlerTests {

    @Test("LogHandler formats levels correctly")
    func logHandlerFormatsLevelsCorrectly() {
        let handler = LogHandler(label: "test")

        let levels: [Logger.Level] = [.trace, .debug, .info, .notice, .warning, .error, .critical]
        let expectedFormats = ["TRACE", "DEBUG", "INFO ", "NOTCE", "WARN ", "ERROR", "CRIT "]

        for (level, expected) in zip(levels, expectedFormats) {
            #expect(level.formatted == expected)
        }
    }

    @Test("LogHandler initializes with correct defaults")
    func logHandlerInitializesWithCorrectDefaults() {
        let handler = LogHandler(label: "test-label")

        #expect(handler.logLevel == .info)
        #expect(handler.metadataProvider == nil)
        #expect(handler.metadata.isEmpty)
    }

    @Test("LogHandler initializes with custom values")
    func logHandlerInitializesWithCustomValues() {
        let metadataProvider = Logger.MetadataProvider { ["custom": "value"] }
        let handler = LogHandler(
            label: "custom-label",
            logLevel: .debug,
            metadataProvider: metadataProvider
        )

        #expect(handler.logLevel == .debug)
        #expect(handler.metadataProvider != nil)
    }

    @Test("LogHandler manages metadata correctly")
    func logHandlerManagesMetadataCorrectly() {
        var handler = LogHandler(label: "test")

        #expect(handler.metadata.isEmpty)

        handler.metadata = ["key1": "value1"]
        #expect(handler.metadata["key1"] == "value1")

        handler[metadataKey: "key2"] = "value2"
        #expect(handler[metadataKey: "key2"] == "value2")

        handler[metadataKey: "key1"] = nil
        #expect(handler[metadataKey: "key1"] == nil)
        #expect(handler.metadata.count == 1)
    }

    @Test("DateFormatter log produces ISO8601 format")
    func dateFormatterLogProducesISO8601Format() {
        let formatter = DateFormatter.log
        let date = Date(timeIntervalSince1970: 1234567890.123)

        let formatted = formatter.string(from: date)
        #expect(formatted == "2009-02-13T23:31:30.123Z")
    }

    @Test("DateFormatter log uses UTC timezone")
    func dateFormatterLogUsesUTCTimezone() {
        let formatter = DateFormatter.log
        #expect(formatter.timeZone == TimeZone(secondsFromGMT: 0))
    }

    @Test("DateFormatter log uses POSIX locale")
    func dateFormatterLogUsesPOSIXLocale() {
        let formatter = DateFormatter.log
        #expect(formatter.locale == Locale(identifier: "en_US_POSIX"))
    }
}
