/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack.serialization

import msgpack.core.*


extend DataModelString {

    protected func pack(packer: MessagePacker): Unit {
        packer.packString(this.getValue())
    }

    protected static func unpack(unpacker: MessageUnpacker): DataModelString {
        return DataModelString(unpacker.unpackString())
    }

}