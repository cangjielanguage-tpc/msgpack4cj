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

@Test
public class MessageTestInt {

    @TestCase
    public func testPackInt8(): Unit {
        let buffer1 = ByteBuffer()
        let buffer2 = ByteBuffer()
        let buffer3 = ByteBuffer()
        var packer1 = MessagePacker(buffer1)
        var packer2 = MessagePacker(buffer2)
        var packer3 = MessagePacker(buffer3)
        
        packer1.packInt8(-127)
        packer2.packInt8(-2) 
        packer3.packInt8(0)

        let Int8Array1 = readToEnd(buffer1) // [208, 129]
        let Int8Array2 = readToEnd(buffer2) // [254]
        let Int8Array3 = readToEnd(buffer3) // [0]

        let Assert1: Array<UInt8> = [208, 129]
        let Assert2: Array<UInt8> = [254]
        let Assert3: Array<UInt8> = [0]
        @Assert(Int8Array1, Assert1)
        @Assert(Int8Array2, Assert2)
        @Assert(Int8Array3, Assert3)

        var unpacker1 = MessageUnpacker(Int8Array1)
        var unpacker2 = MessageUnpacker(Int8Array2)
        var unpacker3 = MessageUnpacker(Int8Array3)
        let value1: Int8 = unpacker1.unpackInt8()
        let value2: Int8 = unpacker2.unpackInt8()
        let value3: Int8 = unpacker3.unpackInt8()
        @Assert(value1, -127)
        @Assert(value2, -2)
        @Assert(value3, 0)
    }

    @TestCase
    public func testPackInt8_Int16_Int32(): Unit {
        let buffer1 = ByteBuffer()
        let buffer2 = ByteBuffer()
        let buffer3 = ByteBuffer()
        let buffer4 = ByteBuffer()
        var packer1 = MessagePacker(buffer1)
        var packer2 = MessagePacker(buffer2)
        var packer3 = MessagePacker(buffer3)
        var packer4 = MessagePacker(buffer4)
        packer1.packInt8(-127)
        packer2.packInt16(-130) // Int16 (-32,768 - 32,767)
        packer3.packInt32(-32769)

        packer4.packInt(-127)
        packer4.packInt(-130)
        packer4.packInt(-32769)

        let Int8Array = readToEnd(buffer1) // [208, 129]
        let Int16Array = readToEnd(buffer2) // [209, 255, 126]
        let Int32Array = readToEnd(buffer3) // [210, 255, 255, 127, 255]
        let IntArray = readToEnd(buffer4) //[208, 129, 209, 255, 126, 210, 255, 255, 127, 255]

        @Assert(Int8Array, IntArray[0..2])
        @Assert(Int16Array, IntArray[2..5])
        @Assert(Int32Array, IntArray[5..])

        var unpacker1 = MessageUnpacker(Int8Array)
        var unpacker2 = MessageUnpacker(Int16Array)
        var unpacker3 = MessageUnpacker(Int32Array)
        var unpacker4 = MessageUnpacker(IntArray)

        let value1: Int8 = unpacker1.unpackInt8()
        let value2: Int16 = unpacker2.unpackInt16()
        let value3: Int32 = unpacker3.unpackInt32()

        let value4: Int = unpacker4.unpackInt64()
        let value5: Int = unpacker4.unpackInt64()
        let value6: Int = unpacker4.unpackInt64()

        @Assert(value1, -127)
        @Assert(value2, -130)
        @Assert(value3, -32769)
        @Assert(value4, -127)
        @Assert(value5, -130)
        @Assert(value6, -32769)

    }


    @OverflowWrapping
    @TestCase
    public func testPackUInt(): Unit {

        var dataArray: Array<Byte> = Array<Byte>(2, repeat: 0u8)
        let s: Int16 = -129
        let ss = UInt16(s).writeBigEndian(dataArray)

        println(s)
        println(dataArray)

    }
}