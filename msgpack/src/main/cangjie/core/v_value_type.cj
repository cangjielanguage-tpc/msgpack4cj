/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack.core



public enum ValueType {
    | NONE
    | BOOL
    | INT
    | FLOAT
    | STRING
    | BYTE
    | ARRAY
    | MAP
    | EXTENSION

    public func isNilType(): Bool {
         match(this){
            case NONE => return true
            case _ => false
         }
    }

    public func isBooleanType(): Bool{
         match(this){
            case BOOL => return true
            case _ => false
         }
    }

    public func isIntType(): Bool{
         match(this){
            case INT => return true
            case _ => false
         }
    }

    public func isFloat64Type(): Bool{
         match(this){
            case FLOAT => return true
            case _ => false
         }
    }

    public func isStringType(): Bool{
         match(this){
            case STRING => return true
            case _ => false
         }
    }

    public func isByteType(): Bool{
         match(this){
            case BYTE => return true
            case _ => false
         }
    }

    public func isArrayType(): Bool{
         match(this){
            case ARRAY => return true
            case _ => false
         }
    }

    public func isMapType(): Bool{
         match(this){
            case MAP => return true
            case _ => false
         }
    }

    public func isExtensionType(): Bool{
         match(this){
            case EXTENSION => return true
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
    | NEVER_USED
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

     public func getValueType(): ValueType {
         match (this) {
            case MessageFormat.POSFIXINT(ValueType.INT) => return ValueType.INT
            case MessageFormat.FIXMAP(ValueType.MAP) => return ValueType.MAP
            case MessageFormat.FIXARRAY(ValueType.ARRAY) => return ValueType.ARRAY

            case MessageFormat.FIXSTR(ValueType.STRING) => return ValueType.STRING
            case MessageFormat.NIL(ValueType.NONE) => return ValueType.NONE
            case MessageFormat.BOOLEAN(ValueType.BOOL) => return ValueType.BOOL
            case MessageFormat.BIN8(ValueType.BYTE) => return ValueType.BYTE
            case MessageFormat.BIN16(ValueType.BYTE) => return ValueType.BYTE
            case MessageFormat.BIN32(ValueType.BYTE) => return ValueType.BYTE

            case MessageFormat.EXT8(ValueType.EXTENSION) => return ValueType.EXTENSION
            case MessageFormat.EXT16(ValueType.EXTENSION) => return ValueType.EXTENSION
            case MessageFormat.EXT32(ValueType.EXTENSION) => return ValueType.EXTENSION

            case MessageFormat.FLOAT32(ValueType.FLOAT) => return ValueType.FLOAT
            case MessageFormat.FLOAT64(ValueType.FLOAT) => return ValueType.FLOAT

            case MessageFormat.UINT8(ValueType.INT) => return ValueType.INT
            case MessageFormat.UINT16(ValueType.INT) => return ValueType.INT
            case MessageFormat.UINT32(ValueType.INT) => return ValueType.INT
            case MessageFormat.UINT64(ValueType.INT) => return ValueType.INT

            case MessageFormat.INT8(ValueType.INT) => return ValueType.INT
            case MessageFormat.INT16(ValueType.INT) => return ValueType.INT
            case MessageFormat.INT32(ValueType.INT) => return ValueType.INT
            case MessageFormat.INT64(ValueType.INT) => return ValueType.INT

            case MessageFormat.FIXEXT1(ValueType.EXTENSION) => return ValueType.EXTENSION
            case MessageFormat.FIXEXT2(ValueType.EXTENSION) => return ValueType.EXTENSION
            case MessageFormat.FIXEXT4(ValueType.EXTENSION) => return ValueType.EXTENSION
            case MessageFormat.FIXEXT8(ValueType.EXTENSION) => return ValueType.EXTENSION
            case MessageFormat.FIXEXT16(ValueType.EXTENSION) => return ValueType.EXTENSION

            case MessageFormat.STR8(ValueType.STRING) => return ValueType.STRING
            case MessageFormat.STR16(ValueType.STRING) => return ValueType.STRING
            case MessageFormat.STR32(ValueType.STRING) => return ValueType.STRING

            case MessageFormat.ARRAY16(ValueType.ARRAY) => return ValueType.ARRAY
            case MessageFormat.ARRAY32(ValueType.ARRAY) => return ValueType.ARRAY

            case MessageFormat.MAP16(ValueType.MAP) => return ValueType.MAP
            case MessageFormat.MAP32(ValueType.MAP) => return ValueType.MAP

            case MessageFormat.NEGFIXINT(ValueType.INT) => return ValueType.INT
            case _ => ValueType.INT
         }
     } 
   
}



