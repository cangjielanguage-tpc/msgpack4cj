/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

import std.math.numeric.*
import std.io.InputStream
import std.io.ByteBuffer
import std.binary.BigEndianOrder
import std.time.DateTime

public class MessageUnpacker {
    
    private let input: InputStream

    private var current: ?Byte = None

    private var stringSizeLimit: Int64

    private var binarySizeLimit: Int64

    private var allowReadingStringAsBinary: Bool

    private var allowReadingBinaryAsString: Bool

    protected init(input: InputStream, config: UnpackerConfig) {
        this.input = input
        this.stringSizeLimit = config.getStringSizeLimit()
        this.binarySizeLimit = config.getBinarySizeLimit()
        this.allowReadingBinaryAsString = config.getAllowReadingBinaryAsString()
        this.allowReadingStringAsBinary = config.getAllowReadingStringAsBinary()
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
       throw unexpected("Bool", flag)
    }

    public func unpackNull(): Unit {
        let flag = current ?? nextFlag()
        current = None
        if (flag == NULL) {
        } else {
            throw unexpected("Null", flag)
        }
    }

    public func unpackFloat32(): Float32 {
        let flag = current ?? nextFlag()
        current = None
        if (flag == FLOAT32) {
            return readFloat32()
        }
        if (flag == FLOAT64) {
            return Float32(readFloat64())
        }
        throw unexpected("Float", flag)
    }

    public func unpackFloat64(): Float64 {
        let flag = current ?? nextFlag()
        current = None
        if (flag == FLOAT32) {
            return Float64(readFloat32())
        }
        if (flag == FLOAT64) {
            return readFloat64()
        }
        throw unexpected("Float", flag)
    }

    public func unpackString(): String {
        let len = readRawStringHeader()
        if(len > stringSizeLimit) {
            throw MessageSizeException("cannot unpack a String of size larger than ${stringSizeLimit}, ${len}", len)
        }
        return String.fromUtf8(readBytes(len))
    }

    public func unpackBinary(): Array<Byte> {
        let len = readBinaryHeader()
        if(len > binarySizeLimit) {
             throw MessageSizeException("cannot unpack a Binary of size larger than ${binarySizeLimit}, ${len}", len)
        }
        return readBytes(len)
    }

    public func unpackMapHeader(): Int {
        let flag = current ?? nextFlag()
        current = None
        var size = 0
        if (isFixMap(flag)) {
            size = Int64(flag - FIXMAP_MIN)
        } else if (flag == MAP16) {
            size = Int64(readUInt16())
        } else if (flag == MAP32) {
            size = Int64(readUInt32())
        } else {
            throw unexpected("Map", flag)
        }
        return size
    }

    public func unpackArrayHeader(): Int {
        let flag = current ?? nextFlag()
        current = None
        var size = 0
        if (isFixArr(flag)) {
            size = Int64(flag - FIXARR_MIN)
        } else if (flag == ARR16) {
            size = Int64(readUInt16())
        } else if (flag == ARR32) {
            size = Int64(readUInt32())
        } else {
            throw unexpected("Array", flag)
        }
        return size
    }

    @OverflowWrapping
    public func unpackInt8(): Int8 {
        let flag = current ?? nextFlag()
        current = None
        if (isFixInt(flag)) {
            return Int8(flag)
        }
        match (flag) {
            case 0xCC =>
                let u8 = readUInt8()
                if(u8 >= 1 << 7) {
                     throw MessageIntegerOverflowException(BigInt(u8))
                }
                return Int8(u8)  // UInt8
            case 0xCD =>
                let u16 = readUInt16() // UInt16
                if(u16 >= 1 << 7) {
                    throw MessageIntegerOverflowException(BigInt(u16))
                }
                return Int8(u16)  
            case 0xCE =>
                let u32 = readUInt32() // UInt32
                if(u32 >= 1 << 7) {
                    throw MessageIntegerOverflowException(BigInt(u32))
                }
                return Int8(u32)  
            case 0xCF => 
                let u64 = readUInt64() // UInt64
                if (u64 >= 1 << 7) {
                    throw MessageIntegerOverflowException(BigInt(u64))
                }
                return Int8(u64)
            case 0xD0 =>
                return readInt8() //Int8
            case 0xD1 =>
                let i16 = readInt16()
                if(i16 >= 1 << 7 || i16 < -(1 << 7)) {
                    throw MessageIntegerOverflowException(BigInt(i16))
                }
                return Int8(i16) //Int16
            case 0xD2 =>
                let i32 = readInt32() //Int32
                if(i32 >= 1 << 7 || i32 < -(1 << 7)) {
                    throw MessageIntegerOverflowException(BigInt(i32))
                }
                return Int8(i32) 
            case 0xD3 =>
                let i64 = readInt64() //Int64
                if(i64 >= 1 << 7 || i64 < -(1 << 7) ) {
                    throw MessageIntegerOverflowException(BigInt(i64))
                }
                return Int8(i64) 
            case _ => throw unexpected("Integer", flag)
        }
    }

