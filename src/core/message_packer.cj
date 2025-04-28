/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

import std.io.readToEnd
import std.io.Seekable
import std.io.InputStream
import std.io.OutputStream
import std.binary.BigEndianOrder
import std.collection.ArrayList


public open class MessagePacker{

    private let output: OutputStream

    private let stringSizeLimit: Int64

    private let binarySizeLimit: Int64

    protected init(output: OutputStream, config: PackerConfig) {
        this.output = output
        this.stringSizeLimit = config.getStringSizeLimit()
        this.binarySizeLimit = config.getBinarySizeLimit()
    }

    @OverflowWrapping
    public func packInt8(value: Int8) {
        if (value < -(1 << 5)) {
            writeByteAndInt8(INT8, value)
        } else {
            writeByte(UInt8(value))
        }
        return this
    }

    @OverflowWrapping
    public func packInt16(value: Int16) {
        if (value < -(1 << 5)) {
            if (value < -(1 << 7)) {
                writeByteAndInt16(INT16, value)
            } else {
                writeByteAndInt8(INT8, Int8(value))
            }
        } else if (value < (1 << 7)) {
            writeByte(UInt8(value))
        } else {
            if (value < (1 << 8)) {
                writeByteAndUInt8(UINT8, UInt8(value))
            } else {
                writeByteAndUInt16(UINT16, UInt16(value))
            }
        }
        return this
    }

    @OverflowWrapping
    public func packInt32(value: Int32) {
        if (value < -(1 << 5)) {
            if (value < -(1 << 15)) {
                writeByteAndInt32(INT32, value)
            } else {
                if (value < -(1 << 7)) {
                    writeByteAndInt16(INT16, Int16(value))
                } else {
                    writeByteAndInt8(INT8, Int8(value))
                }
            }
        } else if (value < (1 << 7)) {
            writeByte(UInt8(value))
        } else {
            if (value < (1 << 8)) {
                writeByteAndUInt8(UINT8, UInt8(value))
            } else if (value < (1 << 16)) {
                writeByteAndUInt16(UINT16, UInt16(value))
            } else {
                writeByteAndUInt32(UINT32, UInt32(value))
            }
        }
        return this
    }

    @OverflowWrapping
    public func packInt64(value: Int64) {
        if (value < -(1 << 5)) {
            if (value < -(1 << 15)) {
                if (value < -(1 << 31)) {
                    writeByteAndInt64(INT64, value)
                } else {
                    writeByteAndInt32(INT32, Int32(value))
                }
            } else {
                if (value < -(1 << 7)) {
                    writeByteAndInt16(INT16, Int16(value))
                } else {
                    writeByteAndInt8(INT8, Int8(value))
                }
            }
        } else if (value < (1 << 7)) {
            writeByte(UInt8(value))
        } else {
            if (value < (1 << 16)) {
                if (value < (1 << 8)) {
                    writeByteAndUInt8(UINT8, UInt8(value))
                } else {
                    writeByteAndUInt16(UINT16, UInt16(value))
                }
            } else {
                if (value < (1 << 32)) {
                    writeByteAndUInt32(UINT32, UInt32(value))
                } else {
                    writeByteAndUInt64(UINT64, UInt64(value))
                }
            }
        }
        return this
    }

    public func packUInt8(value: UInt8) {
        if (value < (1 << 7)) {
            writeByte(value)
        } else {
            writeByteAndUInt8(UINT8, value)
        }
        return this
    }

    public func packUInt16(value: UInt16) {
        if (value < (1 << 7)) {
            writeByte(UInt8(value))
        } else {
            if (value < (1 << 8)) {
                writeByteAndUInt8(UINT8,UInt8(value))
            } else {
                writeByteAndUInt16(UINT16, value)
            }
        }
        return this
    }

