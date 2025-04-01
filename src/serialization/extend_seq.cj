/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.serialization

import msgpack4cj.core.*
import serialization.serialization.*


extend DataModelSeq {

    protected func pack(packer: MessagePacker): Unit {
        var items = this.getItems()
        packer.packArrayHeader(items.size)
        for (item in items) {
            item.superPack(packer)
        }
    }

    protected static func unpack(unpacker: MessageUnpacker): DataModelSeq {
        var size = unpacker.unpackArrayHeader()
        var dataModelSeq = DataModelSeq()
        for(_ in 0.. size){
            dataModelSeq.add(DataModel.superUnpack(unpacker))
        }
        return dataModelSeq
    }
    
}