/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.serialization

import msgpack4cj.core.*
import serialization.serialization.*

extend DataModel <: ToMessagePack {
    
    public func toMessagePack(): Array<Byte> {
        let packer = MessagePacker()
        superPack(packer)
        return packer.toByteArray()
    }

    public static func fromMessagePack(data: Array<Byte>): DataModel {
        return superUnpack(MessageUnpacker(data))
    }

    protected func superPack(packer: MessagePacker): Unit {
        match (this) {
            case v: DataModelStruct => v.pack(packer)
            case v: DataModelString => v.pack(packer)
            case v: DataModelInt => v.pack(packer)
            case v: DataModelBool => v.pack(packer)
            case v: DataModelFloat => v.pack(packer)
            case v: DataModelSeq => v.pack(packer)
            case v: DataModelNull => v.pack(packer)
            //case v: DataModelBinary => return v.toMessage()
            case _ => throw Exception("Unsupport DataModel Type")
        }
    }

    protected static func superUnpack(unpacker: MessageUnpacker): DataModel {
        if (unpacker.nextIsMapType()) {
            return DataModelStruct.unpack(unpacker)
        }

        if (unpacker.nextIsStringType()) {
            return DataModelString.unpack(unpacker)
        }

        if (unpacker.nextIsBoolType()) {
            return DataModelBool.unpack(unpacker)
        }

        if (unpacker.nextIsFloatType()) {
            return DataModelFloat.unpack(unpacker)
        }

        if (unpacker.nextIsArrayType()) {
            return DataModelSeq.unpack(unpacker)
        }

        if (unpacker.nextIsNullType()) {
            return DataModelNull.unpack(unpacker)
        }

        if (unpacker.nextIsIntType()) {
            return DataModelInt.unpack(unpacker)
        }

        throw IllegalArgumentException("Unknow type flag")
    }
}
