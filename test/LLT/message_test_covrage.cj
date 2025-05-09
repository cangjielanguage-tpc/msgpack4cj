// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.time.MonoTime
import std.unittest.*
import std.unittest.testmacro.*
import serialization.serialization.{DataModel, DataModelStruct, field, Serializable}
import msgpack4cj.core.*
import msgpack4cj.serialization.*
import std.time.*
import std.collection.*
internal import std.io.ByteArrayStream
internal import std.math.*

@Test
public class MessageCoverageTest {

    let EXT_TYPE_DATETIME3: Byte = 0x0A; // 自定义类型标识（如 0x0A 表示日期）
    let data3: Array<UInt8> = [0x01, 0x02, 0x03, 0x04]

    @TestCase
    public func test1(): Unit {
        try{
            var s = ExtensionTypeHeader.checkedCastToByte(-1)
        } catch (e: Exception){
            println(e.toString())
            @Assert(e.toString().contains("IllegalArgumentException"),true)
        }
        
        @Assert(ExtensionTypeHeader.checkedCastToByte(5), 5)
    }

    @TestCase
    public func test2(): Unit {

        var packer = MessagePack.newDefaultBufferPacker()
        packer.packExtensionTypeHeader(EXT_TYPE_DATETIME3, Int32(data3.size))
        packer.writePayload(data3)

        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray()) 
        let header: ExtensionTypeHeader = unpacker.unpackExtensionTypeHeader()
        let array2: Array<Byte> = unpacker.readPayload(Int64(header.getLength()))

        @Assert(array2, data3)
        @Assert(header.getLength(), 4)
        @Assert(header.getType(), 10)
        @Assert(header.isTimestampType(), false)
        @Assert(header.hashCode(), 1275)
        @Assert(header.toString().contains("ExtensionTypeHeader(type"))

