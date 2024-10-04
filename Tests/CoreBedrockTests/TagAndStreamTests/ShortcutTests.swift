//
// Created by yechentide on 2024/10/04
//

import Testing
import Foundation
@testable import CoreBedrock

struct ShortcutTests {
    @Test
    func testNbtByte() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let test: NBT = ByteTag(250)
        #expect(test.byteValue == 250)
        #expect(test.shortValue == 250)
        #expect(test.intValue == 250)
        #expect(test.longValue == 250)
        #expect(test.floatValue == 250)
        #expect(test.doubleValue == 250)
        #expect(test.stringValue == "250")
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(test.hasValue)
    }

    @Test
    func testNbtShort() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let test: NBT = ShortTag(32767)
        //XCTAssertThrowsError(dummy = test.byteValue)
        #expect(test.shortValue == 32767)
        #expect(test.intValue == 32767)
        #expect(test.longValue == 32767)
        #expect(test.floatValue == 32767)
        #expect(test.doubleValue == 32767)
        #expect(test.stringValue == "32767")
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(test.hasValue)
    }

    @Test
    func testNbtInt() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let test: NBT = IntTag(2147483647)
        //XCTAssertThrowsError(dummy = test.byteValue)
        //XCTAssertThrowsError(dummy = test.shortValue)
        #expect(test.intValue == 2147483647)
        #expect(test.longValue == 2147483647)
        #expect(test.floatValue == 2147483648)
        #expect(test.doubleValue == 2147483647)
        #expect(test.stringValue == "2147483647")
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(test.hasValue)
    }

    @Test
    func testNbtLong() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let test: NBT = LongTag(9223372036854775807)
        //XCTAssertThrowsError(dummy = test.byteValue)
        //XCTAssertThrowsError(dummy = test.shortValue)
        //XCTAssertThrowsError(dummy = test.intValue)
        #expect(test.longValue == 9223372036854775807)
        #expect(test.floatValue == Float(9223372036854775807))
        #expect(test.doubleValue == Double(9223372036854775807))
        #expect(test.stringValue == "9223372036854775807")
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(test.hasValue)
    }

    @Test
    func testNbtFloat() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let test: NBT = FloatTag(0.49823147)
        //XCTAssertThrowsError(dummy = test.byteValue)
        //XCTAssertThrowsError(dummy = test.shortValue)
        //XCTAssertThrowsError(dummy = test.intValue)
        //XCTAssertThrowsError(dummy = test.longValue)
        #expect(test.floatValue == 0.49823147)
        #expect(test.doubleValue == 0.49823147)
        #expect(test.stringValue == "0.49823147")
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(test.hasValue)
    }

    @Test
    func testNbtDouble() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let test: NBT = DoubleTag(0.4931287132182315)
        //XCTAssertThrowsError(dummy = test.byteValue)
        //XCTAssertThrowsError(dummy = test.shortValue)
        //XCTAssertThrowsError(dummy = test.intValue)
        //XCTAssertThrowsError(dummy = test.longValue)
        #expect(test.floatValue == Float(0.4931287132182315))
        #expect(test.doubleValue == 0.4931287132182315)
        #expect(test.stringValue == "0.4931287132182315")
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(test.hasValue)
    }

    @Test
    func testNbtString() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let test: NBT = StringTag("HELLO WORLD THIS IS A TEST STRING ÅÄÖ!")
        //XCTAssertThrowsError(dummy = test.byteValue)
        //XCTAssertThrowsError(dummy = test.shortValue)
        //XCTAssertThrowsError(dummy = test.intValue)
        //XCTAssertThrowsError(dummy = test.longValue)
        //XCTAssertThrowsError(dummy = test.floatValue)
        //XCTAssertThrowsError(dummy = test.doubleValue)
        #expect(test.stringValue == "HELLO WORLD THIS IS A TEST STRING ÅÄÖ!")
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(test.hasValue)
    }

    @Test
    func testNbtByteArray() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let bytes: [UInt8] = [1, 2, 3, 4, 5]
        let test: NBT = ByteArrayTag(bytes)
        //XCTAssertThrowsError(dummy = test.byteValue)
        //XCTAssertThrowsError(dummy = test.shortValue)
        //XCTAssertThrowsError(dummy = test.intValue)
        //XCTAssertThrowsError(dummy = test.longValue)
        //XCTAssertThrowsError(dummy = test.floatValue)
        //XCTAssertThrowsError(dummy = test.doubleValue)
        //XCTAssertThrowsError(dummy = test.stringValue)
        #expect(test.byteArrayValue == bytes)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(test.hasValue)
    }

    @Test
    func testNbtIntArray() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let ints: [Int32] = [1111, 2222, 3333, 4444, 5555]
        let test: NBT = IntArrayTag(ints)
        //XCTAssertThrowsError(dummy = test.byteValue)
        //XCTAssertThrowsError(dummy = test.shortValue)
        //XCTAssertThrowsError(dummy = test.intValue)
        //XCTAssertThrowsError(dummy = test.longValue)
        //XCTAssertThrowsError(dummy = test.floatValue)
        //XCTAssertThrowsError(dummy = test.doubleValue)
        //XCTAssertThrowsError(dummy = test.stringValue)
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        #expect(test.intArrayValue == ints)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(test.hasValue)
    }

    @Test
    func testNbtLongArray() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let longs: [Int64] = [11111111111, 22222222222, 33333333333, 44444444444, 55555555555]
        let test: NBT = LongArrayTag(longs)
        //XCTAssertThrowsError(dummy = test.byteValue)
        //XCTAssertThrowsError(dummy = test.shortValue)
        //XCTAssertThrowsError(dummy = test.intValue)
        //XCTAssertThrowsError(dummy = test.longValue)
        //XCTAssertThrowsError(dummy = test.floatValue)
        //XCTAssertThrowsError(dummy = test.doubleValue)
        //XCTAssertThrowsError(dummy = test.stringValue)
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        #expect(test.longArrayValue == longs)
        #expect(test.hasValue)
    }

    @Test
    func testNbtCompound() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let test: NBT = CompoundTag(name: "Derp")
        //XCTAssertThrowsError(dummy = test.byteValue)
        //XCTAssertThrowsError(dummy = test.shortValue)
        //XCTAssertThrowsError(dummy = test.intValue)
        //XCTAssertThrowsError(dummy = test.longValue)
        //XCTAssertThrowsError(dummy = test.floatValue)
        //XCTAssertThrowsError(dummy = test.doubleValue)
        //XCTAssertThrowsError(dummy = test.stringValue)
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(!test.hasValue)
    }

    @Test
    func testNbtList() async throws {
        //
        // Can't currently test for invalid cast because properties can't throw errors
        //
        //var dummy: Any?
        let test: NBT = ListTag(name: "Derp")
        //XCTAssertThrowsError(dummy = test.byteValue)
        //XCTAssertThrowsError(dummy = test.shortValue)
        //XCTAssertThrowsError(dummy = test.intValue)
        //XCTAssertThrowsError(dummy = test.longValue)
        //XCTAssertThrowsError(dummy = test.floatValue)
        //XCTAssertThrowsError(dummy = test.doubleValue)
        //XCTAssertThrowsError(dummy = test.stringValue)
        //XCTAssertThrowsError(dummy = test.byteArrayValue)
        //XCTAssertThrowsError(dummy = test.intArrayValue)
        //XCTAssertThrowsError(dummy = test.longArrayValue)
        #expect(!test.hasValue)
    }
}
