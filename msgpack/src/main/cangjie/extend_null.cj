/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj


extend DataModelNull {

    protected func pack(packer: MessagePacker): Unit {
        packer.packNull()
    }

    protected static func unpack(unpacker: MessageUnpacker): DataModelNull {
        unpacker.unpackNull()
        return DataModelNull()
    }

}