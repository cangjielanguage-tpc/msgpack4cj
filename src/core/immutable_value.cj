/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core



abstract class AbstractImmutableValue <: ImmutableValue
{
    public override func isNilValue(): Bool {
        return getValueType().isNilType()
    }

    public override func isBooleanValue(): Bool {
        return getValueType().isBooleanType()
    }

    public override func isNumberValue(): Bool {
        return getValueType().isNumberType()
    }

    public override func isIntValue(): Bool {
        return getValueType().isIntType()
    }

    public override func isFloat32Value(): Bool {
        return getValueType().isFloat32Type()
    }

    public override func isRawValue(): Bool {
        return getValueType().isRawType()
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

    public override func isTimestampValue(): Bool
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

    public open func asFloat32Value(): ImmutableFloat32Value
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

    public open func asRawValue(): ImmutableRawValue
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

    // func mostSuccinctMessageFormat(): MessageFormat

    func asInt8(): Int8

    func asInt16(): Int16

    func asInt32(): Int32

    func asInt64(): Int64
}

public enum ValueType {

    | NONE(Bool, Bool)
    | BOOL(Bool, Bool)
    | INT(Bool, Bool)
    | FLOAT32(Bool, Bool)
    | STRING(Bool, Bool)
    | BYTE(Bool, Bool)
    | ARRAY(Bool, Bool)
    | MAP(Bool, Bool)
    | EXTENSION(Bool, Bool)

    public func isNilType(): Bool {
         match(this){
            case NONE(false, false) => return true
            case _ => false
         }
    }

    public func isBooleanType(): Bool{
         match(this){
            case BOOL(false, false) => return true
            case _ => false
         }
    }

    public func isNumberType(): Bool{
        return true
    }

    public func isRawType(): Bool{
        return true
    }

    public func isIntType(): Bool{
         match(this){
            case INT(true, false) => return true
            case _ => false
         }
    }

    public func isFloat32Type(): Bool{
         match(this){
            case FLOAT32(true, false) => return true
            case _ => false
         }
    }

    public func isStringType(): Bool{
         match(this){
            case STRING(false, true) => return true
            case _ => false
         }
    }

    public func isByteType(): Bool{
         match(this){
            case BYTE(false, true) => return true
            case _ => false
         }
    }


    public func isArrayType(): Bool{
         match(this){
            case ARRAY(false, false) => return true
            case _ => false
         }
    }

    public func isMapType(): Bool{
         match(this){
            case MAP(false, false) => return true
            case _ => false
         }
    }

    public func isExtensionType(): Bool{
         match(this){
            case EXTENSION(false, false) => return true
            case _ => false
         }
    }
}

public enum MessageFormat {
    | POSFIXINT(ValueType)
    | FIXMAP(ValueType)
    | FIXARRAY(ValueType)
    | FIXSTR(ValueType)
    | NIL(ValueType)
    | NEVER_USED(ValueType)
    | BOOLEAN(ValueType)
    | BIN8(ValueType)
    | BIN16(ValueType)
    | BIN32(ValueType)
    | EXT8(ValueType)
    | EXT16(ValueType)
    | EXT32(ValueType)
    | FLOAT32(ValueType)
    | FLOAT64(ValueType)
    | UINT8(ValueType)
    | UINT16(ValueType)
    | UINT32(ValueType)
    | UINT64(ValueType)
    | INT8(ValueType)
    | INT16(ValueType)
    | INT32(ValueType)
    | INT64(ValueType)
    | FIXEXT1(ValueType)
    | FIXEXT2(ValueType)
    | FIXEXT4(ValueType)
    | FIXEXT8(ValueType)
    | FIXEXT16(ValueType)
    | STR8(ValueType)
    | STR16(ValueType)
    | STR32(ValueType)
    | ARRAY16(ValueType)
    | ARRAY32(ValueType)
    | MAP16(ValueType)
    | MAP32(ValueType)
    | NEGFIXINT(ValueType)


}
