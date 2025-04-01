/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

import std.binary.BigEndianOrder

public class MessageUnpacker {
    
    private var content: Array<Byte>

    private var flagIdx: Int = 0

    public init(content: Array<Byte>) {
        this.content = content
    }

    public func nextFlag(): Byte {
        return content[flagIdx]
    }

    public func unpackBool(): Bool {
        let flag = nextFlag()
        if (flag == TRUE) {
            flagIdx++
            return true
        }
        if (flag == FALSE) {
            flagIdx++
            return false
        }
        throw IllegalArgumentException("this is not bool flag")
    }
    
    @OverflowWrapping
    public func unpackInt(): Int {
        let flag = nextFlag()
        if (flag >= POSITIVE_FIXINT_MIN && flag <= POSITIVE_FIXINT_MAX) {
            flagIdx++
            return Int64(flag)
        }
        if (flag >= NEGATIVE_FIXINT_MIN && flag <= NEGATIVE_FIXINT_MAX) {
            flagIdx++
            return Int64(Int8(flag))
        }
        //int8
        if (flag == INT8) {
            let uint8 = content[flagIdx + 1]
            flagIdx += 2
            return Int64(Int8(uint8))
        }
        //int16
        if (flag == INT16) {
            let slice = content.slice(flagIdx + 1, 2)
            flagIdx += 3
            return Int64(Int16.readBigEndian(slice))
        }
        //int32
        if (flag == INT32) {
            let slice = content.slice(flagIdx + 1, 4)
            flagIdx += 5
            return Int64(Int32.readBigEndian(slice))
        }
        //int64
        if (flag == INT64) {
            let slice = content.slice(flagIdx + 1, 8)
            flagIdx += 9
            return Int64.readBigEndian(slice)
        }

        //uint8
        if (flag == UINT8) {
            let uint8 = content[flagIdx + 1]
            flagIdx += 2
            return Int64(uint8)
        }
        //uint16
        if (flag == UINT16) {
            let slice = content.slice(flagIdx + 1, 2)
            flagIdx += 3
            return Int64(UInt16.readBigEndian(slice))
        }
        //uint32
        if (flag == UINT32) {
            let slice = content.slice(flagIdx + 1, 4)
            flagIdx += 5
            return Int64(UInt32.readBigEndian(slice))
        }
        //uint64
        if (flag == UINT64) {
            let slice = content.slice(flagIdx + 1, 8)
            flagIdx += 9
            return Int64(UInt64.readBigEndian(slice))
        }
        throw IllegalArgumentException("this is not int flag")
    }

    public func unpackNull(): Unit {
        if (nextFlag() == NULL) {
            flagIdx ++
        }else {
            throw IllegalArgumentException("this is not null type")
        }
    }

    public func unpackFloat64(): Float64 {
        let flag = nextFlag()
        if (flag == FLOAT32) {
            let slice = content.slice(flagIdx + 1, 4)
            flagIdx += 5
            return Float64(Float32.readBigEndian(slice))
        }
        if (flag == FLOAT64) {
            let slice = content.slice(flagIdx + 1, 8)
            flagIdx += 9
            return Float64.readBigEndian(slice)
        }
        throw IllegalArgumentException("this is not float type")
    }

    public func unpackString(): String {
        let flag = nextFlag()
        var size = 0
        //数据到类型标志的偏移量
        var offset = 0
        if (flag >= FIXSTR_MIN && flag <= FIXSTR_MAX) {
            size = Int64(flag - FIXSTR_MIN)
            offset = 1
        }else if (flag == STR8) {
            size = Int64(content[flagIdx + 1])
            offset = 2
        }else if (flag == STR16) {
            let slice = content.slice(flagIdx + 1, 2)
            size = Int64(UInt16.readBigEndian(slice))
            offset = 3
        }else if (flag == STR32) {
            let slice = content.slice(flagIdx + 1, 4)
            size = Int64(UInt16.readBigEndian(slice))
            offset = 5
        }else {
            throw IllegalArgumentException("this is not string type")
        }

        let str = String.fromUtf8(content.slice(flagIdx + offset, size))
        flagIdx += (offset + size)
        return str
    }

