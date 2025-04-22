/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core
import std.io.ByteBuffer
import std.collection.Set

public interface Value {

    func getValueType(): ValueType
    
    func immutableValue(): ImmutableValue

    func isNilValue(): Bool

    func isBooleanValue(): Bool

    func isNumberValue(): Bool

    func isIntValue(): Bool

    func isFloat32Value(): Bool

    func isRawValue(): Bool

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

    func asFloat32Value(): Float32Value

    func asRawValue(): RawValue

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

public interface Float32Value  <: NumberValue
{
}

public interface ExtensionValue <: Value
{
    func getType(): Byte

    func getData(): Array<Byte>
}

public interface StringValue <: RawValue
{
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

    func getNano(): Int32

    func toEpochMillis(): Int64
}

public interface ArrayValue
        <: Value & Iterable<Value>
{
    func size(): Int64

    func get(index: Int64): ?Value

    func iterator(): Iterator<Value>

    func list(): Array<Value>
}

public interface MapValue <: Value
{
    func size(): Int64

    func keySet(): Set<Value>

    func getKeyValueArray(): Array<Value>
}