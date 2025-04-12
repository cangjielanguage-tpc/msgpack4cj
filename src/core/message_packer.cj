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

    @OverflowWrapping
    public func packInt8(v: Int8): Unit {
        if (v < -(1 << 5)) { // -32
            pack(INT8)
            pack(UInt8(v))
        }
        else {
            pack(UInt8(v))
        }
    }

    @OverflowWrapping
    public func packInt16(v: Int16): Unit {
        var flag: Byte = 0x00
        var dataArray: Array<Byte> = []
        if (v < -(1 << 5)) {
            if (v < -(1 << 7)) {
                flag = INT16
                dataArray = Array<Byte>(2, repeat: 0u8)
                UInt16(v).writeBigEndian(dataArray)
            } else {
                flag = INT8
                dataArray = [UInt8(v)]
            }
        }
        else if (v < (1 << 7)) {
            flag = UInt8(v)
        }
        else {
            if (v < (1 << 8)) {
                flag = UINT8
                dataArray = [UInt8(v)]
            } else {
                flag = UINT16
                dataArray = Array<Byte>(2, repeat: 0u8)
                UInt16(v).writeBigEndian(dataArray)
            }
        }
        pack(flag)
        pack(dataArray)
    }

    @OverflowWrapping
    public func packInt32(v: Int32): Unit {
        var flag: Byte = 0x00
        var dataArray: Array<Byte> = []
        if(v < -(1 << 5)) { // -32
            if(v < -(1 << 15)) {
                flag = INT32
                dataArray = Array<Byte>(4, repeat: 0u8)
                UInt32(v).writeBigEndian(dataArray)
            }else {
                if(v < -(1 << 7)) {
                    flag = INT16
                    dataArray = Array<Byte>(2, repeat: 0u8)
                    UInt16(v).writeBigEndian(dataArray)
                }else {
                    flag = INT8
                    dataArray = [UInt8(v)]
                }
            }
        }else if (v < (1 << 7)) { //128
            flag = UInt8(v)
        }else {
            if(v < (1 << 8)) {
                flag = UINT8
                dataArray = [UInt8(v)]
            }else if (v < (1 << 16)) {
                flag = UINT16
                dataArray = Array<Byte>(2, repeat: 0u8)
                UInt16(v).writeBigEndian(dataArray)
            } else  {
                flag = UINT32
                dataArray = Array<Byte>(4, repeat: 0u8)
                UInt32(v).writeBigEndian(dataArray)
            }
        }
        pack(flag)
        pack(dataArray)
    }

    @OverflowWrapping
    public func packInt64(v: Int64): Unit {
        var flag: Byte = 0x00
        var dataArray: Array<Byte> = []
        if(v < -(1 << 5)) { // < -32 uint类型
            if(v < -(1 << 15)) { 
                if(v < -(1 << 31)) {
                    flag = INT64
                    dataArray = Array<Byte>(8, repeat: 0u8)
                    UInt64(v).writeBigEndian(dataArray)
                }else {
                    flag = INT32
                    dataArray = Array<Byte>(4, repeat: 0u8)
                    UInt32(v).writeBigEndian(dataArray)
                }
            }else {
                if(v < -(1 << 7)) {
                    flag = INT16
                    dataArray = Array<Byte>(2, repeat: 0u8)
                    UInt16(v).writeBigEndian(dataArray)
                }else {
                    flag = INT8
                    dataArray = [UInt8(v)]
                }
            }
        }else if (v < (1 << 7)) { // < 128 fixint
            flag = UInt8(v)
        }else { //uint
            if(v < (1 << 16)) {
                if(v < (1 << 8)) {
                    flag = UINT8
                    dataArray = [UInt8(v)]
                }else {
                    flag = UINT16
                    dataArray = Array<Byte>(2, repeat: 0u8)
                    UInt16(v).writeBigEndian(dataArray)
                }
            }else {
                if(v < (1 << 32)) {
                    flag = UINT32
                    dataArray = Array<Byte>(4, repeat: 0u8)
                    UInt32(v).writeBigEndian(dataArray)
                }else {
                    flag = UINT64
                    dataArray = Array<Byte>(8, repeat: 0u8)
                    UInt64(v).writeBigEndian(dataArray)
                }
            }
        }
        pack(flag)
        pack(dataArray)
    }

    public func packUInt8(value: UInt8): Unit {
        var flag: Byte = 0x00
        var dataArray: Array<Byte> = []
        if (value < (1 << 7)) { // < 128 fixint
            flag = value
        }else { //uint
            flag = UINT8
            dataArray = [value]
        }
        pack(flag)
        pack(dataArray)
    }

    public func packUInt16(value: UInt16): Unit {
        var flag: Byte = 0x00
        var dataArray: Array<Byte> = []
        if (value < (1 << 7)) { // < 128 fixint
            flag = UInt8(value)
        }else { //uint
            if(value < (1 << 8)) {
                flag = UINT8
                dataArray = [UInt8(value)]
            }else {
                flag = UINT16
                dataArray = Array<Byte>(2, repeat: 0u8)
                value.writeBigEndian(dataArray)
            }
        }
        pack(flag)
        pack(dataArray)
    }

    public func packUInt32(value: UInt32): Unit {
        var flag: Byte = 0x00
        var dataArray: Array<Byte> = []
        if (value < (1 << 7)) { // < 128 fixint
            flag = UInt8(value)
        }else { //uint
            if(value < (1 << 16)) {
                if(value < (1 << 8)) {
                    flag = UINT8
                    dataArray = [UInt8(value)]
                }else {
                    flag = UINT16
                    dataArray = Array<Byte>(2, repeat: 0u8)
                    UInt16(value).writeBigEndian(dataArray)
                }
            }else {
                flag = UINT32
                dataArray = Array<Byte>(4, repeat: 0u8)
                value.writeBigEndian(dataArray)
            }
        }
        pack(flag)
        pack(dataArray)
    }

    public func packUInt64(value: UInt64): Unit {
        var flag: Byte = 0x00
        var dataArray: Array<Byte> = []
        if (value < (1 << 7)) { // < 128 fixint
            flag = UInt8(value)
        }else { //uint
            if(value < (1 << 16)) {
                if(value < (1 << 8)) {
                    flag = UINT8
                    dataArray = [UInt8(value)]
                }else {
                    flag = UINT16
                    dataArray = Array<Byte>(2, repeat: 0u8)
                    UInt16(value).writeBigEndian(dataArray)
                }
            }else {
                if(value < (1 << 32)) {
                    flag = UINT32
                    dataArray = Array<Byte>(4, repeat: 0u8)
                    UInt32(value).writeBigEndian(dataArray)
                }else {
                    flag = UINT64
                    dataArray = Array<Byte>(8, repeat: 0u8)
                    value.writeBigEndian(dataArray)
                }
            }
        }
        pack(flag)
        pack(dataArray)
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
        pack(flag)
        pack(sizeArray)
        pack(value.toArray())
    }

    public func packBool(value: Bool): Unit {
        match (value) {
            case true => pack(TRUE)
            case false => pack(FALSE)
        }
    }

    public func packFloat64(value: Float64): Unit {
        var tmp = Array<Byte>(8, repeat: 0u8)
        value.writeBigEndian(tmp)
        pack(FLOAT64)
        pack(tmp)
    }

    public func packFloat32(value: Float32): Unit {
        var tmp = Array<Byte>(4, repeat: 0u8)
        value.writeBigEndian(tmp)
        pack(FLOAT32)
        pack(tmp)
    }

    public func packNull(): Unit {
        return pack(NULL)
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
        pack(flag)
        pack(sizeArray)
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
        pack(flag)
        pack(sizeArray)
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
        pack(FIXEXT4)
        pack(EXT_TIMESTAMP)

        var dataArray: Array<Byte> = Array<Byte>(4, repeat: 0u8)
        UInt32(sec).writeBigEndian(dataArray)
        pack(dataArray)
    }

    @OverflowWrapping
    private func writeTimestamp64(data64: Int64): Unit {
        pack(FIXEXT8)
        pack(EXT_TIMESTAMP)

        var dataArray: Array<Byte> = Array<Byte>(8, repeat: 0u8)
        UInt64(data64).writeBigEndian(dataArray)
        pack(dataArray)
    }

    @OverflowWrapping
    private func writeTimestamp96(sec: Int64, nsec: Int32): Unit {
        pack(EXT8)
        pack(12)
        pack(EXT_TIMESTAMP)

        var dataArray: Array<Byte> = Array<Byte>(4, repeat: 0u8)
        UInt32(nsec).writeBigEndian(dataArray)
        pack(dataArray)

        var dataArrayInt64: Array<Byte> = Array<Byte>(8, repeat: 0u8)
        UInt64(sec).writeBigEndian(dataArrayInt64)
        pack(dataArrayInt64)
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
        pack(flag)
        pack(sizeArray)
        pack(value)
    }

    private func pack(byte: Byte): Unit {
        output.write(byte)
    }

    private func pack(bytes: Array<Byte>): Unit {
        if(bytes.size == 0) {
            return 
        }
        output.write(bytes)
    }

}
