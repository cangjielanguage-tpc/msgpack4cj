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
public class MessageTestImmutableIntFloat {
    @TestCase
    public func test1(): Unit {
        var intValue: Value = ValueFactory.newInt(Int64(9876543210))
        @Assert(intValue.isIntValue(), true)

        @Assert(intValue.asIntValue().toInt64(), 9876543210)
        @Assert(intValue.asIntValue().isInInt64Range(), true)
        @Assert(intValue.asIntValue().isInInt32Range(), false)
        @Assert(intValue.asIntValue().isInInt16Range(), false)
        @Assert(intValue.asIntValue().isInInt8Range(), false)
        @Assert(intValue.asIntValue().toInt32(), 1286608618)
        @Assert(intValue.asIntValue().toInt16(), 5866)
        @Assert(intValue.asIntValue().toInt8(), -22)
    }

    @TestCase
    public func test2(): Unit {
        var intValue: ImmutableIntValue = ValueFactory.newInt(Int64(9876543210))
        @Assert(intValue.isIntValue(), true)

        @Assert(intValue.toInt64(), 9876543210)
        @Assert(intValue.isInInt64Range(), true)
        @Assert(intValue.isInInt32Range(), false)
        @Assert(intValue.isInInt16Range(), false)
        @Assert(intValue.isInInt8Range(), false)
        @Assert(intValue.toInt32(), 1286608618)
        @Assert(intValue.toInt16(), 5866)
        @Assert(intValue.toInt8(), -22)
    }

    @TestCase
    public func test3(): Unit {
        var intValue: ImmutableInt64ValueImpl = ((ValueFactory.newInt(Int64(9876543210))) as ImmutableInt64ValueImpl).getOrThrow()
        @Assert(intValue.isIntValue(), true)

        @Assert(intValue.immutableValue().toInt64(), 9876543210)
        @Assert(intValue.asIntValue().isInInt64Range(), true)
        @Assert(intValue.asNumberValue().toInt64(), 9876543210)
    }

    @TestCase
    public func test4(): Unit {
        var intValue: Value = ValueFactory.newInt(Int32(987688))
        @Assert(intValue.isIntValue(), true)

        @Assert(intValue.asIntValue().toInt64(), 987688)
        @Assert(intValue.asIntValue().toInt32(), 987688)

        @Assert(intValue.asIntValue().asInt64(), 987688)
        @Assert(intValue.asIntValue().asInt32(), 987688)
        @Assert(intValue.asIntValue().isInInt64Range(), true)
        @Assert(intValue.asIntValue().isInInt32Range(), true)
        @Assert(intValue.asIntValue().isInInt16Range(), false)
        @Assert(intValue.asIntValue().isInInt8Range(), false)
        @Assert(intValue.asIntValue().toInt16(), 4648)
        @Assert(intValue.asIntValue().toInt8(), 40)
        try{
            var s: Int8 = intValue.asIntValue().asInt8()
        } catch (e: Exception){
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }

        try{
            var s: Int16 = intValue.asIntValue().asInt16()
        } catch (e: Exception){
            println((e as MessageIntegerOverflowException).getOrThrow().getBigInteger().toString())
            @Assert(e.toString().contains("MessageIntegerOverflowException"),true)
        }
    }


    @TestCase
    public func test5(): Unit {
        var intValue: Value = ValueFactory.newInt(-9223372036854775808i64)
        var packer = MessagePack.newDefaultBufferPacker()
        intValue.writeTo(packer)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackInt64(), -9223372036854775808i64)
    }

    @TestCase
    public func test6(): Unit {
        var intValue: Value = ValueFactory.newInt(-9223372036854775808i64)
        var packer = MessagePack.newDefaultBufferPacker()

        packer.packValue(intValue)

        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        @Assert(unpacker.unpackInt64(), -9223372036854775808i64)
    }

    @TestCase
    public func test7(): Unit {
        var intValue: Value = ValueFactory.newInt(-9223372036854775808i64)
        var intValue2: Value = ValueFactory.newInt(-9223372036854775808i64)
        var intValue3: Value = ValueFactory.newInt(-9223372033i64)
        @Assert(intValue.equals(intValue2), true)
        @Assert(intValue.equals(intValue3), false)
        @Assert(intValue.hashCode(), -9223372034707292160)

        @Assert(intValue.toJson(), "-9223372036854775808")
        @Assert(intValue.toString(), "-9223372036854775808")
    }
}