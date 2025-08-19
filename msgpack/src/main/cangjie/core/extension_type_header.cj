/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack.core

import std.io.ByteBuffer
import std.io.readToEnd
import std.binary.BigEndianOrder
import std.collection.ArrayList
import std.core.Exception

public class ExtensionTypeHeader<: Hashable & ToString {
    var typeHeader: Byte
    var length: Int32

    public init (typeHeader: Byte, length: Int32) {
        this.typeHeader = typeHeader
        this.length = length
        checkArgument(length >= 0, "length must be >= 0")
    }

    public static func checkedCastToByte(code: Int32): Byte {
        checkArgument(Int32(UInt8.Min) <= code && code <= Int32(UInt8.Max), "Extension type code must be within the range of byte")
        return UInt8(code)
    }

    public func getType(): Byte {
        return typeHeader

    }

    public func isTimestampType(): Bool {
        return typeHeader == EXT_TIMESTAMP
    }

    public func getLength(): Int32 {
        return length

    }

    public func hashCode(): Int64
    {
        return Int64(typeHeader + 31) * 31 + Int64(length)
    }

    public func equals(obj: Object): Bool {
        if (obj is ExtensionTypeHeader) {
            var other: ExtensionTypeHeader = (obj as ExtensionTypeHeader).getOrThrow()
            return this.typeHeader == other.typeHeader && this.length == other.length
        }
        return false
    }


    private static func checkArgument(argument: Bool, info: String): Unit {
        if (!argument) {
            throw IllegalArgumentException(info)
        }
    }

    public func toString(): String {
        return "ExtensionTypeHeader(type:${typeHeader}, length:${length})"
    }
}