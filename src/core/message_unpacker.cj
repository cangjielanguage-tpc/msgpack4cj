/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

import std.io.InputStream
import std.io.ByteBuffer
import std.binary.BigEndianOrder
import std.time.DateTime

public class MessageUnpacker {
    
    private let input: InputStream

    private var current: ?Byte = None

    public init(content: Array<Byte>) {
        this.input = ByteBuffer(content)
    }

    public init(input: InputStream) {
        this.input = input
    }

    public func nextFlag(): Byte {
        return readByte()
    }

    public func unpackBool(): Bool {
        let flag = current ?? nextFlag()
        current = None
        if (flag == TRUE) {
            return true
        }
        if (flag == FALSE) {
            return false
        }
        throw IllegalArgumentException("this is not bool flag")
    }

    @OverflowWrapping
    public func unpackInt(): Int {
        let flag = current ?? nextFlag()
        current = None
        if (flag >= POSITIVE_FIXINT_MIN && flag <= POSITIVE_FIXINT_MAX) {
            return Int64(flag)
        }
        if (flag >= NEGATIVE_FIXINT_MIN && flag <= NEGATIVE_FIXINT_MAX) {
            return Int64(Int8(flag))
        }
        //int8
        if (flag == INT8) {
            let uint8 = readByte()
            return Int64(Int8(uint8))
        }
        //int16
        if (flag == INT16) {
            let slice = readBytes(2)
            return Int64(Int16.readBigEndian(slice))
        }
        //int32
        if (flag == INT32) {
            let slice = readBytes(4)
            return Int64(Int32.readBigEndian(slice))
        }
        //int64
        if (flag == INT64) {
            let slice = readBytes(8)
            return Int64.readBigEndian(slice)
        }

        //uint8
        if (flag == UINT8) {
            let uint8 = readByte()
            return Int64(uint8)
        }
        //uint16
        if (flag == UINT16) {
            let slice = readBytes(2)
            return Int64(UInt16.readBigEndian(slice))
        }
        //uint32
        if (flag == UINT32) {
            let slice = readBytes(4)
            return Int64(UInt32.readBigEndian(slice))
        }
        //uint64
        if (flag == UINT64) {
            let slice = readBytes(8)
            return Int64(UInt64.readBigEndian(slice))
        }
        throw IllegalArgumentException("this is not int flag")
    }

    public func unpackNull(): Unit {
        let flag = current ?? nextFlag()
        current = None
        if (flag == NULL) {
        } else {
            throw IllegalArgumentException("this is not null type")
        }
    }

    public func unpackFloat64(): Float64 {
        let flag = current ?? nextFlag()
        current = None
        if (flag == FLOAT32) {
            let slice = readBytes(4)
            return Float64(Float32.readBigEndian(slice))
        }
        if (flag == FLOAT64) {
            let slice = readBytes(8)
            return Float64.readBigEndian(slice)
        }
        throw IllegalArgumentException("this is not float type")
    }

    public func unpackString(): String {
        let flag = current ?? nextFlag()
        current = None
        var size = 0
        if (flag >= FIXSTR_MIN && flag <= FIXSTR_MAX) {
            size = Int64(flag - FIXSTR_MIN)
        } else if (flag == STR8) {
            size = Int64(readByte())
        } else if (flag == STR16) {
            let slice = readBytes(2)
            size = Int64(UInt16.readBigEndian(slice))
        } else if (flag == STR32) {
            let slice = readBytes(4)
            size = Int64(UInt16.readBigEndian(slice))
        } else {
            throw IllegalArgumentException("this is not string type")
        }
        return String.fromUtf8(readBytes(size))
    }

    public func unpackMapHeader(): Int {
        let flag = current ?? nextFlag()
        current = None
        var size = 0
        if (flag >= FIXMAP_MIN && flag <= FIXMAP_MAX) {
            size = Int64(flag - FIXMAP_MIN)
        } else if (flag == MAP16) {
            let slice = readBytes(2)
            size = Int64(UInt16.readBigEndian(slice))
        } else if (flag == MAP32) {
            let slice = readBytes(4)
            size = Int64(UInt32.readBigEndian(slice))
        } else {
            throw IllegalArgumentException("this is not map type")
        }
        return size
    }

