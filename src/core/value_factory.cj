/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

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
}