/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.serialization

import msgpack4cj.core.*
import serialization.serialization.DataModelBool


extend DataModelBool {

    protected func pack(packer: MessagePacker): Unit {
        packer.packBool(this.getValue())
    }

    protected static func unpack(unpacker: MessageUnpacker): DataModelBool {
        return DataModelBool(unpacker.unpackBool())
    }

}