    public func unpackArrayHeader(): Int {
        let flag = current ?? nextFlag()
        current = None
        var size = 0
        if (flag >= FIXARR_MIN && flag <= FIXARR_MAX) {
            size = Int64(flag - FIXARR_MIN)
        } else if (flag == ARR16) {
            let slice = readBytes(2)
            size = Int64(UInt16.readBigEndian(slice))
        } else if (flag == ARR32) {
            let slice = readBytes(4)
            size = Int64(UInt32.readBigEndian(slice))
        } else {
            throw IllegalArgumentException("this is not array type")
        }
        return size
    }

    @OverflowWrapping
    public func unpackInt8(): Int8 {
        let flag = current ?? nextFlag()
        current = None
        if (flag <= 0x7f || flag >= 0xe0) {
            return Int8(flag)
        }
        match (flag) {
            case 0XCC =>
                let int8 = Int8(readByte()) // UINT8
                if (int8 < 0) {
                    throw overflowU8(UInt8(int8))
                }
                return int8
            case 0XCD =>
                let slice = readBytes(2) // UINT16
                let int16 = Int16.readBigEndian(slice)
                if (int16 < 0 || int16 > Int16(Int8.Max)) {
                    throw overflowU16(UInt16(int16))
                }
                return Int8(int16)
            case 0XCE =>
                let slice = readBytes(4) // UINT32
                let int32 = Int32.readBigEndian(slice)
                if (int32 < 0 || int32 > Int32(Int8.Max)) {
                    throw overflowU32(UInt32(int32))
                }
                return Int8(int32)
            case 0XCF =>
                let slice = readBytes(8) // UINT64
                let int64 = Int64.readBigEndian(slice)
                if (int64 < 0 || int64 > Int64(Int8.Max)) {
                    throw overflowU64(UInt64(int64))
                }
                return Int8(int64)
            case 0XD0 => 
                return Int8(readByte()) // Int8
            case 0XD1 =>
                let slice = readBytes(2) // INT16
                let i16 = Int16.readBigEndian(slice)
                if (i16 < Int16(Int8.Min) || i16 > Int16(Int8.Max)) {
                    throw overflowI16(i16)
                }
                return Int8(i16)
            case 0XD2 =>
                let slice = readBytes(4) // Int32
                let i32 = Int32.readBigEndian(slice)
                if (i32 < Int32(Int8.Min) || i32 > Int32(Int8.Max)) {
                    throw overflowI32(i32)
                }
                return Int8(i32)
            case 0XD3 =>
                let slice = readBytes(8) // Int64
                let i64 = Int64.readBigEndian(slice)
                if (i64 < Int64(Int8.Min) || i64 > Int64(Int8.Max)) {
                    throw overflowI64(i64)
                }
                return Int8(i64)
            case _ => throw unexpected("Integer", flag)
        }
    }

    @OverflowWrapping
    public func unpackInt16(): Int16 {
        let flag = current ?? nextFlag()
        current = None
        if (flag <= 0x7f || flag >= 0xe0) {
            return Int16(flag)
        }
        match (flag) {
            case 0xCC =>
                let int8 = Int8(readByte()) // UINT8
                return Int16(UInt8(int8))
            case 0xCD =>
                let slice = readBytes(2) // UINT16
                let int16 = Int16.readBigEndian(slice)
                if (int16 < 0) {
                    throw overflowU16(UInt16(int16))
                }
                return int16
            case 0xCE =>
                let slice = readBytes(4) // UINT32
                let int32 = Int32.readBigEndian(slice)
                if (int32 < 0 || int32 > Int32(Int16.Max)) {
                    throw overflowU32(UInt32(int32))
                }
                return Int16(int32)
            case 0xCF =>
                let slice = readBytes(8) // UINT64
                let int64 = Int64.readBigEndian(slice)
                if (int64 < 0 || int64 > Int64(Int16.Max)) {
                    throw overflowU64(UInt64(int64))
                }
                return Int16(int64)
            case 0xD0 =>
                let i8 = Int8(readByte()) // Int8
                return Int16(i8)
            case 0xD1 =>
                let slice = readBytes(2) // INT16
                let i16 = Int16.readBigEndian(slice)
                return i16
            case 0xD2 =>
                let slice = readBytes(4) // Int32
                let i32 = Int32.readBigEndian(slice)
                if (i32 < Int32(Int16.Min) || i32 > Int32(Int16.Max)) {
                    throw overflowI32(i32)
                }
                return Int16(i32)
            case 0xD3 =>
                let slice = readBytes(8) // Int64
                let i64 = Int64.readBigEndian(slice)
                if (i64 < Int64(Int16.Min) || i64 > Int64(Int16.Max)) {
                    throw overflowI64(i64)
                }
                return Int16(i64)
            case _ => throw unexpected("Integer", flag)
        }
        throw unexpected("Integer", flag)
    }

