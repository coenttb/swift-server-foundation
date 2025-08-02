// swift-tools-version:6.0

import PackageDescription

extension String {
    static let coenttbServer: Self = "ServerFoundation"
    static let coenttbServerEnvVars: Self = "ServerFoundationEnvVars"
}

extension Target.Dependency {
    static var coenttbServer: Self { .target(name: .coenttbServer) }
    static var coenttbServerEnvVars: Self { .target(name: .coenttbServerEnvVars) }
}

extension Target.Dependency {
    static var builders: Self { .product(name: "Builders", package: "swift-builders") }
    static var emailAddress: Self { .product(name: "EmailAddress", package: "swift-emailaddress-type") }
    static var domain: Self { .product(name: "Domain", package: "swift-domain-type") }
    static var asyncHttpClient: Self { .product(name: "AsyncHTTPClient", package: "async-http-client") }
    static var casePaths: Self { .product(name: "CasePaths", package: "swift-case-paths") }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var environmentVariables: Self { .product(name: "EnvironmentVariables", package: "swift-environment-variables") }
    static var foundationExtensions: Self { .product(name: "FoundationExtensions", package: "swift-foundation-extensions") }
    static var translating: Self { .product(name: "Translating", package: "swift-translating") }
    static var logging: Self { .product(name: "Logging", package: "swift-log") }
    static var rateLimiter: Self { .product(name: "RateLimiter", package: "swift-ratelimiter") }
    static var postgresKit: Self { .product(name: "PostgresKit", package: "postgres-kit") }
    static var issueReporting: Self { .product(name: "IssueReporting", package: "xctest-dynamic-overlay") }
    static var urlRouting: Self { .product(name: "URLRouting", package: "swift-url-routing") }
    static var passwordValidation: Self { .product(name: "PasswordValidation", package: "swift-password-validation") }
    static var urlRoutingTranslating: Self { .product(name: "URLRoutingTranslating", package: "swift-url-routing-translating") }
    static var urlFormCoding: Self { .product(name: "URLFormCoding", package: "swift-url-form-coding") }
    static var urlFormCodingURLRouting: Self { .product(name: "URLFormCodingURLRouting", package: "swift-url-form-coding-url-routing") }
    static var urlMultipartFormCodingURLRouting: Self { .product(name: "URLMultipartFormCodingURLRouting", package: "swift-url-multipart-form-coding-url-routing") }
    static var crypto: Self { .product(name: "Crypto", package: "swift-crypto") }
    static var dateParsing: Self { .product(name: "DateParsing", package: "swift-date-parsing") }
    static var unixEpochParsing: Self { .product(name: "UnixEpochParsing", package: "swift-date-parsing") }
    static var jwt: Self { .product(name: "JWT", package: "swift-jwt") }
}

let package = Package(
    name: "swift-server-foundation",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: .coenttbServer,
            targets: [
                .coenttbServer,
                .coenttbServerEnvVars
            ]
        ),
        .library(name: .coenttbServerEnvVars, targets: [.coenttbServerEnvVars])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-builders", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-date-parsing", from: "0.1.0"),
        .package(url: "https://github.com/coenttb/swift-domain-type", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-emailaddress-type", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-environment-variables", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-foundation-extensions", from: "0.1.0"),
        .package(url: "https://github.com/coenttb/swift-jwt", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-password-validation", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-ratelimiter", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-translating", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-url-form-coding", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-url-form-coding-url-routing", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-url-routing-translating", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-url-multipart-form-coding-url-routing", from: "0.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "1.5.6"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.4.3"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.6.2"),
        .package(url: "https://github.com/swift-server/async-http-client", from: "1.26.1"),
        .package(url: "https://github.com/vapor/postgres-kit", from: "2.12.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-crypto", from: "3.0.0")

    ],
    targets: [
        .target(
            name: .coenttbServer,
            dependencies: [
                .builders,
                .coenttbServerEnvVars,
                .asyncHttpClient,
                .casePaths,
                .dependencies,
                .environmentVariables,
                .foundationExtensions,
                .translating,
                .logging,
                .rateLimiter,
                .postgresKit,
                .issueReporting,
                .urlRouting,
                .passwordValidation,
                .urlRoutingTranslating,
                .emailAddress,
                .domain,
                .dateParsing,
                .unixEpochParsing,
                .jwt,
                .crypto,
                .urlFormCoding,
                .urlFormCodingURLRouting,
                .urlMultipartFormCodingURLRouting
            ]
        ),
        .testTarget(
            name: .coenttbServer.tests,
            dependencies: [
                .coenttbServer,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .coenttbServerEnvVars,
            dependencies: [
                .environmentVariables,
                .logging
            ]
        ),
        .testTarget(
            name: .coenttbServerEnvVars.tests,
            dependencies: [
                .coenttbServerEnvVars,
                .dependenciesTestSupport
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String { var tests: Self { self + " Tests" } }
