/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj

import std.io.OutputStream
import std.binary.BigEndianOrder
import std.collection.ArrayList
import std.time.*

public class ValueFactory {

    public static func newNil(): ImmutableNilValue {
        return ImmutableNilValueImpl.get()
    }

    public static func newBoolean(value: Bool): ImmutableBooleanValue {
        if (value) {
            return ImmutableBooleanValueImpl.TRUE
        } else {
            return ImmutableBooleanValueImpl.FALSE
        }
    }

    public static func newInt(v: Int8): ImmutableIntValue {
        return  ImmutableInt64ValueImpl(Int64(v))
    }

    public static func newInt(v: Int16): ImmutableIntValue {
        return  ImmutableInt64ValueImpl(Int64(v))
    }

    public static func newInt(v: Int32): ImmutableIntValue {
        return  ImmutableInt64ValueImpl(Int64(v))
    }

    public static func newInt(v: Int64): ImmutableIntValue {
        return  ImmutableInt64ValueImpl(v)
    }

    public static func newFloat32(v: Float32): ImmutableFloat64Value {
        return  ImmutableFloat64ValueImpl(Float64(v))
    }

    public static func newFloat64(v: Float64): ImmutableFloat64Value {
        return  ImmutableFloat64ValueImpl(v)
    }

    public static func newString(v: String): ImmutableStringValue {
        return  ImmutableStringValueImpl(v)
    }

    public static func newArray(list: List<Value>): ImmutableArrayValue {
        if (list.isEmpty()) {
            return ImmutableArrayValueImpl.empty()
        }
        return  ImmutableArrayValueImpl(list.toArray())
    }

    public static func newMap(list: List<Value>): ImmutableMapValue {
        if (list.isEmpty()) {
            return ImmutableMapValueImpl.empty()
        }
        return  ImmutableMapValueImpl(list.toArray())
    }

    public static func newExtension(dataType: Byte, data: Array<Byte>): ImmutableExtensionValue {

        return  ImmutableExtensionValueImpl(dataType, data)
    }


    public static func newTimestamp(dataTime: DateTime): ImmutableTimestampValue {

        return  ImmutableTimestampValueImpl(dataTime)
    }

}