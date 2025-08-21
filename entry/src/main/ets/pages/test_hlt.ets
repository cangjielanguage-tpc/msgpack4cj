import { hilog } from '@kit.PerformanceAnalysisKit';
import { pack_array, pack_array_2, pack_array_header,
  pack_extension,
  pack_map_header,
  pack_string,
  unpack_array,
  unpack_array_2,
  unpack_array_header,
  unpack_extension,
  unpack_map_header,
  unpack_string} from './pack_hlt';

@Entry
@Component
struct test_hlt {
  @State message: string = 'Hello World packer';
  @State message2: string = 'Hello World unpacker';

  build() {
    Scroll() {
    Column() {
      Button("ArrayHeader 11244 24984973 32 125 0").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message = pack_array_header()
        hilog.error(0, "", this.message)
        this.message2 = unpack_array_header()
      })

      Button("ArrayMap 11244 24984973 32 125 0").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let data = [11244, 24984973, 32, 125, 0]
        this.message = pack_map_header(data)
        hilog.error(0, "", this.message)
        let data2 = [222,43,236,223,1,125,61,141,222,0,32,222,0,125,128]
        this.message2 = unpack_map_header(data2)
      })

      Button("Array []").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message = pack_array()
        hilog.error(0, "", this.message)
        this.message2 = unpack_array()
      })

      Button("Array \"testBinary_02\".toArray()").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message = pack_array_2()
        hilog.error(0, "", this.message)
        this.message2 = unpack_array_2()
      })

      Button("拓展类型 type 12 ").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let type = 12
        let data = [150, 48, 50, 51, 45, 49, 48, 45, 48, 49, 84, 49, 10, 58, 51, 52, 58, 53, 54]
        this.message = pack_extension(type, data)
        hilog.error(0, "", this.message)
        let data2 = [199,19,12,150,48,50,51,45,49,48,45,48,49,84,49,10,58,51,52,58,53,54]
        this.message2 = unpack_extension(data2)
      })

      Button("拓展类型 type 0 ").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let type = 0
        let data = [150, 48, 50, 51, 45, 49, 48, 45, 48, 49, 84, 49, 10, 58, 51, 52, 58, 53, 54]
        this.message = pack_extension(type, data)
        hilog.error(0, "", this.message)
        let data2 = [199,19,0,150,48,50,51,45,49,48,45,48,49,84,49,10,58,51,52,58,53,54]
        this.message2 = unpack_extension(data2)
      })

      Button("拓展类型 type 0 data []").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let type = 0
        let data = []
        this.message = pack_extension(type, data)
        hilog.error(0, "", this.message)
        let data2 = [199,0,0]
        this.message2 = unpack_extension(data2)
      })

      Button("string 【{DataModel, DataModelStruct，field, Serializable}】 ").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let str = "【{DataModel, DataModelStruct，field, Serializable}】"
        this.message = pack_string(str)
        hilog.error(0, "", this.message)
        let data2 = [217,56,227,128,144,123,68,97,116,97,77,111,100,101,108,44,32,68,97,116,97,77,111,100,101,108,83,116,114,117,99,116,239,188,140,102,105,101,108,100,44,32,83,101,114,105,97,108,105,122,97,98,108,101,125,227,128,145]
        this.message2 = unpack_string(data2)
      })

      Button("string \"\"\n" +
        "    \"\" ").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let str = "\"\"\"\""
        this.message = pack_string(str)
        hilog.error(0, "", this.message)
        let data2 = [164,34,34,34,34]
        this.message2 = unpack_string(data2)
      })

      Button("string ##'\\n'##\",#\" ").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let str = "##'\\n'##\",#\""
        this.message = pack_string(str)
        hilog.error(0, "", this.message)
        let data2 = [172,35,35,39,92,110,39,35,35,34,44,35,34]
        this.message2 = unpack_string(data2)
      })

      Text(this.message)
      Text('-------------------')
      Text(this.message2)

    }}
  }
}