     @OverflowWrapping
    public func unpackInt16(): Int16 {
        let flag = current ?? nextFlag()
        current = None
        if (isFixInt(flag)) {
            return Int16(Int8(flag))
        }
        match (flag) {
            case 0xCC =>
                return Int16(readByte())  // UInt8
            case 0xCD =>
                let u16 = readUInt16() // UInt16
                if(u16 >= 1 << 15) {
                    throw MessageIntegerOverflowException(BigInt(u16))
                }
                return Int16(u16)  
            case 0xCE =>
                let u32 = readUInt32() // UInt32
                if(u32 >= 1 << 15) {
                    throw MessageIntegerOverflowException(BigInt(u32))
                }
                return Int16(u32)  
            case 0xCF => 
                let u64 = readUInt64() // UInt64
                if (u64 >= 1 << 15) {
                    throw MessageIntegerOverflowException(BigInt(u64))
                }
                return Int16(u64)
            case 0xD0 =>
                return Int16(readInt8()) //Int8
            case 0xD1 =>
                return readInt16() //Int16
            case 0xD2 =>
                let i32 = readInt32() //Int32
                if(i32 >= 1 << 15 || i32 < -(1 << 15)) {
                    throw MessageIntegerOverflowException(BigInt(i32))
                }
                return Int16(i32) 
            case 0xD3 =>
                let i64 = readInt64() //Int64
                if(i64 >= 1 << 15 || i64 < -(1 << 15) ) {
                    throw MessageIntegerOverflowException(BigInt(i64))
                }
                return Int16(i64) 
            case _ => throw unexpected("Integer", flag)
        }
    }

    @OverflowWrapping
    public func unpackInt32(): Int32 {
        let flag = current ?? nextFlag()
        current = None
        if (isFixInt(flag)) {
            return Int32(Int8(flag))
        }
        match (flag) {
            case 0xCC =>
                return Int32(readByte())  // UInt8
            case 0xCD =>
                return Int32(readUInt16())  // UInt16
            case 0xCE =>
                let u32 = readUInt32() // UInt32
                if(u32 >= 1 << 31) {
                    throw MessageIntegerOverflowException(BigInt(u32))
                }
                return Int32(u32)  
            case 0xCF => 
                let u64 = readUInt64() // UInt64
                if (u64 >= 1 << 31) {
                    throw MessageIntegerOverflowException(BigInt(u64))
                }
                return Int32(u64)
            case 0xD0 =>
                return Int32(readInt8()) //Int8
            case 0xD1 =>
                return Int32(readInt16()) //Int16
            case 0xD2 =>
                return readInt32() //Int32
            case 0xD3 =>
                let i64 = readInt64() //Int64
                if(i64 >= 1 << 31 || i64 < -(1 << 31) ) {
                    throw MessageIntegerOverflowException(BigInt(i64))
                }
                return Int32(i64) 
            case _ => throw unexpected("Integer", flag)
        }
    }

    @OverflowWrapping
    public func unpackInt64(): Int64 {
        let flag = current ?? nextFlag()
        current = None
        if (isFixInt(flag)) {
            return Int64(Int8(flag))
        }
        match (flag) {
            case 0xCC =>
                return Int64(readByte())  // UInt8
            case 0xCD =>
                return Int64(readUInt16())  // UInt16
            case 0xCE =>
                return Int64(readUInt32())  // UInt32
            case 0xCF =>
                let u64 = readUInt64()  // UInt64
                if (u64 >= 1 << 63) {
                    throw MessageIntegerOverflowException(BigInt(u64))
                }
                return Int64(u64)
            case 0xD0 =>
                return Int64(Int8(readByte()))  //Int8
            case 0xD1 =>
                return Int64(readInt16())  //Int16
            case 0xD2 =>
                return Int64(readInt32())  //Int32
            case 0xD3 =>
                return readInt64()  //Int64
            case _ => throw unexpected("Integer", flag)
        }
    }