    public func packUInt32(value: UInt32) {
        if (value < (1 << 7)) {
            writeByte(UInt8(value))
        } else {
            if (value < (1 << 16)) {
                if (value < (1 << 8)) {
                    writeByteAndUInt8(UINT8, UInt8(value))
                } else {
                    writeByteAndUInt16(UINT16, UInt16(value))
                }
            } else {
                writeByteAndUInt32(UINT32, value)
            }
        }
        return this
    }

    public func packUInt64(value: UInt64) {
        if (value < (1 << 7)) { 
            writeByte(UInt8(value))
        } else {
            if (value < (1 << 16)) {
                if (value < (1 << 8)) {
                    writeByteAndUInt8(UINT8, UInt8(value))
                } else {
                    writeByteAndUInt16(UINT16, UInt16(value))
                }
            } else {
                if (value < (1 << 32)) {
                    writeByteAndUInt32(UINT32, UInt32(value))
                } else {
                    writeByteAndUInt64(UINT64, value)
                }
            }
        }
        return this
    }

    public func packString(value: String) {
        let size = value.size
        if(size > binarySizeLimit) {
            throw MessageSizeException("cannot pack a String of size larger than ${stringSizeLimit}", size)
        }
        if (size < 1 << 5) {
            writeByte(FIXSTR_MIN + UInt8(size))
        } else if (size < (1 << 8)) {
            writeByteAndUInt8(STR8, UInt8(size))
        } else if (size < (1 << 16)) {
            writeByteAndUInt16(STR16, UInt16(size))
        } else if (size < (1 << 32)) {
            writeByteAndUInt32(STR32, UInt32(size))
        } else {
            throw MessageSizeException("cannot pack a String of size larger than ${UInt32.Max}", size)
        }
        output.write(value.toArray())
        return this
    }

    public func packBool(value: Bool) {
        match (value) {
            case true => writeByte(TRUE)
            case false => writeByte(FALSE)
        }
        return this
    }

    public func packValue(value: Value) {
        value.writeTo(this)
        return this
    }

    public func packFloat32(value: Float32) {
        writeFloat32(value)
        return this
    }

    public func packFloat64(value: Float64) {
        writeFloat64(value)
        return this
    }

    public func packNull() {
        writeByte(NULL)
        return this
    }

    public func packMapHeader(value: Int): Unit {
        if (value < 0) {
            throw MessageSizeException("Map header must be >= 0", value)
        }
        if (value < 16) {
            writeByte(FIXMAP_MIN + UInt8(value))
        } else if (value < (1 << 16)) {
            writeByteAndUInt16(MAP16, UInt16(value))
        } else if (value < (1 << 32)) {
            writeByteAndUInt32(MAP32, UInt32(value))
        } else {
           throw MessageSizeException("cannot pack a Map of size larger than ${UInt32.Max}", value)
        }
    }

    @OverflowWrapping
    public func packExtensionTypeHeader(extType: Byte, payloadLen: Int32) {
        if (payloadLen < (1 << 8)) {
            if (payloadLen > 0 && (payloadLen & (payloadLen - 1)) == 0) {
                if (payloadLen == 1) {
                    writeByteAndUInt8(FIXEXT1, extType)
                } else if (payloadLen == 2) {
                    writeByteAndUInt8(FIXEXT2, extType)
                } else if (payloadLen == 4) {
                    writeByteAndUInt8(FIXEXT4, extType)
                } else if (payloadLen == 8) {
                    writeByteAndUInt8(FIXEXT8, extType)
                } else if (payloadLen == 16) {
                    writeByteAndUInt8(FIXEXT16, extType)
                } else {
                    writeByteAndUInt8(EXT8, UInt8(payloadLen))
                    output.write(extType)
                }
            } else {
                writeByteAndUInt8(EXT8, UInt8(payloadLen))
                output.write(extType)
            }
        } else if (payloadLen < (1 << 16)) {
            output.write(EXT16)
            var sizeArray = Array<Byte>(2, repeat: 0u8)
            UInt16(payloadLen).writeBigEndian(sizeArray)
            output.write(sizeArray)
            output.write(extType)
        } else {
            output.write(EXT32)
            var sizeArray = Array<Byte>(4, repeat: 0u8)
            UInt32(payloadLen).writeBigEndian(sizeArray)
            output.write(sizeArray)
            output.write(extType)
        }
    }

