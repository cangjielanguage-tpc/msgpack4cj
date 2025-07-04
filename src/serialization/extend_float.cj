/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.serialization

import msgpack4cj.core.*


extend DataModelFloat {
    
    protected func pack(packer: MessagePacker): Unit {
        packer.packFloat64(this.getValue())
    }

    protected static func unpack(unpacker: MessageUnpacker): DataModelFloat {
        DataModelFloat(unpacker.unpackFloat64())
    }
    
}