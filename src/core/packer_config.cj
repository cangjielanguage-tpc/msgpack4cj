/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

public class UnpackerConfig {

    public var allowReadingStringAsBinary: Bool = true

    public var allowReadingBinaryAsString: Bool = true

    public var stringSizeLimit: Int64 = Int64(Int32.Max)

    public var binarySizeLimit: Int64 = Int64(Int32.Max)

}