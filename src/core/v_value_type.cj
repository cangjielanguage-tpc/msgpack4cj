/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core



public enum ValueType {
    | NONE(Bool, Bool)
    | BOOL(Bool, Bool)
    | INT(Bool, Bool)
    | FLOAT(Bool, Bool)
    | STRING(Bool, Bool)
    | BYTE(Bool, Bool)
    | ARRAY(Bool, Bool)
    | MAP(Bool, Bool)
    | EXTENSION(Bool, Bool)

    public func isNilType(): Bool {
         match(this){
            case NONE(false, false) => return true
            case _ => false
         }
    }

    public func isBooleanType(): Bool{
         match(this){
            case BOOL(false, false) => return true
            case _ => false
         }
    }

    public func isNumberType(): Bool{
        return true
    }

    public func isRawType(): Bool{
        return true
    }

    public func isIntType(): Bool{
         match(this){
            case INT(true, false) => return true
            case _ => false
         }
    }

    public func isFloat64Type(): Bool{
         match(this){
            case FLOAT(true, false) => return true
            case _ => false
         }
    }

    public func isStringType(): Bool{
         match(this){
            case STRING(false, true) => return true
            case _ => false
         }
    }

    public func isByteType(): Bool{
         match(this){
            case BYTE(false, true) => return true
            case _ => false
         }
    }


    public func isArrayType(): Bool{
         match(this){
            case ARRAY(false, false) => return true
            case _ => false
         }
    }

    public func isMapType(): Bool{
         match(this){
            case MAP(false, false) => return true
            case _ => false
         }
    }

    public func isExtensionType(): Bool{
         match(this){
            case EXTENSION(false, false) => return true
            case _ => false
         }
    }
}

public enum MessageFormat {
    | POSFIXINT(ValueType)
    | FIXMAP(ValueType)
    | FIXARRAY(ValueType)
    | FIXSTR(ValueType)
    | NIL(ValueType)
    | NEVER_USED(ValueType)
    | BOOLEAN(ValueType)
    | BIN8(ValueType)
    | BIN16(ValueType)
    | BIN32(ValueType)
    | EXT8(ValueType)
    | EXT16(ValueType)
    | EXT32(ValueType)
    | FLOAT32(ValueType)
    | FLOAT64(ValueType)
    | UINT8(ValueType)
    | UINT16(ValueType)
    | UINT32(ValueType)
    | UINT64(ValueType)
    | INT8(ValueType)
    | INT16(ValueType)
    | INT32(ValueType)
    | INT64(ValueType)
    | FIXEXT1(ValueType)
    | FIXEXT2(ValueType)
    | FIXEXT4(ValueType)
    | FIXEXT8(ValueType)
    | FIXEXT16(ValueType)
    | STR8(ValueType)
    | STR16(ValueType)
    | STR32(ValueType)
    | ARRAY16(ValueType)
    | ARRAY32(ValueType)
    | MAP16(ValueType)
    | MAP32(ValueType)
    | NEGFIXINT(ValueType)
}
