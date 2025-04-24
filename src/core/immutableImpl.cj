/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

import std.math.numeric.*
import std.io.InputStream
import std.io.ByteBuffer
import std.binary.BigEndianOrder
import std.time.DateTime
public class ImmutableNilValueImpl <: AbstractImmutableValue & ImmutableNilValue & Hashable & ToString {


    public static let instance: ImmutableNilValue = ImmutableNilValueImpl()


    public static func get(): ImmutableNilValue {
        return instance
    }

    private init() {
    }

    public override func getValueType(): ValueType {
        return ValueType.NONE(false, false)
    }

    public override func asNilValue(): ImmutableNilValue {
        return this
    }

    public override func immutableValue(): ImmutableNilValue {
        return this
    }


    public override func writeTo(packer: MessagePacker): Unit {
        packer.packNull()
    }

    public override func equals(v: Value): Bool {
        return v.isNilValue()
    }

    public func hashCode(): Int64 {
        return 0
    }

    public override func toJson(): String {
        return "None"
    }

    public func toString(): String {
        return toJson()
    }
}

public class ImmutableBooleanValueImpl <: AbstractImmutableValue & ImmutableBooleanValue & Hashable & ToString {


    public static let TRUE: ImmutableBooleanValue = ImmutableBooleanValueImpl(true)
    public static let FALSE: ImmutableBooleanValue = ImmutableBooleanValueImpl(false)
    private let value: Bool

    private init(value: Bool) {
        this.value = value
    }

    public override func getValueType(): ValueType {
        return ValueType.BOOL(false, false)
    }

    public override func asBooleanValue(): ImmutableBooleanValue {
        return this
    }

    public override func immutableValue(): ImmutableBooleanValue {
        return this
    }

    public override func getBoolean(): Bool {
        return value
    }

    public override func writeTo(packer: MessagePacker): Unit {
        packer.packBool(value)
    }

    public override func equals(v: Value): Bool {
        if (!v.isBooleanValue()) {
            return false
        }
        return value == v.asBooleanValue().getBoolean()
    }

    public func hashCode(): Int64 {
        if (value) {
            return 1231
        }
        else {
            return 1237
        }
    }

    public override func toJson(): String {
        return value.toString()
    }

    public func toString(): String {
        return toJson()
    }
}

public class ImmutableInt64ValueImpl <: AbstractImmutableValue & ImmutableIntValue & Hashable & ToString {


    private let value: Int64

    public static let BYTE_MIN: Int64 = Int64(Int8.Min)
    public static let BYTE_MAX: Int64 = Int64(Int8.Max)

    public static let INT16_MIN: Int64 = Int64(Int16.Min)
    public static let INT16_MAX: Int64 = Int64(Int16.Max)

    public static let INT32_MIN: Int64 = Int64(Int32.Min)
    public static let INT32_MAX: Int64 = Int64(Int32.Max)


    public init(value: Int64) {
        this.value = value
    }

    public override func getValueType(): ValueType {
        return ValueType.INT(true, false)
    }

    public override func immutableValue(): ImmutableIntValue {
        return this
    }

    public override func asNumberValue(): ImmutableNumberValue {
        return this
    }

    public override func asIntValue(): ImmutableIntValue {
        return this
    }

    public override func toInt8(): Int8 {
        return Int8(value)
    }

    public override func toInt16(): Int16 {
        return Int16(value)
    }

    public override func toInt32(): Int32 {
        return Int32(value)
    }

    public override func toInt64(): Int64 {
        return Int64(value)
    }

    public override func toFloat32(): Float32 {
        return Float32(value)
    }

    public override func toFloat64(): Float64 {
        return Float64(value)
    }

    public override func isInInt8Range(): Bool
    {
        return BYTE_MIN <= value && value <= BYTE_MAX
    }

    public override func isInInt16Range(): Bool
    {
        return INT16_MIN <= value && value <= INT16_MAX
    }

    public override func isInInt32Range(): Bool
    {
        return INT32_MIN <= value && value <= INT32_MAX
    }

    public override func isInInt64Range(): Bool
    {
        return true
    }

    public override func asInt8(): Int8
    {
        if (!isInInt8Range()) {
            throw MessageIntegerOverflowException(BigInt(value))
        }
        return Int8(value)
    }

    public override func asInt16(): Int16
    {
        if (!isInInt16Range()) {
            throw MessageIntegerOverflowException(BigInt(value))
        }
        return Int16(value)
    }

    public override func asInt32(): Int32
    {
        if (!isInInt32Range()) {
            throw MessageIntegerOverflowException(BigInt(value))
        }
        return Int32(value)
    }

    public override func asInt64(): Int64
    {
        return value
    }

    public override func writeTo(packer: MessagePacker): Unit {
        packer.packInt64(value)
    }

    public override func equals(v: Value): Bool {
        if (!v.isIntValue()) {
            return false
        }
        var intvalue: IntValue = v.asIntValue()
        if (!intvalue.isInInt64Range()) {
            return false
        }
        return value == intvalue.toInt64()
    }

    public func hashCode(): Int64 {
        if (INT32_MIN <= value && value <= INT32_MAX) {
            return Int64(value)
        }
        else {
            return Int64(value ^ rightShift(value, 32))
        }
    }

    func rightShift(value: Int64, bits: Int64): Int64 {
        let max: Int64 = Int64.Max
        let b = max >> (bits - 1)
        return b & (value >> bits)
    }

    public override func toJson(): String {
        return value.toString()
    }

    public func toString(): String {
        return toJson()
    }
}