    @OverflowWrapping
    public func unpackUInt8(): UInt8 {
        let flag = current ?? nextFlag()
        current = None
        if (isFixInt(flag)) {
            let i8 = Int8(flag)
            if(i8 < 0) {
                throw MessageIntegerOverflowException(BigInt(i8))
            }
            return UInt8(i8)
        }
        match (flag) {
            case 0xCC =>
                return readUInt8()  // UInt8
            case 0xCD =>
                let u16 = readUInt16() // UInt16
                if(u16 >= 1 << 8) {
                     throw MessageIntegerOverflowException(BigInt(u16))
                }
                return UInt8(8)
            case 0xCE =>
                let u32 = readUInt32() // UInt32
                if(u32 >= 1 << 8) {
                    throw MessageIntegerOverflowException(BigInt(u32))
                }
                return UInt8(u32)  
            case 0xCF =>
                let u64 = readUInt64() // UInt64
                if(u64 >= 1 << 8) {
                    throw MessageIntegerOverflowException(BigInt(u64))
                }
                return UInt8(u64) 
            case 0xD0 =>
                let i8 = readInt8() //Int8
                if(i8 < 0) {
                    throw MessageIntegerOverflowException(BigInt(i8))
                }
                return UInt8(i8)  
            case 0xD1 =>
                let i16 = readInt16() //Int16
                if(i16 < 0 || i16 >= 1 << 8) {
                    throw MessageIntegerOverflowException(BigInt(i16))
                }
                return UInt8(i16)  
            case 0xD2 =>
                let i32 = readInt32() //Int32
                if(i32 < 0 || i32 >= 1 << 8) {
                    throw MessageIntegerOverflowException(BigInt(i32))
                }
                return UInt8(i32)  
            case 0xD3 =>
                let i64 = readInt64() //Int64
                if(i64 < 0 || i64 >= 1 << 8) {
                    throw MessageIntegerOverflowException(BigInt(i64))
                }
                return UInt8(i64)
            case _ => throw unexpected("Integer", flag)
        }
    }

    @OverflowWrapping
    public func unpackUInt16(): UInt16 {
        let flag = current ?? nextFlag()
        current = None
        if (isFixInt(flag)) {
            let i8 = Int8(flag)
            if(i8 < 0) {
                throw MessageIntegerOverflowException(BigInt(i8))
            }
            return UInt16(i8)
        }
        match (flag) {
            case 0xCC =>
                return UInt16(readByte())  // UInt8
            case 0xCD =>
                return readUInt16()  // UInt16
            case 0xCE =>
                let u32 = readUInt32() // UInt32
                if(u32 >= 1 << 16) {
                    throw MessageIntegerOverflowException(BigInt(u32))
                }
                return UInt16(u32)  
            case 0xCF =>
                let u64 = readUInt64() // UInt64
                if(u64 >= 1 << 16) {
                    throw MessageIntegerOverflowException(BigInt(u64))
                }
                return UInt16(u64) 
            case 0xD0 =>
                let i8 = readInt8() //Int8
                if(i8 < 0) {
                    throw MessageIntegerOverflowException(BigInt(i8))
                }
                return UInt16(i8)  
            case 0xD1 =>
                let i16 = readInt16() //Int16
                if(i16 < 0) {
                    throw MessageIntegerOverflowException(BigInt(i16))
                }
                return UInt16(i16)  
            case 0xD2 =>
                let i32 = readInt32() //Int32
                if(i32 < 0 || i32 >= 1 << 16) {
                    throw MessageIntegerOverflowException(BigInt(i32))
                }
                return UInt16(i32)  
            case 0xD3 =>
                let i64 = readInt64() //Int64
                if(i64 < 0 || i64 >= 1 << 16) {
                    throw MessageIntegerOverflowException(BigInt(i64))
                }
                return UInt16(i64)
            case _ => throw unexpected("Integer", flag)
        }
    }

    @OverflowWrapping
    public func unpackUInt32(): UInt32 {
        let flag = current ?? nextFlag()
        current = None
        if (isFixInt(flag)) {
            let i8 = Int8(flag)
            if(i8 < 0) {
                throw MessageIntegerOverflowException(BigInt(i8))
            }
            return UInt32(i8)
        }
        match (flag) {
            case 0xCC =>
                return UInt32(readByte())  // UInt8
            case 0xCD =>
                return UInt32(readUInt16())  // UInt16
            case 0xCE =>
                return readUInt32()  // UInt32
            case 0xCF =>
                let u64 = readUInt64() // UInt64
                if(u64 >= 1 << 32) {
                    throw MessageIntegerOverflowException(BigInt(u64))
                }
                return UInt32(u64) 
            case 0xD0 =>
                let i8 = readInt8() //Int8
                if(i8 < 0) {
                    throw MessageIntegerOverflowException(BigInt(i8))
                }
                return UInt32(i8)  
            case 0xD1 =>
                let i16 = readInt16() //Int16
                if(i16 < 0) {
                    throw MessageIntegerOverflowException(BigInt(i16))
                }
                return UInt32(i16)  
            case 0xD2 =>
                let i32 = readInt32() //Int32
                if(i32 < 0) {
                    throw MessageIntegerOverflowException(BigInt(i32))
                }
                return UInt32(i32)  
            case 0xD3 =>
                let i64 = readInt64() //Int64
                if(i64 < 0 || i64 >= 1 << 32) {
                    throw MessageIntegerOverflowException(BigInt(i64))
                }
                return UInt32(i64)
            case _ => throw unexpected("Integer", flag)
        }
    }

