/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.serialization

import msgpack4cj.core.*


extend DataModelStruct {
    
    protected func pack(packer: MessagePacker): Unit {
        var fields = this.getFields()
        packer.packMapHeader(fields.size)
        for (item in fields) {
            // 填充键名
            packer.packString(item.getName())
            // 填充值
            item.getData().superPack(packer)
        }
    }

    protected static func unpack(unpacker: MessageUnpacker): DataModelStruct {
        var size = unpacker.unpackMapHeader()
        var modelStruct = DataModelStruct()
        for(_ in 0..size) {
            modelStruct.add(Field(unpacker.unpackString(), DataModel.superUnpack(unpacker)))
        }
        return modelStruct       
    }
    
}