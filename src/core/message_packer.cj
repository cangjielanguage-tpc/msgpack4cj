/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

import std.io.OutputStream
import std.binary.BigEndianOrder
import std.collection.ArrayList
import std.time.*

public class MessagePacker {

    private let output: OutputStream

    public init(output: OutputStream) {
        this.output = output
    }

    public func packInt8(value: Int8): Unit {
        if (value < -(1 << 5)) {
            writeInt8(value) // -32
        } else {
            writeFixInt(Int8(value))
        }
    }

    public func packInt16(value: Int16): Unit {
        if (value < -(1 << 5)) {
            if (value < -(1 << 7)) {
                writeInt16(value)
            } else {
                writeInt8(Int8(value))
            }
        }
        else if (value < (1 << 7)) {
           writeFixInt(Int8(value))
        }
        else {
            if (value < (1 << 8)) {
                writeUInt8(UInt8(value))
            } else {
                writeUInt16(UInt16(value))
            }
        }
    }

    public func packInt32(value: Int32): Unit {
        if(value < -(1 << 5)) { // -32
            if(value < -(1 << 15)) {
                writeInt32(value)
            }else {
                if(value < -(1 << 7)) {
                    writeInt16(Int16(value))
                }else {
                    writeInt8(Int8(value))
                }
            }
        }else if (value < (1 << 7)) { //128
            writeFixInt(Int8(value))
        }else {
            if(value < (1 << 8)) {
                writeUInt8(UInt8(value))
            }else if (value < (1 << 16)) {
                writeUInt16(UInt16(value))
            } else  {
                writeUInt32(UInt32(value))
            }
        }
    }

    public func packInt64(value: Int64): Unit {
        if(value < -(1 << 5)) { // < -32 int
            if(value < -(1 << 15)) { 
                if(value < -(1 << 31)) {
                    writeInt64(value)
                }else {
                    writeInt32(Int32(value))
                }
            }else {
                if(value < -(1 << 7)) {
                    writeInt16(Int16(value))
                }else {
                    writeInt8(Int8(value))
                }
            }
        }else if (value < (1 << 7)) { // < 128 fixint
            writeFixInt(Int8(value))
        }else { //uint
            if(value < (1 << 16)) {
                if(value < (1 << 8)) {
                    writeUInt8(UInt8(value))
                }else {
                    writeUInt16(UInt16(value))
                }
            }else {
                if(value < (1 << 32)) {
                    writeUInt32(UInt32(value))
                }else {
                    writeUInt64(UInt64(value))
                }
            }
        }
    }

    public func packUInt8(value: UInt8): Unit {
        if (value < (1 << 7)) { // < 128 fixint
            writeFixInt(value)
        }else { //uint
            writeUInt8(value)
        }
    }

    public func packUInt16(value: UInt16): Unit {
        if (value < (1 << 7)) { // < 128 fixint
            writeFixInt(UInt8(value))
        }else { //uint
            if(value < (1 << 8)) {
                writeUInt8(UInt8(value))
            }else {
                writeUInt16(value)
            }
        }
    }

    public func packUInt32(value: UInt32): Unit {
        if (value < (1 << 7)) { // < 128 fixint
            writeFixInt(UInt8(value))
        }else { //uint
            if(value < (1 << 16)) {
                if(value < (1 << 8)) {
                    writeUInt8(UInt8(value))
                }else {
                    writeUInt16(UInt16(value))
                }
            }else {
                writeUInt32(value)
            }
        }
    }

    public func packUInt64(value: UInt64): Unit {
        if (value < (1 << 7)) { // < 128 fixint
           writeFixInt(UInt8(value))
        }else { //uint
            if(value < (1 << 16)) {
                if(value < (1 << 8)) {
                    writeUInt8(UInt8(value))
                }else {
                    writeUInt16(UInt16(value))
                }
            }else {
                if(value < (1 << 32)) {
                    writeUInt32(UInt32(value))
                }else {
                    writeUInt64(value)
                }
            }
        }
    }

    public func packString(value: String): Unit {
        let size = value.size
        var sizeArray: Array<Byte> = []
        var flag: Byte = 0x00
        if (size < 1 << 5) {
            flag = FIXSTR_MIN + UInt8(size)
        } else if (size < (1 << 8)) {
            flag = STR8
            sizeArray = [UInt8(size)]
        } else if (size < (1 << 16)) {
            flag = STR16
            sizeArray = Array<Byte>(2, repeat: 0u8)
            UInt16(size).writeBigEndian(sizeArray)
        } else if (size < (1 << 32)) {
            flag = STR32
            sizeArray = Array<Byte>(4, repeat: 0u8)
            UInt32(size).writeBigEndian(sizeArray)
        } else {
            throw Exception("string is too long")
        }
        output.write(flag)
        output.write(sizeArray)
        output.write(value.toArray())
    }

    public func packBool(value: Bool): Unit {
        match (value) {
            case true => output.write(TRUE)
            case false => output.write(FALSE)
        }
    }

    public func packFloat64(value: Float64): Unit {
        var tmp = Array<Byte>(8, repeat: 0u8)
        value.writeBigEndian(tmp)
        output.write(FLOAT64)
        output.write(tmp)
    }

    public func packFloat32(value: Float32): Unit {
        var tmp = Array<Byte>(4, repeat: 0u8)
        value.writeBigEndian(tmp)
        output.write(FLOAT32)
        output.write(tmp)
    }

    public func packNull(): Unit {
        return output.write(NULL)
    }

