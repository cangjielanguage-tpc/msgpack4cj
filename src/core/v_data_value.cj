/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core
import std.io.ByteBuffer
import std.collection.Set
internal import std.collection.List
internal import std.collection.ArrayList
internal import std.time.*

public interface Value<: Hashable & ToString {

    func getValueType(): ValueType
    
    func immutableValue(): ImmutableValue

    func isNilValue(): Bool

    func isBooleanValue(): Bool

    func isIntValue(): Bool

    func isFloat64Value(): Bool

    func isByteValue(): Bool

    func isStringValue(): Bool

    func isArrayValue(): Bool

    func isMapValue(): Bool

    func isExtensionValue(): Bool

    func isTimestampValue(): Bool

    func asNilValue(): NilValue

    func asBooleanValue(): BooleanValue

    func asNumberValue(): NumberValue

    func asIntValue(): IntValue

    func asFloat64Value(): Float64Value

    func asByteValue(): ByteValue

    func asStringValue(): StringValue

    func asArrayValue(): ArrayValue

    func asMapValue(): MapValue

    func asExtensionValue(): ExtensionValue

    func asTimestampValue(): TimestampValue

    func writeTo(pk: MessagePacker): Unit

    func equals(obj: Value): Bool

    func toJson(): String

}

public interface ByteValue
        <: RawValue
{
}

public interface BooleanValue<: Value {

    func getBoolean(): Bool
    
}

public interface NilValue<: Value
{

}

public interface Float64Value  <: NumberValue
{
}

public interface ExtensionValue <: Value
{
    func getType(): Byte

    func getData(): Array<Byte>
}

public interface StringValue <: Value
{
    func getString(): String
}

public interface RawValue <: Value
{
    func asByteArray(): Array<Byte>

    func asByteBuffer(): ByteBuffer

    func asString(): String

    func toString(): String
}

public interface TimestampValue <: ExtensionValue
{
    func getEpochSecond(): Int64

    func getNano(): Int64

    func toDataTime(): DateTime
}

public interface ArrayValue
        <: Value & Iterable<Value>
{
    func size(): Int64

    func get(index: Int64): ?Value

    func iterator(): Iterator<Value>

    func list(): List<Value>
}

public interface MapValue <: Value
{
    func size(): Int64

}

public interface NumberValue <: Value
{
    func toInt8(): Int8

    func toInt16(): Int16

    func toInt32(): Int32

    func toInt64(): Int64

    func toFloat32(): Float32

    func toFloat64(): Float64
}
public interface IntValue <: NumberValue
{
    func isInInt8Range(): Bool

    func isInInt16Range(): Bool

    func isInInt32Range(): Bool

    func isInInt64Range(): Bool

    func asInt8(): Int8

    func asInt16(): Int16

    func asInt32(): Int32

    func asInt64(): Int64
}