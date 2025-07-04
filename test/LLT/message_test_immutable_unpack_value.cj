// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.time.MonoTime
import std.unittest.*
import std.unittest.testmacro.*
import msgpack4cj.core.*
import msgpack4cj.serialization.*

import std.io.ByteBuffer
import std.io.readToEnd
import std.binary.BigEndianOrder
import std.collection.ArrayList
import std.collection.List
import std.time.*
import std.io.copy


@Test
public class MessageTestImmutableUnpackValue {
    @TestCase
    public func test5(): Unit {
        var intValue: ImmutableIntValue = ValueFactory.newInt(-9223372036854775808i64)
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packValue(intValue)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())

        var immutableValue: ImmutableValue = unpacker.unpackValue()
        
        var isIntValue: Bool = immutableValue.isIntValue()
        if (isIntValue) {
            var i: Int64 = immutableValue.asIntValue().asInt64()
            @Assert(i, -9223372036854775808i64)
        }
    }

    @TestCase
    public func test6(): Unit {

        var value: Value = ValueFactory.newNil()
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packValue(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())

        var immutableValue: ImmutableValue = unpacker.unpackValue()
        
        var isValue: Bool = immutableValue.isNilValue()
        @Assert(isValue, true)
    }

    @TestCase
    public func test7(): Unit {

        var value: Value = ValueFactory.newBoolean(true)
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packValue(value)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())

        var immutableValue: ImmutableValue = unpacker.unpackValue()
        
        var isValue: Bool = immutableValue.isBooleanValue()
        @Assert(isValue, true)
        if (isValue) {
            var i: Bool = immutableValue.asBooleanValue().getBoolean()
            @Assert(i, true)
        }
    }

    @TestCase
    public func test8(): Unit {
        var intValue: ImmutableFloat64Value = ValueFactory.newFloat64(150.234f64)
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packValue(intValue)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())

        var immutableValue: ImmutableValue = unpacker.unpackValue()
        
        var isValue: Bool = immutableValue.isFloat64Value()
        if (isValue) {
            var i: Float64 = immutableValue.asFloat64Value().toFloat64()
            @Assert(i, 150.234f64)
        }
    }

    @TestCase
    public func test9(): Unit {
        var intValue: ImmutableStringValue = ValueFactory.newString("zhangsan")
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packValue(intValue)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())

        var immutableValue: ImmutableValue = unpacker.unpackValue()
        
        var isValue: Bool = immutableValue.isStringValue()
        if (isValue) {
            var i: String = immutableValue.asStringValue().getString()
            @Assert(i, "zhangsan")
        }
    }

    @TestCase
    public func test10(): Unit {
        var list: ArrayList<Value> = ArrayList<Value>(10)
        list.add(ValueFactory.newBoolean(false))
        list.add(ValueFactory.newInt(50))
     
        var intValue: ImmutableArrayValue = ValueFactory.newArray(list)

        var packer = MessagePack.newDefaultBufferPacker()
        packer.packValue(intValue)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)

        var immutableValue: ImmutableValue = unpacker.unpackValue()
        
        var isValue: Bool = immutableValue.isArrayValue()
        @Assert(isValue, true)

        if (isValue) {
            var i: ImmutableArrayValue = immutableValue.asArrayValue()
            var list: List<Value> = i.list()
            for (v in list) {
                if (v.isBooleanValue()) {
                    var data = v.asBooleanValue().getBoolean()
                    @Assert(data, false)
                }
                if (v.isIntValue()) {
                    var data = v.asIntValue().asInt64()
                    @Assert(data, 50)
                }
            }

        }
    }

    @TestCase
    public func test11(): Unit {
        var list: ArrayList<Value> = ArrayList<Value>(10)
        
        list.add(ValueFactory.newInt(1))
        list.add(ValueFactory.newString("zhangsan"))
        list.add(ValueFactory.newInt(2))
        list.add(ValueFactory.newString("lisi"))
     
        var intValue: ImmutableMapValue = ValueFactory.newMap(list)

        var packer = MessagePack.newDefaultBufferPacker()
        packer.packValue(intValue)
        var s = packer.toByteArray()
        var unpacker = MessagePack.newDefaultUnpacker(s)

        var immutableValue: ImmutableValue = unpacker.unpackValue()
        
        var isValue: Bool = immutableValue.isMapValue()
        @Assert(isValue, true)
    }


}