    public func writePayload(src: Array<Byte>) {
        output.write(src)
    }

    public func packArrayHeader(value: Int): Unit {
        if (value < 0) {
            throw MessageSizeException("Array header must be >= 0", value)
        }
        if (value < 16) {
            writeByte(FIXARR_MIN + UInt8(value))
        } else if (value < 65536) {
            writeByteAndUInt16(ARR16, UInt16(value))
        } else if (value < 4294967296) {
            writeByteAndUInt32(ARR32, UInt32(value))
        } else {
            throw MessageSizeException("cannot pack a Array of size larger than ${UInt32.Max}", value)
        }
    }

    public func packBinary(value: Array<Byte>): Unit {
        var size = value.size
        if(size > binarySizeLimit) {
            throw MessageSizeException("cannot pack a Binary of size larger than ${binarySizeLimit}", size)
        }
        if (size < (1 << 8)) {
            writeByteAndUInt8(BIN8, UInt8(size))
        } else if (size < (1 << 16)) {
            writeByteAndUInt16(BIN16, UInt16(size))
        } else if (size < (1 << 32)) {
            writeByteAndUInt32(BIN32, UInt32(size))
        } else {
            throw MessageSizeException("cannot pack a Binary of size larger than ${UInt32.Max}", value.size)
        }
        output.write(value)
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

    private func writeByteAndInt8(byte: Byte, value: Int8): Unit {
        let temp = Array<Byte>(1, repeat: 0)
        value.writeBigEndian(temp)
        output.write(byte)
        output.write(temp)
    }

    private func writeByteAndInt16(byte: Byte, value: Int16): Unit {
        let temp = Array<Byte>(2, repeat: 0)
        value.writeBigEndian(temp)
        output.write(byte)
        output.write(temp)
    }

    private func writeByteAndInt32(byte: Byte, value: Int32): Unit {
        let temp = Array<Byte>(4, repeat: 0)
        value.writeBigEndian(temp)
        output.write(byte)
        output.write(temp)
    }

    private func writeByteAndInt64(byte: Byte, value: Int64): Unit {
        let temp = Array<Byte>(8, repeat: 0)
        value.writeBigEndian(temp)
        output.write(byte)
        output.write(temp)
    }

    private func writeByteAndUInt8(byte: Byte, value: UInt8): Unit {
        let temp = Array<Byte>(1, repeat: 0)
        value.writeBigEndian(temp)
        output.write(byte)
        output.write(temp)
    }

    private func writeByteAndUInt16(byte: Byte, value: UInt16): Unit {
        let temp = Array<Byte>(2, repeat: 0)
        value.writeBigEndian(temp)
        output.write(byte)
        output.write(temp)
    }

    private func writeByteAndUInt32(byte: Byte, value: UInt32): Unit {
        let temp = Array<Byte>(4, repeat: 0)
        value.writeBigEndian(temp)
        output.write(byte)
        output.write(temp)
    }

    private func writeByteAndUInt64(byte: Byte, value: UInt64): Unit {
        let temp = Array<Byte>(8, repeat: 0)
        value.writeBigEndian(temp)
        output.write(byte)
        output.write(temp)
    }

    private func writeFloat32(value: Float32): Unit {
        let tmp = Array<Byte>(84, repeat: 0u8)
        value.writeBigEndian(tmp)
        output.write(FLOAT32)
        output.write(tmp)
    }

    private func writeFloat64(value: Float64): Unit {
        let tmp = Array<Byte>(8, repeat: 0u8)
        value.writeBigEndian(tmp)
        output.write(FLOAT64)
        output.write(tmp)
    }

    private func writeByte(value: Byte): Unit {
        output.write(value)
    }

}