    @OverflowWrapping
    public func unpackInt32(): Int32 {
        let flag = current ?? nextFlag()
        current = None
        if (flag <= 0x7f || flag >= 0xe0) {
            return Int32(flag)
        }
        match (flag) {
            case 0xCC =>
                let int8 = Int8(readByte()) // UINT8
                return Int32(UInt8(int8))
            case 0xCD =>
                let slice = readBytes(2) // UINT16
                let int16 = Int16.readBigEndian(slice)
                return Int32(UInt16(int16))
            case 0xCE =>
                let slice = readBytes(4) // UINT32
                let int32 = Int32.readBigEndian(slice)
                if (int32 < 0) {
                    throw overflowU32(UInt32(int32))
                }
                return int32
            case 0xCF =>
                let slice = readBytes(8) // UINT64
                let int64 = Int64.readBigEndian(slice)
                if (int64 < 0 || int64 > Int64(Int32.Max)) {
                    throw overflowU64(UInt64(int64))
                }
                return Int32(int64)
            case 0xD0 =>
                let i8 = Int8(readByte()) // Int8
                return Int32(i8)
            case 0xD1 =>
                let slice = readBytes(2) // INT16
                let i16 = Int16.readBigEndian(slice)
                return Int32(i16)
            case 0xD2 =>
                let slice = readBytes(4) // Int32
                let i32 = Int32.readBigEndian(slice)
                return i32
            case 0xD3 =>
                let slice = readBytes(8) // Int64
                let i64 = Int64.readBigEndian(slice)
                if (i64 < Int64(Int32.Min) || i64 > Int64(Int32.Max)) {
                    throw overflowI64(i64)
                }
                return Int32(i64)
            case _ => throw unexpected("Integer", flag)
        }
        throw unexpected("Integer", flag)
    }

    @OverflowWrapping
    public func unpackInt64(): Int64 {
        let flag = current ?? nextFlag()
        if (flag <= 0x7f || flag >= 0xe0) {
            return Int64(flag)
        }
        match (flag) {
            case 0xCC =>
                let int8 = Int8(readByte()) // UINT8
                return Int64(UInt8(int8))
            case 0xCD =>
                let slice = readBytes(2) // UINT16
                let int16 = Int16.readBigEndian(slice)
                return Int64(UInt16(int16))
            case 0xCE =>
                let slice = readBytes(4) // UINT32
                let int32 = Int32.readBigEndian(slice)
                if (int32 < 0) {
                    return Int64(int32 & 0x7fffffff) + 0x80000000
                } else {
                    return Int64(int32)
                }
            case 0xCF =>
                let slice = readBytes(8) // UINT64
                let int64 = Int64.readBigEndian(slice)
                if (int64 < 0) {
                    throw overflowU64(UInt64(int64))
                }
                return int64
            case 0xD0 =>
                let i8 = Int8(readByte()) // Int8
                return Int64(i8)
            case 0xD1 =>
                let slice = readBytes(2) // INT16
                let i16 = Int16.readBigEndian(slice)
                return Int64(i16)
            case 0xD2 =>
                let slice = readBytes(4) // Int32
                let i32 = Int32.readBigEndian(slice)
                return Int64(i32)
            case 0xD3 =>
                let slice = readBytes(8)// Int64
                let i64 = Int64.readBigEndian(slice)
                return i64
            case _ => throw unexpected("Integer", flag)
        }
        throw unexpected("Integer", flag)
    }

    public func unpackTimestamp(): DateTime {
        let ext: ExtensionTypeHeader = unpackExtensionTypeHeader()
        return unpackTimestamp(ext)
    }

