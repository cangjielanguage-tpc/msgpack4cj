// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.time.MonoTime
import std.unittest.*
import std.unittest.testmacro.*
import serialization.serialization.{DataModel, DataModelStruct, field, Serializable}
import msgpack4cj.core.*
import msgpack4cj.serialization.*

import std.io.ByteBuffer
import std.io.readToEnd
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
            let buffer = ByteBuffer()
            var packer = MessagePacker(buffer)
            packer.packExtensionTypeHeader(EXT_TYPE_DATETIME, Int32(data.size))
            packer.writePayload(data)

            let Int8Array1 = readToEnd(buffer) // [199, 3, 10, 1, 2, 3]
            var unpacker1 = MessageUnpacker(Int8Array1)
            let header: ExtensionTypeHeader = unpacker1.unpackExtensionTypeHeader()
            let array2: Array<Byte> = unpacker1.readPayload(Int64(header.getLength()))

            @Assert(array2, data)
            @Assert(header.getLength(), 3)
            @Assert(header.getType(), 10)

        }

        @OverflowWrapping
        @TestCase
        public func testExt2(): Unit {
            let buffer = ByteBuffer()
            var packer = MessagePacker(buffer)
            packer.packExtensionTypeHeader(EXT_TYPE_DATETIME2, Int32(data2.size))
            packer.writePayload(data2)

            let Int8Array1 = readToEnd(buffer) // [199, 19, 42, 50, 48, 50, 51, 45, 49, 48, 45, 48, 49, 84, 49, 50, 58, 51, 52, 58, 53, 54]
            println("Int8Array1   ${Int8Array1}")
            var unpacker1 = MessageUnpacker(Int8Array1)
            let header: ExtensionTypeHeader = unpacker1.unpackExtensionTypeHeader()
            let array2: Array<Byte> = unpacker1.readPayload(Int64(header.getLength()))

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

            let buffer = ByteBuffer()
            var packer = MessagePacker(buffer)
            packer.packExtensionTypeHeader(EXT_TYPE_DATETIME3, Int32(data3.size))
            packer.writePayload(data3)

            let Int8Array1 = readToEnd(buffer) // [214, 10, 1, 2, 3, 4]

            var unpacker1 = MessageUnpacker(Int8Array1)
            let header: ExtensionTypeHeader = unpacker1.unpackExtensionTypeHeader()
            let array2: Array<Byte> = unpacker1.readPayload(Int64(header.getLength()))

            @Assert(array2, data3)
            @Assert(header.getLength(), 4)
            @Assert(header.getType(), 10)
        }
    }