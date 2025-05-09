// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.time.MonoTime
import std.unittest.*
import std.unittest.testmacro.*
import serialization.serialization.{DataModel, DataModelStruct, field, Serializable}
import msgpack4cj.core.*
import msgpack4cj.serialization.*

import std.binary.BigEndianOrder
import std.collection.ArrayList
import std.time.*

    let EXT_TYPE_DATETIME: Byte = 0x0A; // 自定义类型标识（如 0x0A 表示日期）
    let data: Array<UInt8> = [0x01, 0x02, 0x03]

    let EXT_TYPE_DATETIME2: Byte = 42
    let data2: Array<UInt8> = [50, 48, 50, 51, 45, 49, 48, 45, 48, 49, 84, 49, 50, 58, 51, 52, 58, 53, 54]

    let EXT_TYPE_DATETIME3: Byte = 0x0A; // 自定义类型标识（如 0x0A 表示日期）
    let data3: Array<UInt8> = [0x01, 0x02, 0x03, 0x04]

    @Test
    public class MessageTestExt {
        @OverflowWrapping
        @TestCase
        public func testExt(): Unit {
            var packer = MessagePack.newDefaultBufferPacker()
            packer.packExtensionTypeHeader(EXT_TYPE_DATETIME, Int32(data.size))
            packer.writePayload(data)

            var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
            let header: ExtensionTypeHeader = unpacker.unpackExtensionTypeHeader()
            let array2: Array<Byte> = unpacker.readPayload(Int64(header.getLength()))

            @Assert(array2, data)
            @Assert(header.getLength(), 3)
            @Assert(header.getType(), 10)

        }

        @OverflowWrapping
        @TestCase
        public func testExt2(): Unit {
            var packer = MessagePack.newDefaultBufferPacker()
            packer.packExtensionTypeHeader(EXT_TYPE_DATETIME2, Int32(data2.size))
            packer.writePayload(data2)

            var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
            let header: ExtensionTypeHeader = unpacker.unpackExtensionTypeHeader()
            let array2: Array<Byte> = unpacker.readPayload(Int64(header.getLength()))

            @Assert(array2, data2)
            @Assert(header.getLength(), 19)
            @Assert(header.getType(), 42)

        }

        @OverflowWrapping
        @TestCase
        public func testExt3(): Unit {
           @Assert((1 & (1 - 1)) == 0, true)
           @Assert((2 & (2 - 1)) == 0, true)
           @Assert((4 & (4 - 1)) == 0, true)
           @Assert((8 & (8 - 1)) == 0, true)
           @Assert((16 & (16 - 1)) == 0, true)
        }


        @OverflowWrapping
        @TestCase
        public func testExt4(): Unit {

            var packer = MessagePack.newDefaultBufferPacker()
            packer.packExtensionTypeHeader(EXT_TYPE_DATETIME3, Int32(data3.size))
            packer.writePayload(data3)

            var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray()) 
            let header: ExtensionTypeHeader = unpacker.unpackExtensionTypeHeader()
            let array2: Array<Byte> = unpacker.readPayload(Int64(header.getLength()))

            @Assert(array2, data3)
            @Assert(header.getLength(), 4)
            @Assert(header.getType(), 10)
        }
    }