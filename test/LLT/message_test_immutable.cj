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
public class MessageTestImmutable {
    @TestCase
    public func test1(): Unit {
        var trueValue: Value = ValueFactory.newBoolean(true)
        var falseValue: Value = ValueFactory.newBoolean(false)
        @Assert(trueValue.isBooleanValue(), true)
        @Assert(trueValue.asBooleanValue().getBoolean(), true)

        @Assert(falseValue.isBooleanValue(), true)
        @Assert(falseValue.asBooleanValue().getBoolean(), false)
    }

    @TestCase
    public func test2(): Unit {
        var trueValue: Value = ValueFactory.newBoolean(true)
        var falseValue: Value = ValueFactory.newBoolean(false)
    
        let buffer = ByteBuffer()
        var packer = MessagePacker(buffer)

        trueValue.writeTo(packer)
        falseValue.writeTo(packer)

        println(buffer.bytes())
        var unpacker = MessageUnpacker(buffer)

        @Assert(unpacker.unpackBool(), trueValue.asBooleanValue().getBoolean())
        @Assert(unpacker.unpackBool(), falseValue.asBooleanValue().getBoolean())
    }

    @TestCase
    public func test3(): Unit {
        var trueValue: Value = ValueFactory.newBoolean(true)
        var falseValue: Value = ValueFactory.newBoolean(false)
    
        let buffer = ByteBuffer()
        var packer = MessagePacker(buffer)

        packer.packValue(trueValue)
        packer.packValue(falseValue)

        println(buffer.bytes())
        var unpacker = MessageUnpacker(buffer)

        @Assert(unpacker.unpackBool(), trueValue.asBooleanValue().getBoolean())
        @Assert(unpacker.unpackBool(), falseValue.asBooleanValue().getBoolean())
    }

    @TestCase
    public func test4(): Unit {
        var trueValue1: Value = ValueFactory.newBoolean(true)
        var trueValue2: Value = ValueFactory.newBoolean(true)
        var falseValue: Value = ValueFactory.newBoolean(false)
        @Assert(trueValue1.equals(trueValue2), true)
        @Assert(trueValue1.equals(falseValue), false)
    }

    @TestCase
    public func test5(): Unit {
        var value: Value = ValueFactory.newNil()
        let buffer = ByteBuffer()
        var packer = MessagePacker(buffer)

        packer.packValue(value)

        println(buffer.bytes())
        var unpacker = MessageUnpacker(buffer)
        unpacker.unpackNull()

        @Assert(value.isNilValue(), true)
    }


    @TestCase
    public func test6(): Unit {
        var value: Value = ValueFactory.newNil()
        let buffer = ByteBuffer()
        var packer = MessagePacker(buffer)

        value.writeTo(packer)

        println(buffer.bytes()) // 192
        var unpacker = MessageUnpacker(buffer)
        unpacker.unpackNull()

        @Assert(value.isNilValue(), true)
    }
}