    public func packMapHeader(value: Int): Unit {
        if (value < 0) {
            throw Exception("array size must be >= 0")
        }
        var flag: Byte = 0x00
        var sizeArray: Array<Byte> = []
        if (value < 16) {
            flag = FIXMAP_MIN + UInt8(value)
        } else if (value < 65536) {
            flag = MAP16
            sizeArray = Array<Byte>(2, repeat: 0u8)
            UInt16(value).writeBigEndian(sizeArray)
        } else if (value < 4294967296) {
            flag = MAP32
            sizeArray = Array<Byte>(4, repeat: 0u8)
            UInt32(value).writeBigEndian(sizeArray)
        } else {
            throw Exception("map size is too loong")
        }
        output.write(flag)
        output.write(sizeArray)
    }

    public func packArrayHeader(value: Int): Unit {
        if (value < 0) {
            throw Exception("array size must be >= 0")
        }
        var flag: Byte = 0x00
        var sizeArray: Array<Byte> = []
        if (value < 16) {
            flag = FIXARR_MIN + UInt8(value)
        } else if (value < 65536) {
            flag = ARR16
            sizeArray = Array<Byte>(2, repeat: 0u8)
            UInt16(value).writeBigEndian(sizeArray)
        } else if (value < 4294967296) {
            flag = ARR32
            sizeArray = Array<Byte>(4, repeat: 0u8)
            UInt32(value).writeBigEndian(sizeArray)
        } else {
            throw IllegalArgumentException("array is too long")
        }
        output.write(flag)
        output.write(sizeArray)
    }

    @OverflowWrapping
    public func packTimestamp(dateTime: DateTime): Unit {
        packTimestamp(dateTime.toUnixTimeStamp().toSeconds(), dateTime.nanosecond)
    }

    @OverflowWrapping
    public func packTimestamp(sec: Int64, nsec: Int64): Unit {
        if (sec >> 34 == 0) {
            var data64: Int64 = (nsec << 34) | sec
            if ((data64 & -4294967296) == 0) {
                writeTimestamp32(Int32(sec))
            } else {
                writeTimestamp64(data64)
            }

        } else {
            writeTimestamp96(sec, Int32(nsec))
        }
    }

    private func writeTimestamp32(sec: Int32): Unit {
        output.write(FIXEXT4)
        output.write(EXT_TIMESTAMP)

        var dataArray: Array<Byte> = Array<Byte>(4, repeat: 0u8)
        UInt32(sec).writeBigEndian(dataArray)
        output.write(dataArray)
    }

    @OverflowWrapping
    private func writeTimestamp64(data64: Int64): Unit {
        output.write(FIXEXT8)
        output.write(EXT_TIMESTAMP)

        var dataArray: Array<Byte> = Array<Byte>(8, repeat: 0u8)
        UInt64(data64).writeBigEndian(dataArray)
        output.write(dataArray)
    }

    @OverflowWrapping
    private func writeTimestamp96(sec: Int64, nsec: Int32): Unit {
        output.write(EXT8)
        output.write(12)
        output.write(EXT_TIMESTAMP)

        var dataArray: Array<Byte> = Array<Byte>(4, repeat: 0u8)
        UInt32(nsec).writeBigEndian(dataArray)
        output.write(dataArray)

        var dataArrayInt64: Array<Byte> = Array<Byte>(8, repeat: 0u8)
        UInt64(sec).writeBigEndian(dataArrayInt64)
        output.write(dataArrayInt64)
    }

    public func packBinary(value: Array<Byte>): Unit {
        var flag: Byte = 0x00
        var sizeArray: Array<Byte> = []
        var size = value.size
        if(size < (1 << 8)) {
            flag = BIN8
            sizeArray = [UInt8(size)]
        }else if(size < (1 << 16)) {
            flag = BIN16
            sizeArray = Array<Byte>(2, repeat: 0)
            UInt16(size).writeBigEndian(sizeArray)
        }else if(size < (1 << 32)) {
            flag = BIN32
            sizeArray = Array<Byte>(4, repeat: 0)
            UInt16(size).writeBigEndian(sizeArray)
        }else {
            throw Exception("binary data is too loong")
        }
        output.write(flag)
        output.write(sizeArray)
        output.write(value)
    }

    @OverflowWrapping
    private func writeFixInt(value: Int8) {
        output.write(UInt8(value))
    }

    private func writeFixInt(value: UInt8) {
        output.write(value)
    }

    @OverflowWrapping
    private func writeInt8(value: Int8) {
        let temp = Array<Byte>(1, repeat: 0)
        value.writeBigEndian(temp)
        output.write(INT8)
        output.write(temp)
    }

    private func writeInt16(value: Int16) {
        let temp = Array<Byte>(2, repeat: 0)
        value.writeBigEndian(temp)
        output.write(INT16)
        output.write(temp)
    }

    private func writeInt32(value: Int32) {
        let temp = Array<Byte>(4, repeat: 0)
        value.writeBigEndian(temp)
        output.write(INT32)
        output.write(temp)
    }

    private func writeInt64(value: Int64) {
        let temp = Array<Byte>(8, repeat: 0)
        value.writeBigEndian(temp)
        output.write(INT64)
        output.write(temp)
    }

    private func writeUInt8(value: UInt8) {
        output.write(UINT8)
        output.write(value)
    }

    private func writeUInt16(value: UInt16) {
        let temp = Array<Byte>(2, repeat: 0)
        value.writeBigEndian(temp)
        output.write(UINT16)
        output.write(temp)
    }

    private func writeUInt32(value: UInt32) {
        let temp = Array<Byte>(4, repeat: 0)
        value.writeBigEndian(temp)
        output.write(UINT32)
        output.write(temp)
    }

    private func writeUInt64(value: UInt64) {
        let temp = Array<Byte>(8, repeat: 0)
        value.writeBigEndian(temp)
        output.write(UINT64)
        output.write(temp)
    }

}
