//
//  File.swift
//  coenttb-server
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2025.
//

import Dependencies
import RateLimiter

extension RateLimiter {
    public func checkLimit(
        _ key: Key
    ) async -> RateLimitResult {
        @Dependency(\.date) var date
        let timestamp: Date = date()

        return await self.checkLimit(key, timestamp: timestamp)
    }
}
