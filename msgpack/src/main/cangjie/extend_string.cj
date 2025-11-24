/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj




extend DataModelString {

    protected func pack(packer: MessagePacker): Unit {
        packer.packString(this.getValue())
    }

    protected static func unpack(unpacker: MessageUnpacker): DataModelString {
        return DataModelString(unpacker.unpackString())
    }

}