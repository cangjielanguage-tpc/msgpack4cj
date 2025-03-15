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

@Test
public class MessageTestInt {

    @TestCase
    public func testPackInt8(): Unit {
        var packer1 = MessagePacker()
        var packer2 = MessagePacker()
        var packer3 = MessagePacker()
        
        packer1.packInt8(-127)
        packer2.packInt8(-2) 
        packer3.packInt8(0)

        let Int8Array1 = packer1.toByteArray() // [208, 129]
        let Int8Array2 = packer2.toByteArray() // [254]
        let Int8Array3 = packer3.toByteArray() // [0]

        let Expect1: Array<UInt8> = [208, 129]
        let Expect2: Array<UInt8> = [254]
        let Expect3: Array<UInt8> = [0]
        @Expect(Int8Array1, Expect1)
        @Expect(Int8Array2, Expect2)
        @Expect(Int8Array3, Expect3)
    }

    @TestCase
    public func testPackInt8_Int16_Int32(): Unit {
        var packer4 = MessagePacker()
        var packer1 = MessagePacker()
        var packer2 = MessagePacker()
        var packer3 = MessagePacker()
        packer1.packInt8(-127)
        packer2.packInt16(-130) // Int16 (-32,768 - 32,767)
        packer3.packInt32(-32769)

        packer4.packInt(-127)
        packer4.packInt(-130)
        packer4.packInt(-32769)

        let Int8Array = packer1.toByteArray() // [208, 129]
        let Int16Array = packer2.toByteArray() // [209, 255, 126]
        let Int32Array = packer3.toByteArray() // [210, 255, 255, 127, 255]
        let IntArray = packer4.toByteArray() //[208, 129, 209, 255, 126, 210, 255, 255, 127, 255]

        @Expect(Int8Array, IntArray[0..2])
        @Expect(Int16Array, IntArray[2..5])
        @Expect(Int32Array, IntArray[5..])
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

    @OverflowWrapping
    @TestCase
    public func testTT(): Unit {
        println("ssss")
        println("曲".size)

    }

}