    public func unpackMapHeader(): Int {
        let flag = nextFlag()
        var size = 0
        var offset = 0
        if (flag >= FIXMAP_MIN && flag <= FIXMAP_MAX) {
            size = Int64(flag - FIXMAP_MIN)
            offset = 1
        } else if (flag == MAP16) {
            let slice = content.slice(flagIdx + 1, 2)
            size = Int64(UInt16.readBigEndian(slice))
            offset = 3
        } else if (flag == MAP32) {
            let slice = content.slice(flagIdx + 1, 4)
            size = Int64(UInt32.readBigEndian(slice))
            offset = 5
        } else {
            throw IllegalArgumentException("this is not map type")
        }
        flagIdx += offset
        return size
    }

    public func unpackArrayHeader(): Int {
        let flag = nextFlag()
        var size = 0
        var offset = 0
        if (flag >= FIXARR_MIN && flag <= FIXARR_MAX) {
            size = Int64(flag - FIXARR_MIN)
            offset = 1
        } else if (flag == ARR16) {
            let slice = content.slice(flagIdx + 1, 2)
            size = Int64(UInt16.readBigEndian(slice))
            offset = 3
        } else if (flag == ARR32) {
            let slice = content.slice(flagIdx + 1, 4)
            size = Int64(UInt32.readBigEndian(slice))
            offset = 5
        } else {
            throw IllegalArgumentException("this is not array type")
        }
        flagIdx += offset
        return size
    }

    public func unpackBinary(): Array<Byte> {
        let flag = nextFlag()
        var size = 0
        var offset = 0
        if (flag == BIN8) {
            size = Int64(content[flagIdx + 1])
            offset = 2
        } else if (flag == BIN16) {
            let slice = content.slice(flagIdx + 1, 2)
            size = Int64(Int16.readBigEndian(slice))
            offset = 3
        } else if (flag == BIN32) {
            let slice = content.slice(flagIdx + 1, 4)
            size = Int64(Int16.readBigEndian(slice))
            offset = 5
        } else {
            throw IllegalArgumentException("this is not binary type")
        }
        let index = flagIdx
        flagIdx += (offset + size)
        return content.slice(index + offset, size)       
    }

    protected func nextIsBinayType(): Bool {
        let flag = nextFlag()
        if (flag == BIN8 || flag == BIN16 || flag == BIN32) {
            return true
        }
        return false
    }

    protected func nextIsMapType(): Bool {
        let flag = nextFlag()
        if ((flag >= FIXMAP_MIN && flag <= FIXMAP_MAX) || flag == MAP16 || flag == MAP32) {
            return true
        }
        return false
    }

    protected func nextIsStringType(): Bool {
        let flag = nextFlag()
        if ((flag >= FIXSTR_MIN && flag <= FIXSTR_MAX) || flag == STR8 || flag == STR16 || flag == STR32) {
            return true
        }
        return false
    }

    protected func nextIsBoolType(): Bool {
        let flag = nextFlag()
        if (flag == TRUE || flag == FALSE) {
            return true
        }
        return false
    }

    protected func nextIsFloatType(): Bool {
        let flag = nextFlag()
        if (flag == FLOAT32 || flag == FLOAT64) {
            return true
        }
        return false
    }

    protected func nextIsArrayType(): Bool {
        let flag = nextFlag()
        if ((flag >= FIXARR_MIN && flag <= FIXARR_MAX) || flag == ARR16 || flag == ARR32) {
            return true
        }
        return false
    }

    protected func nextIsNullType(): Bool {
        let flag = nextFlag()
        if (flag == NULL) {
            return true
        }
        return false
    }

    protected func nextIsIntType(): Bool {
        let flag = nextFlag()
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
}