    public func unpackTimestamp(ext: ExtensionTypeHeader): DateTime {
        if (ext.getType() != EXT_TIMESTAMP) {
            throw unexpectedExtension("Timestamp", Int32(EXT_TIMESTAMP), Int32(ext.getType()))
        }
        match (ext.getLength()) {
            case 4 =>
                let slice = readBytes(4)
                let i32: Int64 = Int64(Int32.readBigEndian(slice))
                return DateTime.ofEpoch(second: i32, nanosecond: 0)
            case 8 =>
                let slice = readBytes(8)
                let i64: Int64 = Int64.readBigEndian(slice)
                let nsec = rightShift(i64, 34)
                let sec: Int64 = i64 & 0x00000003ffffffff
                return DateTime.ofEpoch(second: sec, nanosecond: nsec)
            case 12 =>
                let slice = readBytes(4)
                let i32: Int64 = Int64(Int32.readBigEndian(slice))
                let slice2 = readBytes(8)
                let i64: Int64 = Int64.readBigEndian(slice2)
                return DateTime.ofEpoch(second: i64, nanosecond: i32)
            case _ => throw MessageFormatException(
                "Timestamp extension type (${EXT_TIMESTAMP}) expects 4, 8, or 12 bytes of payload but got ${ext.getLength()} bytes"
            )
        }
        throw MessageFormatException(
            "Timestamp extension type (${EXT_TIMESTAMP}) expects 4, 8, or 12 bytes of payload but got ${ext.getLength()} bytes"
        )
    }

    /*
     * likeness >>>(无符号右移)
     */
    func rightShift(value: Int64, bits: Int64): Int64 {
        let max: Int64 = Int64.Max
        let b = max >> (bits - 1)
        return b & (value >> bits)
    }
    private static func unexpectedExtension(expected: String, expectedType: Int32, actualType: Int32): MessagePackException {
        return MessageTypeException(
            "Expected extension type ${expected} (${expectedType}), but got extension type ${actualType}")
    }

    @OverflowWrapping
    public func unpackExtensionTypeHeader(): ExtensionTypeHeader {
        let b: Byte = current ?? nextFlag()
        current = None
        match (b) {
            case 0xd4 =>
                let int8 = Int8(readByte()) // FIXEXT1
                return ExtensionTypeHeader(UInt8(int8), 1)
            case 0xd5 =>
                let int8 = Int8(readByte()) // FIXEXT2
                return ExtensionTypeHeader(UInt8(int8), 2)
            case 0xd6 =>
                let int8 = Int8(readByte()) // FIXEXT4
                return ExtensionTypeHeader(UInt8(int8), 4)
            case 0xd7 =>
                let int8 = Int8(readByte()) // FIXEXT8
                return ExtensionTypeHeader(UInt8(int8), 8)
            case 0xd8 =>
                let int8 = Int8(readByte()) // FIXEXT16
                return ExtensionTypeHeader(UInt8(int8), 16)
            case 0xc7 =>
                let slice = readBytes(2) // EXT8
                let length: Int32 = Int32(slice[0])
                let typeHeader: Byte = slice[1]
                return ExtensionTypeHeader(typeHeader, length)
            case 0xc8 =>
                let slice = readBytes(3) // EXT16
                let i16 = Int16.readBigEndian(slice[0..2])
                let length: Int32 = Int32(UInt16(i16))
                let typeHeader: Byte = slice[2]
                return ExtensionTypeHeader(typeHeader, length)
            case 0xc9 =>
                let slice = readBytes(5) // EXT32
                let i32 = Int32.readBigEndian(slice[0..4])
                if (i32 < 0) {
                    throw overflowU32Size(i32)
                }
                let length: Int32 = i32
                let typeHeader: Byte = slice[4]
                return ExtensionTypeHeader(typeHeader, length)
            case _ => throw unexpected("Ext", b)
        }
        throw unexpected("Ext", b)
    }

    public func unpackBinary(): Array<Byte> {
        let flag = current ?? nextFlag()
        current = None
        var size = 0
        if (flag == BIN8) {
            size = Int64(readByte())
        } else if (flag == BIN16) {
            let slice = readBytes(2)
            size = Int64(Int16.readBigEndian(slice))
        } else if (flag == BIN32) {
            let slice = readBytes(4)
            size = Int64(Int16.readBigEndian(slice))
        } else {
            throw IllegalArgumentException("this is not binary type")
        }
        return readBytes(size)    
    }