    @OverflowWrapping
    public func unpackUInt64(): UInt64 {
        let flag = current ?? nextFlag()
        current = None
        if (isFixInt(flag)) {
            let i8 = Int8(flag)
            if(i8 < 0) {
                throw MessageIntegerOverflowException(BigInt(i8))
            }
            return UInt64(i8)
        }
        match (flag) {
            case 0xCC =>
                return UInt64(readByte())  // UInt8
            case 0xCD =>
                return UInt64(readUInt16())  // UInt16
            case 0xCE =>
                return UInt64(readUInt32())  // UInt32
            case 0xCF =>
                return readUInt64() // UInt64
            case 0xD0 =>
                let i8 = readInt8() //Int8
                if(i8 < 0) {
                    throw MessageIntegerOverflowException(BigInt(i8))
                }
                return UInt64(i8)  
            case 0xD1 =>
                let i16 = readInt16() //Int16
                if(i16 < 0) {
                    throw MessageIntegerOverflowException(BigInt(i16))
                }
                return UInt64(i16)  
            case 0xD2 =>
                let i32 = readInt32()
                if(i32 < 0) {
                    throw MessageIntegerOverflowException(BigInt(i32))
                }
                return UInt64(i32)  //Int32
            case 0xD3 =>
                let i64 = readInt64() //Int64
                if(i64 < 0) {
                    throw MessageIntegerOverflowException(BigInt(i64))
                }
                return UInt64(i64)
            case _ => throw unexpected("Integer", flag)
        }
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

    private func readRawStringHeader(): Int {
        let flag = current ?? nextFlag()
        current = None
        if (isFixStr(flag)) {
            return Int64(flag - FIXSTR_MIN)
        }
        var len = tryReadStringHeader(flag)
        if (let Some(v) <- len) {
            return v
        }
        if (allowReadingBinaryAsString) {
            len = tryReadBinaryHeader(flag)
            if(let Some(v) <- len) {
                return v
            }
        }
        throw unexpected("String", flag)
    }

    private func readBinaryHeader(): Int {
        let flag = current ?? nextFlag()
        current = None
        if(let Some(v) <- tryReadBinaryHeader(flag)) {
            return v
        }
        if(allowReadingStringAsBinary) {
            if (isFixStr(flag)) {
                return Int64(flag - FIXSTR_MIN)
            }
            if(let Some(v) <- tryReadStringHeader(flag)) {
                return v
            }
        }
        throw unexpected("Binary", flag)  
    }

    private func tryReadStringHeader(flag: Byte): ?Int {
        match (flag) {
            case 0xD9 => Int64(readUInt8())
            case 0xDA => Int64(readUInt16())
            case 0xDB => Int64(readUInt32())
            case _ => None
        }
    }

    private func tryReadBinaryHeader(flag: Byte): ?Int {
        match (flag) {
            case 0xC4 => Int64(readUInt8())
            case 0xC5 => Int64(readUInt16())
            case 0xC6 => Int64(readUInt32())
            case _ => None
        }
    }


    private func readInt8(): Int8 {
        return Int8.readBigEndian(readBytes(1))
    }

    private func readInt16(): Int16 {
        return Int16.readBigEndian(readBytes(2))
    }

    private func readInt32(): Int32 {
        return Int32.readBigEndian(readBytes(4))
    }

    private func readInt64(): Int64 {
        return Int64.readBigEndian(readBytes(8))
    }

    private func readUInt8(): UInt8 {
        return UInt8.readBigEndian(readBytes(1))
    }

    private func readUInt16(): UInt16 {
        return UInt16.readBigEndian(readBytes(2))
    }

    private func readUInt32(): UInt32 {
     return UInt32.readBigEndian(readBytes(4))
    }

    private func readUInt64(): UInt64 {
        return UInt64.readBigEndian(readBytes(8))
    }

    private func readFloat32(): Float32 {
        return Float32.readBigEndian(readBytes(4))
    }

    private func readFloat64(): Float64 {
        return Float64.readBigEndian(readBytes(8))
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

    public func readPayload(n: Int): Array<Byte> {
        let temp = Array<Byte>(n, repeat: 0)
        if (input.read(temp) != n) {
            throw IllegalMemoryException()
        }
        return temp
    }

    private static func overflowU32Size(u32: Int32): MessageSizeException {
        let lv: Int64 = Int64(u32 & 0x7fffffff) + 0x80000000
        return MessageSizeException(lv)
    }

    public static func unexpected(expected: String, flag: Byte): MessagePackException {
        let message = "Expected ${expected}, but got ${flag}"
        return MessagePackException(message)
    }
}