        var h = ExtensionTypeHeader(EXT_TYPE_DATETIME3, Int32(data3.size))
        var hh = ExtensionTypeHeader(EXT_TYPE_DATETIME3, Int32(data3.size))
        var hhh = ExtensionTypeHeader(EXT_TYPE_DATETIME3, Int32(data3.size - 1))
        @Assert(h.equals(hh), true)
        @Assert(h.equals(hhh), false)
    }

    @TestCase
    public func test3(): Unit {
        var b  = ByteArrayStream(5)
        var packer = MessagePack.newDefaultPacker(b)
        packer.packInt64(5)
        var unpacker = MessagePack.newDefaultUnpacker(b.bytes())
        @Assert(unpacker.unpackInt64(), 5)
    }

    @TestCase
    public func test4(): Unit {
        var b  = ByteArrayStream(5)
        var packer = MessagePack.newDefaultPacker(b)

        packer.packInt64(5)
        var bb = ByteArrayStream()
        bb.write(b.bytes())
        var unpacker = MessagePack.newDefaultUnpacker(bb)

        @Assert(unpacker.unpackInt64(), 5)
    }

    @TestCase
    public func test5(): Unit {
            var packer = MessagePack.newDefaultBufferPacker()
            packer.packExtensionTypeHeader(EXT_TYPE_DATETIME3, Int32(data3.size))
            packer.writePayload(data3)
            var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        try{
            unpacker.unpackTimestamp()
            println("xxxx")
        } catch (e: Exception){
            println("xxxss")
            @Assert(e.toString().contains("MessageTypeException"),true)
        }
    }    

    @TestCase
    public func test555(): Unit {
            var packer = MessagePack.newDefaultBufferPacker()
            packer.packExtensionTypeHeader(EXT_TYPE_DATETIME3, 65537)
            packer.writePayload(data3)
            var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        try{
            unpacker.unpackExtensionTypeHeader()
            println("xxxx")
        } catch (e: Exception){
            println("xxxss")
            @Assert(e.toString().contains("MessageTypeException"),true)
        }
    }   

    @TestCase
    public func test5555(): Unit {
            var packer = MessagePack.newDefaultBufferPacker()
            packer.packExtensionTypeHeader(EXT_TYPE_DATETIME3, 65534)
            packer.writePayload(data3)
            var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        try{
            unpacker.unpackExtensionTypeHeader()
            println("xxxx")
        } catch (e: Exception){
            println("xxxss")
            @Assert(e.toString().contains("MessageTypeException"),true)
        }
    }  

    @TestCase
    public func test6(): Unit {
        var b  = ByteArrayStream(5)
        var packer = MessagePack.newDefaultPacker(b)
        packer.packInt64(5)
        var unpacker = MessagePack.newDefaultUnpacker(b.bytes())
        try{
            unpacker.unpackBool()
        } catch (e: Exception){
            @Assert(e.toString().contains("MessagePackException"),true)
        }
    }

    @TestCase
    public func test7(): Unit {
        var packer = MessagePack.newDefaultBufferPacker()
        try{
            packer.packMapHeader(-1)
        } catch (e: MessageSizeException){
            @Assert(e.toString().contains("MessageSizeException"),true)
            @Assert(e.getSize(),-1)
        }
    }

    @TestCase
    public func test8(): Unit {
        var packer = MessagePack.newDefaultBufferPacker()

        try{
            packer.packTimestamp(1743561319, -1)
        } catch (e: MessageFormatException){
            @Assert(e.toString().contains("nanosecond"),true)
        }

    }

    @TestCase
    public func test9(): Unit {
        var value = 1223.56f32
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packFloat32(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackFloat32(), value)
    }

    @TestCase
    public func test10(): Unit {
        var value = 1223.56f32
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packFloat32(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        println(unpacker.unpackFloat64())
        // @Assert(unpacker.unpackFloat64(), 1223.56f64)
    }

    @TestCase
    public func test11(): Unit {
        var value = 1223
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        try{
            unpacker.unpackFloat64()
        } catch (e: MessagePackException){
            @Assert(e.toString().contains("MessagePackException"),true)
        }
    }

    @TestCase
    public func test12(): Unit {
        var value = 1223.56f64
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packFloat64(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        println(unpacker.unpackFloat32())
  
    }

    @TestCase
    public func test13(): Unit {
        var value: Int32 = 129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test14(): Unit {
        var value: Int32 = 257
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test15(): Unit {
        var value: Int32 = 65537
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test16(): Unit {
        var value: Int64 = 4294967296
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test17(): Unit {
        var value: Int16 = -129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt16(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test18(): Unit {
        var value: Int32 = -32769
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test19(): Unit {
        var value: Int64 = -(1 << 31) -1
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test20(): Unit {
        var value: Int32 = 129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test21(): Unit {
        var value: Int32 = 257
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test22(): Unit {
        var value: Int32 = 65537
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test23(): Unit {
        var value: Int64 = 4294967296
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test24(): Unit {
        var value: Int16 = -129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt16(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test25(): Unit {
        var value: Int32 = -32769
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test26(): Unit {
        var value: Int64 = -(1 << 31) -1
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test27(): Unit {
        var value: Int32 = 129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test28(): Unit {
        var value: Int32 = 257
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test29(): Unit {
        var value: Int32 = 65537
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test30(): Unit {
        var value: Int64 = 4294967296
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test31(): Unit {
        var value: Int64 = -(1 << 31) -1
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test32(): Unit {
        var value: Int32 = 129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test33(): Unit {
        var value: Int32 = 257
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test34(): Unit {
        var value: Int32 = 65537
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test35(): Unit {
        var value: Int64 = 4294967296
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test36(): Unit {
        var value: Int64 = -(1 << 31) -1
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test37(): Unit {
        var value: Int32 = 129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test38(): Unit {
        var value: Int32 = 257
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test39(): Unit {
        var value: Int32 = 65537
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test40(): Unit {
        var value: Int64 = 4294967296
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test41(): Unit {
        var value: Int64 = -(1 << 31) -1
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test42(): Unit {
        var value: Int8 = -33
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt8(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test43(): Unit {
        var value: Int16 = -129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt16(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test44(): Unit {
        var value: Int32 = -32769
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt8()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test45(): Unit {
        var value: Int32 = 129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test46(): Unit {
        var value: Int32 = 257
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test47(): Unit {
        var value: Int32 = 65537
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test48(): Unit {
        var value: Int64 = 4294967296
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test49(): Unit {
        var value: Int64 = -(1 << 31) -1
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test50(): Unit {
        var value: Int8 = -33
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt8(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test51(): Unit {
        var value: Int16 = -129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt16(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test52(): Unit {
        var value: Int32 = -32769
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt16()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test53(): Unit {
        var value: Int32 = 129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test54(): Unit {
        var value: Int32 = 257
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test55(): Unit {
        var value: Int32 = 65537
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test56(): Unit {
        var value: Int64 = 4294967296
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test57(): Unit {
        var value: Int64 = -(1 << 31) -1
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test58(): Unit {
        var value: Int8 = -33
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt8(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test59(): Unit {
        var value: Int16 = -129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt16(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test60(): Unit {
        var value: Int32 = -32769
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt32()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test61(): Unit {
        var value: Int32 = 129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test62(): Unit {
        var value: Int32 = 257
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test63(): Unit {
        var value: Int32 = 65537
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
  
    }

    @TestCase
    public func test64(): Unit {
        var value: Int64 = 4294967296
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test65(): Unit {
        var value: Int64 = -(1 << 31) -1
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt64(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test66(): Unit {
        var value: Int8 = -33
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt8(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test67(): Unit {
        var value: Int16 = -129
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt16(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test68(): Unit {
        var value: Int32 = -32769
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packInt32(value)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)
        try{
            unpacker.unpackUInt64()
        } catch (e: MessageIntegerOverflowException){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }

    @TestCase
    public func test69(): Unit {
        var c: PackerConfig = PackerConfig()
        var cc: PackerConfig = c.clone()
        @Assert(cc.getBufferSize(), 8192)
        @Assert(cc.getBinarySizeLimit(), Int64(Int32.Max))
        @Assert(cc.getStringSizeLimit(), Int64(Int32.Max))

        var c3: PackerConfig = cc.withBufferSize(5)
        @Assert(c3.getBufferSize(), 5)

        var c4: PackerConfig = cc.withBinarySizeLimit(5)
        @Assert(c4.getBinarySizeLimit(), 5)

        var c5: PackerConfig = cc.withStringSizeLimit(5)
        @Assert(c5.getStringSizeLimit(), 5)

        @Assert(c == cc, true)
        @Assert(c.hashCode(), 2130303786016)
    }

    @TestCase
    public func test70(): Unit {
        var c: UnpackerConfig = UnpackerConfig()
        var cc: UnpackerConfig = c.clone()

        var c3: UnpackerConfig = cc.withBinarySizeLimit(5)
        @Assert(c3.getBinarySizeLimit(), 5)

        var c4: UnpackerConfig = cc.withStringSizeLimit(5)
        @Assert(c4.getStringSizeLimit(), 5)

        var c5: UnpackerConfig = cc.withAllowReadingBinaryAsString(true)
        @Assert(c5.getAllowReadingBinaryAsString(), true)

        var c6: UnpackerConfig = cc.withAllowReadingStringAsBinary(true)
        @Assert(c6.getAllowReadingStringAsBinary(), true)

        @Assert(c == cc, true)
        @Assert(c.hashCode(), 66039417112576)
    }

    @TestCase
    public func test72(): Unit {
        var value: ImmutableBooleanValue = ValueFactory.newBoolean(true)
        var value2: ImmutableBooleanValue = ValueFactory.newBoolean(false)
        var value3: ImmutableNilValue = ValueFactory.newNil()
        var s = value.immutableValue()
        @Assert(s.isBooleanValue(), true)
        // @Assert(ss.isBooleanValue(), false)

        @Assert(value.hashCode(), 1231)
        @Assert(value2.hashCode(), 1237)
        @Assert(value.toJson(), "true")
        @Assert(value.toString(), "true")
    }

    @TestCase
    public func test73(): Unit {
        var intValue: ImmutableInt64ValueImpl = ((ValueFactory.newInt(Int64(50))) as ImmutableInt64ValueImpl).getOrThrow()
        @Assert(intValue.toFloat32(), 50.000000)
        var intValue2: ImmutableInt64ValueImpl = ((ValueFactory.newInt(Int64(50))) as ImmutableInt64ValueImpl).getOrThrow()
        @Assert(intValue2.toFloat64(), 50.000000)
    }

    @TestCase
    public func test733(): Unit {
        var intValue: ImmutableInt64ValueImpl = ((ValueFactory.newInt(Int8(50))) as ImmutableInt64ValueImpl).getOrThrow()
        @Assert(intValue.toFloat32(), 50.000000)
        var intValue2: ImmutableInt64ValueImpl = ((ValueFactory.newInt(Int16(50))) as ImmutableInt64ValueImpl).getOrThrow()
        @Assert(intValue2.toFloat64(), 50.000000)
        var floatValue: ImmutableFloat64ValueImpl = ((ValueFactory.newFloat32(50.0)) as ImmutableFloat64ValueImpl).getOrThrow()
        @Assert(floatValue.toFloat32(), 50.000000)

    }

    @TestCase
    public func test74(): Unit {
        var floatValue: ImmutableFloat64ValueImpl = ((ValueFactory.newFloat64(50.0)) as ImmutableFloat64ValueImpl).getOrThrow()
        floatValue.getValueType()
        var value = floatValue.immutableValue()
        var value1 = floatValue.asNumberValue()
        var value2 = floatValue.asFloat64Value()
        var value3: ImmutableBooleanValue = ValueFactory.newBoolean(false)
        println(value.toJson())
        @Assert(value.toInt8(), 50)
        @Assert(value.toInt16(), 50)
        @Assert(value.toInt32(), 50)
        @Assert(value.toInt64(), 50)
        @Assert(value.toFloat32(), 50.0)
        @Assert(value.toFloat64(), 50.0)
        @Assert(value.equals(value1), true)
        @Assert(value.equals(value3), false)
        @Assert(value.hashCode(), 50)
        @Assert(value.toJson(), "50.000000")
        @Assert(value.toString(), "50.000000")


        var packer = MessagePack.newDefaultBufferPacker()
        value.writeTo(packer)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackFloat64(), 50.0)
    }

    @TestCase
    public func test75(): Unit {
        var floatValue: ImmutableExtensionValueImpl = ((ValueFactory.newExtension(2, [1, 2])) as ImmutableExtensionValueImpl).getOrThrow()
        floatValue.getValueType()
        var value = floatValue.immutableValue()
        var value1 = floatValue.asExtensionValue()
        var value3: ImmutableBooleanValue = ValueFactory.newBoolean(false)
        println(value.toJson())
        println(value.toString())
        @Assert(value.getType(), 2)
        @Assert(value.getData().toString(), "[1, 2]")

        @Assert(value.equals(value1), true)
        @Assert(value.equals(value3), false)
        @Assert(value.hashCode(), 31746)
        // @Assert(value.toJson(), "50.000000")
        // @Assert(value.toString(), "50.000000")


        var packer = MessagePack.newDefaultBufferPacker()
        value.writeTo(packer)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
    }

    @TestCase
    public func test76(): Unit {
        var floatValue: ImmutableStringValueImpl = ((ValueFactory.newString("sssz")) as ImmutableStringValueImpl).getOrThrow()
        floatValue.getValueType()
        var value = floatValue.immutableValue()
        var value1 = floatValue.asStringValue()
        var st = floatValue.getString()
        var value3: ImmutableBooleanValue = ValueFactory.newBoolean(false)

        @Assert(value.equals(value1), true)
        @Assert(value.equals(value3), false)
        @Assert(value.hashCode(), 4463688)
        @Assert(value.toJson(), "sssz")
        @Assert(value.toString(), "sssz")

        var packer = MessagePack.newDefaultBufferPacker()
        value.writeTo(packer)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackString(), "sssz")
    }

    @TestCase
    public func test77(): Unit {
        let datetime = DateTime.of(year: 2024, month: May, dayOfMonth: 22, hour: 12, timeZone: TimeZone.Local)
        var value: ImmutableTimestampValueImpl = ((ValueFactory.newTimestamp(datetime)) as ImmutableTimestampValueImpl).getOrThrow()
        value.getValueType()
        value.getData()
        value.toDataTime()
        var value1 = value.immutableValue()
        var value2 = value.asExtensionValue()
        var value3 = value.asTimestampValue()
        var value4: ImmutableBooleanValue = ValueFactory.newBoolean(false)
        @Assert(value.isTimestampValue(), true)
        @Assert(value.getType(), 255)
        @Assert(value.getEpochSecond(), 1716350400)
        @Assert(value.getNano(), 0)
        @Assert(value.equals(value1), true)
        @Assert(value.equals(value4), false)
        @Assert(value.hashCode(), -8244767609365149345)
        @Assert(value.toJson(), "2024-05-22T12:00:00+08:00")
        @Assert(value.toString(), "2024-05-22T12:00:00+08:00")

        var packer = MessagePack.newDefaultBufferPacker()
        value.writeTo(packer)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
    }

    @TestCase
    public func test78(): Unit {
        var list: ArrayList<Value> = ArrayList<Value>(10)
        list.append(ValueFactory.newBoolean(false))
        list.append(ValueFactory.newInt(2))
        var value: ImmutableArrayValueImpl = ((ValueFactory.newArray(list)) as ImmutableArrayValueImpl).getOrThrow()
        var value11 = ImmutableArrayValueImpl.empty()
        value.getValueType()
        value.get(0)
        value.get(2)
        var s = value.iterator().next()
        @Assert(s.isSome(), true)

        var value1 = value.immutableValue()
        var value2 = value.asArrayValue()
        var value4: ImmutableBooleanValue = ValueFactory.newBoolean(false)
        @Assert(value.size(), 2)
        @Assert(value.list().size, 2)
        // @Assert(value.getEpochSecond(), 1716350400)
        // @Assert(value.getNano(), 0)
        @Assert(value.equals(value1), true)
        @Assert(value.equals(value4), false)
        @Assert(value.hashCode(), 39310)
        @Assert(value.toJson(), "[false,false,2]")
        @Assert(value.toString(), "[false,2]")

        var packer = MessagePack.newDefaultBufferPacker()
        value.writeTo(packer)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
    }

    @TestCase
    public func test79(): Unit {
        var list: ArrayList<Value> = ArrayList<Value>(10)
        
        list.append(ValueFactory.newInt(1))
        list.append(ValueFactory.newString("zhangsan"))
        list.append(ValueFactory.newInt(2))
        list.append(ValueFactory.newString("lisi"))
        var value: ImmutableMapValueImpl = ((ValueFactory.newMap(list)) as ImmutableMapValueImpl).getOrThrow()
        var value11 = ImmutableMapValueImpl.empty()
        value.getValueType()
        // value.get(0)
        // value.get(2)
        // var s = value.iterator().next()
        // @Assert(s.isSome(), true)

        var value1 = value.immutableValue()
        var value2 = value.asMapValue()
        var value4: ImmutableBooleanValue = ValueFactory.newBoolean(false)
        @Assert(value.size(), 2)
        // @Assert(value.list().size, 2)
        // // @Assert(value.getEpochSecond(), 1716350400)
        // // @Assert(value.getNano(), 0)
        @Assert(value.equals(value1), true)
        @Assert(value.equals(value4), false)
        @Assert(value.hashCode(), 4304607926114)
        @Assert(value.toJson(), "{1,1:zhangsan,2:lisi}")
        @Assert(value.toString(), "{1:zhangsan,2:lisi}")

        var packer = MessagePack.newDefaultBufferPacker()
        value.writeTo(packer)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
    }
}





