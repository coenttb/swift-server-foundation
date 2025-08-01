//
//  File 2.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 03/06/2022.
//

import EnvironmentVariables
import Foundation
import Logging

extension EnvVars {
    public var baseUrl: URL {
        get { URL(string: self["BASE_URL"]!)! }
        set { self["BASE_URL"] = newValue.absoluteString }
    }

    public var port: Int {
        get { Int(self["PORT"]!)! }
        set { self["PORT"] = String(newValue) }
    }
}

extension EnvVars {
    public var allowedInsecureHosts: [String]? {
        get { self["ALLOWED_INSECURE_HOSTS"]?.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
        set { self["ALLOWED_INSECURE_HOSTS"] = newValue?.joined(separator: ",") }
    }

    public var canonicalHost: String? {
        get { self["CANONICAL_HOST"] }
        set { self["CANONICAL_HOST"] = newValue }
    }

    public var emergencyMode: Bool {
        get { self["EMERGENCY_MODE"] == "1" }
        set { self["EMERGENCY_MODE"] = newValue ? "1" : "0" }
    }

    public var httpsRedirect: Bool? {
        get { self["HTTPS_REDIRECT"].map { $0 == "true" } }
        set { self["HTTPS_REDIRECT"] = newValue.map { $0 ? "true" : "false" } }
    }

    public var logLevel: Logger.Level? {
        get { self["LOG_LEVEL"].flatMap { Logger.Level(rawValue: $0) } }
        set { self["LOG_LEVEL"] = newValue?.rawValue }
    }
}

extension EnvVars {
    public var appleDeveloperMerchantIdDomainAssociation: String? {
        get { self["APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION"] }
        set { self["APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION"] = newValue }
    }
}
