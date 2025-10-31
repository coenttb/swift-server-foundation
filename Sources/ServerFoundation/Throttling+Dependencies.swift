//
//  File.swift
//  coenttb-server
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2025.
//

import Dependencies
import Throttling

extension RateLimiter {
  public func checkLimit(
    _ key: Key
  ) async -> RateLimitResult {
    @Dependency(\.date) var date
    let timestamp: Date = date()

    return await self.checkLimit(key, timestamp: timestamp)
  }
}

extension RequestPacer {
  public func scheduleRequest(
    _ key: Key
  ) async -> ScheduleResult {
    @Dependency(\.date) var date
    let timestamp: Date = date()

    return await self.scheduleRequest(key, timestamp: timestamp)
  }
}

extension ThrottledClient {
  public func acquire(
    _ key: Key
  ) async -> AcquisitionResult {
    @Dependency(\.date) var date
    let timestamp: Date = date()

    return await self.acquire(key, timestamp: timestamp)
  }
}
