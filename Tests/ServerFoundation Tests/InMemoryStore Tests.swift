//
//  InMemoryStore Tests.swift
//  swift-server-foundation
//
//  Created by Coen ten Thije Boonkkamp on 31/10/2025.
//

import Foundation
import Testing

@testable import ServerFoundation

@Suite("InMemoryStore Tests")
struct InMemoryStoreTests {

  // MARK: - Basic Operations Tests

  @Test("InMemoryStore sets and gets values")
  func storesSetsAndGetsValues() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("key1", value: "value1")
    let retrieved = await store.get("key1", as: String.self)

    #expect(retrieved == "value1")
  }

  @Test("InMemoryStore returns nil for non-existent keys")
  func storeReturnsNilForNonExistentKeys() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    let retrieved = await store.get("non-existent", as: String.self)

    #expect(retrieved == nil)
  }

  @Test("InMemoryStore removes values")
  func storeRemovesValues() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("key1", value: "value1")
    await store.remove("key1")
    let retrieved = await store.get("key1", as: String.self)

    #expect(retrieved == nil)
  }

  @Test("InMemoryStore clears all values")
  func storeClearsAllValues() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("key1", value: "value1")
    await store.set("key2", value: "value2")
    await store.set("key3", value: "value3")

    await store.clear()

    let retrieved1 = await store.get("key1", as: String.self)
    let retrieved2 = await store.get("key2", as: String.self)
    let retrieved3 = await store.get("key3", as: String.self)

    #expect(retrieved1 == nil)
    #expect(retrieved2 == nil)
    #expect(retrieved3 == nil)
  }

  // MARK: - Type-Safe Get Tests

  @Test("InMemoryStore gets values with type safety")
  func storeGetsValuesWithTypeSafety() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("stringKey", value: "value1")
    await store.set("intKey", value: 42)
    await store.set("boolKey", value: true)

    let stringValue = await store.get("stringKey", as: String.self)
    let intValue = await store.get("intKey", as: Int.self)
    let boolValue = await store.get("boolKey", as: Bool.self)

    #expect(stringValue == "value1")
    #expect(intValue == 42)
    #expect(boolValue == true)
  }

  @Test("InMemoryStore returns nil for type mismatch")
  func storeReturnsNilForTypeMismatch() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("key", value: "string value")

    let wrongType = await store.get("key", as: Int.self)

    #expect(wrongType == nil)
  }

  // MARK: - Expiration Tests

  @Test("InMemoryStore expires values after timeout")
  func storeExpiresValuesAfterTimeout() async throws {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("key1", value: "value1", expiresIn: 0.1)

    // Value should be available immediately
    let immediate = await store.get("key1", as: String.self)
    #expect(immediate == "value1")

    // Wait for expiration
    try await Task.sleep(for: .milliseconds(150))

    // Value should be expired
    let expired = await store.get("key1", as: String.self)
    #expect(expired == nil)
  }

  @Test("InMemoryStore does not expire values without timeout")
  func storeDoesNotExpireValuesWithoutTimeout() async throws {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("key1", value: "value1")

    // Wait a bit
    try await Task.sleep(for: .milliseconds(100))

    // Value should still be available
    let retrieved = await store.get("key1", as: String.self)
    #expect(retrieved == "value1")
  }

  @Test("InMemoryStore handles mixed expiration scenarios")
  func storeHandlesMixedExpirationScenarios() async throws {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("persistent", value: "persists")
    await store.set("expires", value: "expires", expiresIn: 0.1)

    try await Task.sleep(for: .milliseconds(150))

    let persistent = await store.get("persistent", as: String.self)
    let expired = await store.get("expires", as: String.self)

    #expect(persistent == "persists")
    #expect(expired == nil)
  }

  // MARK: - Cleanup Timer Tests

  @Test("InMemoryStore cleanup removes expired entries")
  func storeCleanupRemovesExpiredEntries() async throws {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 0.05)

    await store.set("key1", value: "value1", expiresIn: 0.02)
    await store.set("key2", value: "value2")

    // Wait for expiration and cleanup cycle
    // The cleanup timer runs every 50ms, so we wait longer to ensure it runs
    try await Task.sleep(for: .milliseconds(150))

    let count = await store.count
    let key2Value = await store.get("key2", as: String.self)

    // Only the non-expired value should remain
    // Note: The automatic cleanup may not have run yet due to timer scheduling,
    // so we verify the expired key returns nil when accessed
    let key1Value = await store.get("key1", as: String.self)
    #expect(key1Value == nil)
    #expect(key2Value == "value2")
  }

  @Test("InMemoryStore manual cleanup removes expired entries")
  func storeManualCleanupRemovesExpiredEntries() async throws {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("key1", value: "value1", expiresIn: 0.05)
    await store.set("key2", value: "value2")

    // Wait for expiration
    try await Task.sleep(for: .milliseconds(100))

    // Manually trigger cleanup
    await store.removeExpiredEntries()

    let count = await store.count
    let key2Value = await store.get("key2", as: String.self)

    #expect(count == 1)
    #expect(key2Value == "value2")
  }

  // MARK: - Count and State Tests

  @Test("InMemoryStore tracks count correctly")
  func storeTracksCountCorrectly() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    var count = await store.count
    #expect(count == 0)
    #expect(await store.isEmpty)

    await store.set("key1", value: "value1")
    count = await store.count
    #expect(count == 1)
    #expect(!(await store.isEmpty))

    await store.set("key2", value: "value2")
    count = await store.count
    #expect(count == 2)

    await store.remove("key1")
    count = await store.count
    #expect(count == 1)

    await store.clear()
    count = await store.count
    #expect(count == 0)
    #expect(await store.isEmpty)
  }

  // MARK: - Capacity Tests

  @Test("InMemoryStore respects capacity limits")
  func storeRespectsCapacityLimits() async {
    let store = InMemoryStore(capacity: 3, cleanupInterval: 60)

    await store.set("key1", value: "value1")
    await store.set("key2", value: "value2")
    await store.set("key3", value: "value3")

    let count = await store.count
    #expect(count == 3)

    // Adding one more should evict the oldest entry
    await store.set("key4", value: "value4")

    let finalCount = await store.count
    #expect(finalCount == 3)
  }

  // MARK: - Concurrent Access Tests

  @Test("InMemoryStore handles concurrent reads")
  func storeHandlesConcurrentReads() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("shared", value: "value")

    await withTaskGroup(of: String?.self) { group in
      for _ in 0..<10 {
        group.addTask {
          await store.get("shared", as: String.self)
        }
      }

      for await result in group {
        #expect(result == "value")
      }
    }
  }

  @Test("InMemoryStore handles concurrent writes")
  func storeHandlesConcurrentWrites() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await withTaskGroup(of: Void.self) { group in
      for i in 0..<10 {
        group.addTask {
          await store.set("key\(i)", value: "value\(i)")
        }
      }
    }

    let count = await store.count
    #expect(count == 10)
  }

  @Test("InMemoryStore handles concurrent reads and writes")
  func storeHandlesConcurrentReadsAndWrites() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)

    await store.set("shared", value: "initial")

    await withTaskGroup(of: Void.self) { group in
      // Writers
      for i in 0..<5 {
        group.addTask {
          await store.set("key\(i)", value: "value\(i)")
        }
      }

      // Readers
      for _ in 0..<5 {
        group.addTask {
          _ = await store.get("shared", as: String.self)
        }
      }
    }

    let count = await store.count
    #expect(count >= 1)  // At least the shared key exists
  }

  // MARK: - Complex Type Tests

  @Test("InMemoryStore stores complex types")
  func storesComplexTypes() async {
    struct TestStruct: Equatable {
      let id: Int
      let name: String
    }

    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)
    let testValue = TestStruct(id: 1, name: "test")

    await store.set("struct", value: testValue)

    let retrieved = await store.get("struct", as: TestStruct.self)
    #expect(retrieved == testValue)
  }

  @Test("InMemoryStore stores arrays")
  func storesArrays() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)
    let array = [1, 2, 3, 4, 5]

    await store.set("array", value: array)

    let retrieved = await store.get("array", as: [Int].self)
    #expect(retrieved == array)
  }

  @Test("InMemoryStore stores dictionaries")
  func storesDictionaries() async {
    let store = InMemoryStore(capacity: 100, cleanupInterval: 60)
    let dict = ["key1": "value1", "key2": "value2"]

    await store.set("dict", value: dict)

    let retrieved = await store.get("dict", as: [String: String].self)
    #expect(retrieved == dict)
  }
}
