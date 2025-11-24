/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj



extend DataModelInt {

    @OverflowWrapping
    protected func pack(packer: MessagePacker): Unit {
        packer.packInt64(this.getValue())
    }

    @OverflowWrapping
    protected static func unpack(unpacker: MessageUnpacker): DataModelInt {
        return DataModelInt(unpacker.unpackInt64())
    }

}