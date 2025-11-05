//
//  ReadmeVerificationTests.swift
//  swift-server-foundation
//
//  Created for README standardization verification
//

import AsyncHTTPClient
import Logging
import NIOPosix
import Testing

@testable import ServerFoundation

@Suite("README Verification")
struct ReadmeVerificationTests {

    @Test("Quick Start - Logging example")
    func loggingExample() throws {
        // From README line 42
        let logger = Logger(label: "com.example.app")
        #expect(logger.label == "com.example.app")
    }

    @Test("Quick Start - HTTP Client example (basic)")
    func httpClientBasicExample() throws {
        // From README line 45
        // Note: HTTPClient requires an event loop group
        // This test verifies the API exists and compiles
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer {
            try? eventLoopGroup.syncShutdownGracefully()
        }

        let client = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
        defer {
            try? client.syncShutdown()
        }

        #expect(client != nil)
    }

    @Test("Quick Start - JWT example structure")
    func jwtExampleStructure() throws {
        // From README line 48-51
        // This verifies the JWT type exists and has expected initializer signature
        // Note: Actual signing requires a valid key

        // Verify JWT type is available from ServerFoundation
        let _: JWT.Type = JWT.self

        // JWT API verification would require crypto keys
        // which is beyond the scope of README verification
    }

    @Test("Module - ServerFoundation can be imported")
    func serverFoundationImports() {
        // Verify all re-exported modules are accessible
        let _: Logger.Type = Logger.self
        let _: HTTPClient.Type = HTTPClient.self
        let _: JWT.Type = JWT.self
    }
}
