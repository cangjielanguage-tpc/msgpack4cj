/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.serialization

import serialization.serialization.DataModel

/*
* 基于messagepack协议的序列化接口
*/
public interface ToMessagePack {

    static func fromMessagePack(data: Array<Byte>): DataModel
    
    func toMessagePack(): Array<Byte>

}