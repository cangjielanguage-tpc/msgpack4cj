// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.time.MonoTime
import std.unittest.*
import std.unittest.testmacro.*
import serialization.serialization.{DataModel, DataModelStruct, field, Serializable}
import msgpack4cj.core.*
import msgpack4cj.serialization.*

@Test
public class MessageTest {

    @TestCase[
        value in [true, false]
    ]
    public func testBool(value: Bool): Unit {
        var packer = MessagePacker()
        packer.packBool(value)
        var unpacker = MessageUnpacker(packer.toByteArray())
        @Expect(unpacker.unpackBool(), value)
    }

    @TestCase
    public func testNull(): Unit {
        var packer = MessagePacker()
        packer.packNull()
        var unpacker = MessageUnpacker(packer.toByteArray())
        unpacker.unpackNull()
    }

    @TestCase[
        value in random()
    ]
    public func testString(value: String): Unit {
        println(value)
        var packer = MessagePacker()
        packer.packString(value)
        var unpacker = MessageUnpacker(packer.toByteArray())
        @Expect(unpacker.unpackString(), value)
    }

    @TestCase[
        value in [
            -1i64, -23i64, -32i64,
            -33i64, -89i64, -128i64,
            -129i64, -150i64, -32768i64,
            -32769i64, -327638i64, -2147483648i64,
            -2147483649i64, -21474883648i64, -9223372036854775808i64
        ]
    ]

    @OverflowWrapping
    public func testInt(value: Int64): Unit {
        var packer = MessagePacker()
        packer.packInt(value)
        var unpacker = MessageUnpacker(packer.toByteArray())
        @Expect(unpacker.unpackInt(), value)
    }    

    @TestCase[
        value in [
            0u64, 120u64, 127u64,
            128u64, 220u64, 255u64,
            256u64, 304u64, 65535u64,
            65536u64, 655526u64, 4294967295u64,
            4294967296u64, 42994967295u64, 18_446_744_073_709_551_615u64
        ]
    ]
    @OverflowWrapping
    public func testUInt(value: UInt64): Unit {
        var packer = MessagePacker()
        packer.packInt(Int64(value))
        var unpacker = MessageUnpacker(packer.toByteArray())
        @Expect(UInt64(unpacker.unpackInt()), value)
    }

    @TestCase[
        value in [0.00f64, 1223.56f64, -78895.9090f64]
    ]
    public func testFloat64(value: Float64): Unit {
        var packer = MessagePacker()
        packer.packFloat64(value)
        var unpacker = MessageUnpacker(packer.toByteArray())
        @Expect(unpacker.unpackFloat64(), value)
    }


    @TestCase[
        value in [0, 10, 16 , 3000, 65535, 67535]
    ]
    public func testArray(value: Int): Unit {
        var packer = MessagePacker()
        packer.packArrayHeader(value)
        var unpacker = MessageUnpacker(packer.toByteArray())
        @Expect(unpacker.unpackArrayHeader(), value)
    }


    @TestCase[
        value in [0, 10, 16 , 3000, 65535, 67535]
    ]
    public func testStruct(value: Int64): Unit {
        var packer = MessagePacker()
        packer.packMapHeader(value)
        var unpacker = MessageUnpacker(packer.toByteArray())
        @Expect(unpacker.unpackMapHeader(), value)
    }
 

    @TestCase[
        value in random()
    ]
    public func testBinary(value: Array<Byte>): Unit {
        var packer = MessagePacker()
        packer.packBinary(value)
        var unpacker = MessageUnpacker(packer.toByteArray())
        @Expect(unpacker.unpackBinary(), value)
    }

    @TestCase
    public func speedTest() {
        var start = MonoTime.now()
        var entity = Entity()
        for(i in 0..1000000) {
            var packer = MessagePacker()
            packer.packMapHeader(6)
            packer.packString("field1")
            packer.packString(entity.field1)
            packer.packString("field2")
            packer.packInt(entity.field2)
            packer.packString("field3")
            packer.packFloat64(entity.field3)
            packer.packString("field4")
            packer.packBool(entity.field4)
            packer.packString("field5")
            packer.packNull()
            packer.packString("field6")
            packer.packArrayHeader(entity.field6.size);
            for(b in entity.field6) {
                packer.packInt(Int64(b));
            }
            packer.toByteArray()
            ///println(packer.toByteArray().size)
        }
        var end = MonoTime.now()
        var cost = end - start
        println("耗时: ${cost.toMilliseconds()}ms")
    }


}

class Entity {

    public var field1: String = "序列化测试"

    public var field2: Int = 0

    public var field3: Float64 = 0.00

    public var field4: Bool = false

    public var field5: Option<Entity> = None

    public var field6: Array<Byte> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

}



