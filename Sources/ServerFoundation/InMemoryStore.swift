//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//

import Dependencies
import Foundation

public actor InMemoryStore {
    private struct Entry {
        let value: Any
        let expiresAt: Date?
    }

    private let cache: BoundedCache<String, Entry>
    private var cleanupTimer: SendableTimer?

    public init(capacity: Int = 1000, cleanupInterval: TimeInterval = 60) {
        self.cache = BoundedCache(capacity: capacity)
        Task {
            await self.startCleanupTimer(interval: cleanupInterval)
        }
    }

    deinit {
        Task { [weak self] in
            await self?.invalidateTimer()
        }
    }

    private func invalidateTimer() {
        cleanupTimer?.invalidate()
    }

    private func startCleanupTimer(interval: TimeInterval) {
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.removeExpiredEntries()
            }
        }
        let sendableTimer = SendableTimer()
        sendableTimer.setTimer(timer)
        self.cleanupTimer = sendableTimer
    }
}

extension InMemoryStore {
    private class SendableTimer: @unchecked Sendable {
        private var timer: Timer?

        func setTimer(_ timer: Timer) {
            self.timer = timer
        }

        func invalidate() {
            timer?.invalidate()
            timer = nil
        }
    }
}

extension InMemoryStore {
    public func set(_ key: String, value: Any, expiresIn: TimeInterval? = nil) {
        let expiresAt = expiresIn.map { Date().addingTimeInterval($0) }
        let entry = Entry(value: value, expiresAt: expiresAt)
        cache.insert(entry, forKey: key)
    }

    public func get(_ key: String) -> Any? {
        guard let entry = cache.getValue(forKey: key) else { return nil }

        if let expiresAt = entry.expiresAt, expiresAt < Date() {
            _ = cache.removeValue(forKey: key)
            return nil
        }

        return entry.value
    }

    public func get<T>(_ key: String, as type: T.Type) -> T? {
        guard let entry = cache.getValue(forKey: key) else { return nil }

        if let expiresAt = entry.expiresAt, expiresAt < Date() {
            _ = cache.removeValue(forKey: key)
            return nil
        }

        return entry.value as? T
    }

    public func remove(_ key: String) {
        _ = cache.removeValue(forKey: key)
    }

    public func removeExpiredEntries() {
        let now = Date()
        cache.filter { _, entry in
            guard let expiresAt = entry.expiresAt else { return true }
            return expiresAt > now
        }
    }

    public func clear() {
        cache.removeAll()
    }

    // Additional utility methods that leverage BoundedCache capabilities
    public var count: Int {
        cache.count
    }

    public var isEmpty: Bool {
        cache.isEmpty
    }
}

extension InMemoryStore: TestDependencyKey {
    public static let testValue: InMemoryStore = .init(capacity: 100) // Smaller capacity for tests
}

extension DependencyValues {
    public var inMemoryStore: InMemoryStore {
        get { self[InMemoryStore.self] }
        set { self[InMemoryStore.self] = newValue }
    }
}