    protected func nextIsBinayType(): Bool {
        let flag = current ?? nextFlag()
        current = flag
        if (flag == BIN8 || flag == BIN16 || flag == BIN32) {
            return true
        }
        return false
    }

    protected func nextIsMapType(): Bool {
        let flag = current ?? nextFlag()
        current = flag
        if ((flag >= FIXMAP_MIN && flag <= FIXMAP_MAX) || flag == MAP16 || flag == MAP32) {
            return true
        }
        return false
    }

    protected func nextIsStringType(): Bool {
        let flag = current ?? nextFlag()
        current = flag
        if ((flag >= FIXSTR_MIN && flag <= FIXSTR_MAX) || flag == STR8 || flag == STR16 || flag == STR32) {
            return true
        }
        return false
    }

    protected func nextIsBoolType(): Bool {
        let flag = current ?? nextFlag()
        current = flag
        if (flag == TRUE || flag == FALSE) {
            return true
        }
        return false
    }

    protected func nextIsFloatType(): Bool {
        let flag = current ?? nextFlag()
        current = flag
        if (flag == FLOAT32 || flag == FLOAT64) {
            return true
        }
        return false
    }

    protected func nextIsArrayType(): Bool {
        let flag = current ?? nextFlag()
        current = flag
        if ((flag >= FIXARR_MIN && flag <= FIXARR_MAX) || flag == ARR16 || flag == ARR32) {
            return true
        }
        return false
    }

    protected func nextIsNullType(): Bool {
        let flag = current ?? nextFlag()
        current = flag
        if (flag == NULL) {
            return true
        }
        return false
    }

    protected func nextIsIntType(): Bool {
        let flag = current ?? nextFlag()
        current = flag
        if (flag >= POSITIVE_FIXINT_MIN && flag <= POSITIVE_FIXINT_MAX) {
            return true
        }
        if (flag >= NEGATIVE_FIXINT_MIN && flag <= NEGATIVE_FIXINT_MAX) {
            return true
        }
        if (flag == UINT8 || flag == UINT16 || flag == UINT32 || flag == UINT64) {
            return true
        }
        if (flag == INT8 || flag == INT16 || flag == INT32 || flag == INT64) {
            return true
        }
        return false
    }

    private func readByte(): Byte {
        let temp = Array<Byte>(1, repeat: 0)
        if (input.read(temp) != 1) {
            throw IllegalMemoryException()
        }
        return temp[0]
    }

    private func readBytes(n: Int): Array<Byte> {
        let temp = Array<Byte>(n, repeat: 0)
        if (input.read(temp) != n) {
            throw IllegalMemoryException()
        }
        return temp
    }

    private static func overflowU8(u8: Byte): MessageIntegerOverflowException {
        return MessageIntegerOverflowException(Int64(u8))
    }

    private static func overflowU16(u16: UInt16): MessageIntegerOverflowException {
        return MessageIntegerOverflowException(Int64(u16))
    }

    private static func overflowU32(u32: UInt32): MessageIntegerOverflowException {
        return MessageIntegerOverflowException(Int64(Int64(u32) + 0x80000000))
    }

    private static func overflowU64(u64: UInt64): MessageIntegerOverflowException {
        return MessageIntegerOverflowException(Int64(u64))
    }

    private static func overflowI16(i16: Int16): MessageIntegerOverflowException {
        return MessageIntegerOverflowException(Int64(i16))
    }

    private static func overflowI32(i32: Int32): MessageIntegerOverflowException {
        return MessageIntegerOverflowException(Int64(i32))
    }

    private static func overflowI64(i64: Int64): MessageIntegerOverflowException {
        return MessageIntegerOverflowException(i64)
    }

    private static func overflowU32Size(u32: Int32): MessageSizeException {
        let lv: Int64 = Int64(u32 & 0x7fffffff) + 0x80000000
        return MessageSizeException(lv)
    }

    public static func unexpected(expected: String, b: Byte): MessagePackException {
        return MessagePackException(expected)
    }
}
