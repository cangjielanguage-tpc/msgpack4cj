/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack.serialization

import msgpack.core.*


extend DataModelNull {

    protected func pack(packer: MessagePacker): Unit {
        packer.packNull()
    }

    protected static func unpack(unpacker: MessageUnpacker): DataModelNull {
        unpacker.unpackNull()
        return DataModelNull()
    }

}