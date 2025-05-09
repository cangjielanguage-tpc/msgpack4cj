/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

public abstract class AbstractImmutableValue <: ImmutableValue
{
    public override func isNilValue(): Bool {
        return getValueType().isNilType()
    }

    public override func isBooleanValue(): Bool {
        return getValueType().isBooleanType()
    }

    public override func isIntValue(): Bool {
        return getValueType().isIntType()
    }

    public override func isFloat64Value(): Bool {
        return getValueType().isFloat64Type()
    }

    public override func isByteValue(): Bool {
        return getValueType().isByteType()
    }

    public override func isStringValue(): Bool {
        return getValueType().isStringType()
    }

    public override func isArrayValue(): Bool
    {
        return getValueType().isArrayType()
    }

    public override func isMapValue(): Bool
    {
        return getValueType().isMapType()
    }

    public override func isExtensionValue(): Bool
    {
        return getValueType().isExtensionType()
    }

    public open override func isTimestampValue(): Bool
    {
        return false
    }

    public open func asNilValue(): ImmutableNilValue {
        throw MessagePackException()
    }

    public open func asBooleanValue(): ImmutableBooleanValue {
        throw MessagePackException()
    }

    public open func asNumberValue(): ImmutableNumberValue {
        throw MessagePackException()
    }

    public open func asArrayValue(): ImmutableArrayValue {
        throw MessagePackException()
    }

    public open func asByteValue(): ImmutableByteValue {
        throw MessagePackException()
    }

    public open func asExtensionValue(): ImmutableExtensionValue
    {
        throw MessagePackException()
    }

    public open func asFloat64Value(): ImmutableFloat64Value
    {
        throw MessagePackException()
    }

    public open func asIntValue(): ImmutableIntValue
    {
        throw MessagePackException()
    }

    public open func asMapValue(): ImmutableMapValue
    {
        throw MessagePackException()
    }

    public open func asStringValue(): ImmutableStringValue
    {
        throw MessagePackException()
    }

    public open func asTimestampValue(): ImmutableTimestampValue
    {
        throw MessagePackException()
    }
}

public interface ImmutableValue<: Value {

    func asBooleanValue(): ImmutableBooleanValue

    func asNilValue(): ImmutableNilValue

    func asIntValue(): ImmutableIntValue

    func asFloat64Value(): ImmutableFloat64Value

    func asArrayValue(): ImmutableArrayValue

    func asMapValue(): ImmutableMapValue

    func asStringValue(): ImmutableStringValue

    func asTimestampValue(): ImmutableTimestampValue

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

    func list(): ArrayList<Value>
}

public interface ImmutableByteValue
        <: ByteValue & ImmutableValue
{
}

public interface ImmutableIntValue <: IntValue & ImmutableNumberValue
{
}

public interface ImmutableExtensionValue
        <: ExtensionValue & ImmutableValue
{
}

public interface ImmutableFloat64Value
        <: Float64Value & ImmutableNumberValue
{
}

public interface ImmutableMapValue
        <: MapValue & ImmutableValue
{
}

public interface ImmutableStringValue
        <: StringValue & ImmutableValue
{
}

public interface ImmutableTimestampValue
        <: TimestampValue & ImmutableValue
{
}