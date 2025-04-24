/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core


public interface ImmutableValue<: Value {

    func asBooleanValue(): ImmutableBooleanValue

    func asNilValue(): ImmutableNilValue

}

public interface ImmutableBooleanValue <: BooleanValue & ImmutableValue {

}

public interface ImmutableNilValue <: NilValue & ImmutableValue {

}

public interface ImmutableNumberValue
        <: NumberValue & ImmutableValue
{
}

public interface ImmutableArrayValue
        <: ArrayValue & ImmutableValue
{
    func iterator(): Iterator<Value>

    func list(): Array<Value>
}

public interface ImmutableRawValue
        <: RawValue & ImmutableValue
{
}

public interface ImmutableByteValue
        <: ByteValue & ImmutableRawValue
{
}

public interface ImmutableIntValue <: IntValue & ImmutableNumberValue
{
}

public interface ImmutableExtensionValue
        <: ExtensionValue & ImmutableValue
{
}

public interface ImmutableFloat32Value
        <: Float32Value & ImmutableNumberValue
{
}

public interface ImmutableMapValue
        <: MapValue & ImmutableValue
{
}

public interface ImmutableStringValue
        <: StringValue & ImmutableRawValue
{
}

public interface ImmutableTimestampValue
        <: TimestampValue & ImmutableValue
{
}