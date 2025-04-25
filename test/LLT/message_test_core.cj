// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.io.ByteBuffer
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
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packBool(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackBool(), value)
    }

    @TestCase
    public func testNull(): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packNull()
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        unpacker.unpackNull()
    }

    @TestCase[
        value in random()
    ]
    public func testString(value: String): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packString(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackString(), value)
    }

    //测试pack unpack int8
    @TestCase[
        value in [
            -1i8, -23i8, -32i8,
            -33i8, -89i8, -128i8
        ]
    ]
    @OverflowWrapping
    public func testInt8(value: Int8): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt8(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackInt8(), value)
    }  

    //测试pack unpack int16
    @TestCase[
        value in [
            -1i16, -2316, -32i16,
            -33i16, -89i16, -128i16,
            -129i16, -150i16, -32768i16
        ]
    ]
    @OverflowWrapping
    public func testInt16(value: Int16): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt16(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackInt16(), value)
    }  

    //测试pack unpack int32
    @TestCase[
        value in [
            -1i32, -23i32, -32i32,
            -33i32, -89i32, -128i32,
            -129i32, -150i32, -32768i32,
            -32769i32, -327638i32, -2147483648i32
        ]
    ]
    @OverflowWrapping
    public func testInt32(value: Int32): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackInt32(), value)
    }  

    //测试pack unpack int64
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
    public func testInt64(value: Int64): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackInt64(), value)
    }    

    //测试 pack unpack uint8
    @TestCase[
        value in [
            0u8, 120u8, 127u8,
            128u8, 220u8, 255u8
        ]
    ]
    @OverflowWrapping
    public func testUInt8(value: UInt8): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packUInt8(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackUInt8(), value)
    }

    //测试 pack unpack uint16
    @TestCase[
        value in [
            0u16, 120u16, 127u16,
            128u16, 220u16, 255u16,
            256u16, 304u16, 65535u16
        ]
    ]
    @OverflowWrapping
    public func testUInt16(value: UInt16): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packUInt16(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackUInt16(), value)
    }

    //测试 pack unpack uint32
    @TestCase[
        value in [
            0u32, 120u32, 127u32,
            128u32, 220u32, 255u32,
            256u32, 304u32, 65535u32,
            65536u32, 655526u32, 4294967295u32
        ]
    ]
    @OverflowWrapping
    public func testUInt64(value: UInt32): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packUInt32(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackUInt32(), value)
    }

    //测试 pack unpack uint64
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
    public func testUInt64(value: UInt64): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packUInt64(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackUInt64(), value)
    }

    @TestCase[
        value in [0.00f64, 1223.56f64, -78895.9090f64]
    ]
    public func testFloat64(value: Float64): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packFloat64(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackFloat64(), value)
    }


    @TestCase[
        value in [0, 10, 16 , 3000, 65535, 67535]
    ]
    public func testArray(value: Int): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packArrayHeader(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackArrayHeader(), value)
    }


    @TestCase[
        value in [0, 10, 16 , 3000, 65535, 67535]
    ]
    public func testStruct(value: Int64): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packMapHeader(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackMapHeader(), value)
    }
 

    @TestCase[
        value in random()
    ]
    public func testBinary(value: Array<Byte>): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packBinary(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackBinary(), value)
    }

}





