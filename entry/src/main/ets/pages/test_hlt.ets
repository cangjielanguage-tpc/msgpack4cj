import { hilog } from '@kit.PerformanceAnalysisKit';
import {
  big_pack_json,
  pack_array, pack_array_2, pack_array_header,
  pack_extension,
  pack_json,
  pack_map_header,
  pack_string,
  unpack_array,
  unpack_array_2,
  unpack_array_header,
  unpack_extension,
  unpack_json,
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

      Button("json 1").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let str = "{\n" +
          "  \"metadata\": {\n" +
          "    \"createdAt\": \"2024-01-15T10:30:00Z\",\n" +
          "    \"updatedAt\": null,\n" +
          "    \"version\": 2.1\n" +
          "  },\n" +
          "  \"settings\": {\n" +
          "    \"notifications\": true,\n" +
          "    \"theme\": \"dark\",\n" +
          "    \"language\": \"zh-CN\"\n" +
          "  }\n" +
          "}"
        this.message = pack_json(str)
        hilog.error(0, "", this.message)
        let data2 = [130,168,109,101,116,97,100,97,116,97,131,169,99,114,101,97,116,101,100,65,116,180,50,48,50,52,45,48,49,45,49,53,84,49,48,58,51,48,58,48,48,90,169,117,112,100,97,116,101,100,65,116,192,167,118,101,114,115,105,111,110,203,64,0,204,204,204,204,204,205,168,115,101,116,116,105,110,103,115,131,173,110,111,116,105,102,105,99,97,116,105,111,110,115,195,165,116,104,101,109,101,164,100,97,114,107,168,108,97,110,103,117,97,103,101,165,122,104,45,67,78]
        this.message2 = unpack_json(data2)
      })

      Button("json 2").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let str = "{\n" +
          "  \"page\": 1,\n" +
          "  \"pageSize\": 10,\n" +
          "  \"total\": 45,\n" +
          "  \"items\": [\n" +
          "    {\"id\": 1, \"title\": \"文章标题1\", \"author\": \"作者A\"},\n" +
          "    {\"id\": 2, \"title\": \"文章标题2\", \"author\": \"作者B\"}\n" +
          "  ]\n" +
          "}"
        this.message = pack_json(str)
        hilog.error(0, "", this.message)
        let data2 = [132,164,112,97,103,101,1,168,112,97,103,101,83,105,122,101,10,165,116,111,116,97,108,45,165,105,116,101,109,115,146,131,162,105,100,1,165,116,105,116,108,101,173,230,150,135,231,171,160,230,160,135,233,162,152,49,166,97,117,116,104,111,114,167,228,189,156,232,128,133,65,131,162,105,100,2,165,116,105,116,108,101,173,230,150,135,231,171,160,230,160,135,233,162,152,50,166,97,117,116,104,111,114,167,228,189,156,232,128,133,66]
        this.message2 = unpack_json(data2)
      })

      Button("json 3").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let str = "  {\n" +
          "    \"productId\": \"P002\",\n" +
          "    \"name\": \"笔记本电脑\",\n" +
          "    \"price\": 5999.00,\n" +
          "    \"inStock\": false\n" +
          "  }"
        this.message = pack_json(str)
        hilog.error(0, "", this.message)
        let data2 = [132,169,112,114,111,100,117,99,116,73,100,164,80,48,48,50,164,110,97,109,101,175,231,172,148,232,174,176,230,156,172,231,148,181,232,132,145,165,112,114,105,99,101,203,64,183,111,0,0,0,0,0,167,105,110,83,116,111,99,107,194]
        this.message2 = unpack_json(data2)
      })

      Button("json 4").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        let str = "{\n" +
          "  \"company\": {\n" +
          "    \"name\": \"星辰科技有限公司\",\n" +
          "    \"foundedYear\": 2010,\n" +
          "    \"headquarters\": {\n" +
          "      \"address\": \"北京市海淀区中关村大街1号\",\n" +
          "      \"city\": \"北京\",\n" +
          "      \"country\": \"中国\",\n" +
          "      \"postalCode\": \"100080\",\n" +
          "      \"coordinates\": {\n" +
          "        \"latitude\": 39.9042,\n" +
          "        \"longitude\": 116.4074\n" +
          "      }\n" +
          "    },\n" +
          "    \"departments\": [\n" +
          "      {\n" +
          "        \"id\": \"D001\",\n" +
          "        \"name\": \"研发部\",\n" +
          "        \"manager\": {\n" +
          "          \"employeeId\": \"E1001\",\n" +
          "          \"name\": \"张伟\",\n" +
          "          \"title\": \"技术总监\"\n" +
          "        },\n" +
          "        \"teams\": [\n" +
          "          {\n" +
          "            \"teamId\": \"T001\",\n" +
          "            \"name\": \"前端开发组\",\n" +
          "            \"members\": 15,\n" +
          "            \"technologies\": [\"ArkTS\", \"TypeScript\", \"Vue\", \"React\"]\n" +
          "          },\n" +
          "          {\n" +
          "            \"teamId\": \"T002\",\n" +
          "            \"name\": \"后端开发组\",\n" +
          "            \"members\": 20,\n" +
          "            \"technologies\": [\"Java\", \"Spring Boot\", \"Node.js\", \"Python\"]\n" +
          "          },\n" +
          "          {\n" +
          "            \"teamId\": \"T003\",\n" +
          "            \"name\": \"移动端组\",\n" +
          "            \"members\": 12,\n" +
          "            \"technologies\": [\"HarmonyOS\", \"Android\", \"iOS\", \"Flutter\"]\n" +
          "          }\n" +
          "        ]\n" +
          "      },\n" +
          "      {\n" +
          "        \"id\": \"D002\",\n" +
          "        \"name\": \"产品部\",\n" +
          "        \"manager\": {\n" +
          "          \"employeeId\": \"E1002\",\n" +
          "          \"name\": \"李娜\",\n" +
          "          \"title\": \"产品总监\"\n" +
          "        },\n" +
          "        \"teams\": [\n" +
          "          {\n" +
          "            \"teamId\": \"T004\",\n" +
          "            \"name\": \"产品设计组\",\n" +
          "            \"members\": 8,\n" +
          "            \"specialties\": [\"UX设计\", \"UI设计\", \"用户研究\"]\n" +
          "          },\n" +
          "          {\n" +
          "            \"teamId\": \"T005\",\n" +
          "            \"name\": \"产品管理组\",\n" +
          "            \"members\": 6,\n" +
          "            \"specialties\": [\"需求分析\", \"项目管理\", \"市场调研\"]\n" +
          "          }\n" +
          "        ]\n" +
          "      }\n" +
          "    ]\n" +
          "  },\n" +
          "  \"employees\": [\n" +
          "    {\n" +
          "      \"employeeId\": \"E1001\",\n" +
          "      \"personalInfo\": {\n" +
          "        \"firstName\": \"张\",\n" +
          "        \"lastName\": \"伟\",\n" +
          "        \"gender\": \"male\",\n" +
          "        \"birthDate\": \"1985-03-15\",\n" +
          "        \"email\": \"zhang.wei@xingchen.com\",\n" +
          "        \"phone\": \"+86 13800138000\",\n" +
          "        \"emergencyContact\": {\n" +
          "          \"name\": \"王芳\",\n" +
          "          \"relationship\": \"配偶\",\n" +
          "          \"phone\": \"+86 13900139000\"\n" +
          "        }\n" +
          "      },\n" +
          "      \"workInfo\": {\n" +
          "        \"department\": \"D001\",\n" +
          "        \"team\": \"T001\",\n" +
          "        \"position\": \"技术总监\",\n" +
          "        \"salary\": 45000,\n" +
          "        \"hireDate\": \"2015-06-01\",\n" +
          "        \"workSchedule\": {\n" +
          "          \"startTime\": \"09:00\",\n" +
          "          \"endTime\": \"18:00\",\n" +
          "          \"workDays\": [\"周一\", \"周二\", \"周三\", \"周四\", \"周五\"]\n" +
          "        }\n" +
          "      },\n" +
          "      \"skills\": [\"架构设计\", \"团队管理\", \"TypeScript\", \"Node.js\", \"HarmonyOS\"],\n" +
          "      \"projects\": [\n" +
          "        {\n" +
          "          \"projectId\": \"P2023001\",\n" +
          "          \"name\": \"智能办公系统\",\n" +
          "          \"role\": \"技术负责人\",\n" +
          "          \"status\": \"completed\",\n" +
          "          \"technologiesUsed\": [\"ArkTS\", \"HarmonyOS\", \"Spring Boot\", \"MySQL\"]\n" +
          "        },\n" +
          "        {\n" +
          "          \"projectId\": \"P2023002\",\n" +
          "          \"name\": \"移动支付平台\",\n" +
          "          \"role\": \"架构师\",\n" +
          "          \"status\": \"in-progress\",\n" +
          "          \"technologiesUsed\": [\"Java\", \"微服务\", \"Redis\", \"Docker\"]\n" +
          "        }\n" +
          "      ]\n" +
          "    },\n" +
          "    {\n" +
          "      \"employeeId\": \"E1002\",\n" +
          "      \"personalInfo\": {\n" +
          "        \"firstName\": \"李\",\n" +
          "        \"lastName\": \"娜\",\n" +
          "        \"gender\": \"female\",\n" +
          "        \"birthDate\": \"1988-07-22\",\n" +
          "        \"email\": \"li.na@xingchen.com\",\n" +
          "        \"phone\": \"+86 13900139222\",\n" +
          "        \"emergencyContact\": {\n" +
          "          \"name\": \"张明\",\n" +
          "          \"relationship\": \"配偶\",\n" +
          "          \"phone\": \"+86 13800138222\"\n" +
          "        }\n" +
          "      },\n" +
          "      \"workInfo\": {\n" +
          "        \"department\": \"D002\",\n" +
          "        \"team\": \"T004\",\n" +
          "        \"position\": \"产品总监\",\n" +
          "        \"salary\": 42000,\n" +
          "        \"hireDate\": \"2016-02-15\",\n" +
          "        \"workSchedule\": {\n" +
          "          \"startTime\": \"09:30\",\n" +
          "          \"endTime\": \"18:30\",\n" +
          "          \"workDays\": [\"周一\", \"周二\", \"周三\", \"周四\", \"周五\"]\n" +
          "        }\n" +
          "      },\n" +
          "      \"skills\": [\"产品规划\", \"用户研究\", \"数据分析\", \"项目管理\", \"敏捷开发\"],\n" +
          "      \"projects\": [\n" +
          "        {\n" +
          "          \"projectId\": \"P2023001\",\n" +
          "          \"name\": \"智能办公系统\",\n" +
          "          \"role\": \"产品负责人\",\n" +
          "          \"status\": \"completed\",\n" +
          "          \"metrics\": {\n" +
          "            \"userSatisfaction\": 4.8,\n" +
          "            \"adoptionRate\": 85,\n" +
          "            \"revenueImpact\": 1200000\n" +
          "          }\n" +
          "        }\n" +
          "      ]\n" +
          "    }\n" +
          "  ],\n" +
          "  \"projects\": [\n" +
          "    {\n" +
          "      \"projectId\": \"P2023001\",\n" +
          "      \"name\": \"智能办公系统\",\n" +
          "      \"description\": \"为企业提供全面的智能办公解决方案，包括考勤、审批、文档管理等模块\",\n" +
          "      \"status\": \"completed\",\n" +
          "      \"startDate\": \"2023-01-15\",\n" +
          "      \"endDate\": \"2023-09-30\",\n" +
          "      \"budget\": 2500000,\n" +
          "      \"actualCost\": 2180000,\n" +
          "      \"teamMembers\": [\n" +
          "        {\n" +
          "          \"employeeId\": \"E1001\",\n" +
          "          \"role\": \"技术负责人\",\n" +
          "          \"contribution\": \"系统架构设计和核心技术开发\"\n" +
          "        },\n" +
          "        {\n" +
          "          \"employeeId\": \"E1002\",\n" +
          "          \"role\": \"产品负责人\",\n" +
          "          \"contribution\": \"需求分析和产品设计\"\n" +
          "        }\n" +
          "      ],\n" +
          "      \"technologies\": [\"ArkTS\", \"HarmonyOS\", \"Spring Boot\", \"MySQL\", \"Redis\"],\n" +
          "      \"milestones\": [\n" +
          "        {\n" +
          "          \"name\": \"需求分析完成\",\n" +
          "          \"date\": \"2023-02-15\",\n" +
          "          \"status\": \"completed\"\n" +
          "        },\n" +
          "        {\n" +
          "          \"name\": \"原型设计完成\",\n" +
          "          \"date\": \"2023-03-10\",\n" +
          "          \"status\": \"completed\"\n" +
          "        },\n" +
          "        {\n" +
          "          \"name\": \"开发完成\",\n" +
          "          \"date\": \"2023-07-31\",\n" +
          "          \"status\": \"completed\"\n" +
          "        },\n" +
          "        {\n" +
          "          \"name\": \"测试完成\",\n" +
          "          \"date\": \"2023-08-31\",\n" +
          "          \"status\": \"completed\"\n" +
          "        },\n" +
          "        {\n" +
          "          \"name\": \"上线发布\",\n" +
          "          \"date\": \"2023-09-30\",\n" +
          "          \"status\": \"completed\"\n" +
          "        }\n" +
          "      ]\n" +
          "    },\n" +
          "    {\n" +
          "      \"projectId\": \"P2023002\",\n" +
          "      \"name\": \"移动支付平台\",\n" +
          "      \"description\": \"开发新一代安全可靠的移动支付平台，支持多种支付方式和货币\",\n" +
          "      \"status\": \"in-progress\",\n" +
          "      \"startDate\": \"2023-10-01\",\n" +
          "      \"plannedEndDate\": \"2024-06-30\",\n" +
          "      \"budget\": 3800000,\n" +
          "      \"currentProgress\": 45,\n" +
          "      \"risks\": [\n" +
          "        {\n" +
          "          \"description\": \"第三方支付接口集成复杂度\",\n" +
          "          \"severity\": \"high\",\n" +
          "          \"mitigation\": \"提前进行技术验证和接口测试\"\n" +
          "        },\n" +
          "        {\n" +
          "          \"description\": \"安全合规要求变化\",\n" +
          "          \"severity\": \"medium\",\n" +
          "          \"mitigation\": \"定期与法务部门沟通，及时调整方案\"\n" +
          "        }\n" +
          "      ]\n" +
          "    }\n" +
          "  ],\n" +
          "  \"companyMetrics\": {\n" +
          "    \"financial\": {\n" +
          "      \"revenue\": 125000000,\n" +
          "      \"expenses\": 85000000,\n" +
          "      \"profit\": 40000000,\n" +
          "      \"year\": 2023,\n" +
          "      \"quarterlyBreakdown\": [\n" +
          "        {\n" +
          "          \"quarter\": \"Q1\",\n" +
          "          \"revenue\": 28000000,\n" +
          "          \"expenses\": 20000000,\n" +
          "          \"profit\": 8000000\n" +
          "        },\n" +
          "        {\n" +
          "          \"quarter\": \"Q2\",\n" +
          "          \"revenue\": 32000000,\n" +
          "          \"expenses\": 22000000,\n" +
          "          \"profit\": 10000000\n" +
          "        },\n" +
          "        {\n" +
          "          \"quarter\": \"Q3\",\n" +
          "          \"revenue\": 35000000,\n" +
          "          \"expenses\": 23000000,\n" +
          "          \"profit\": 12000000\n" +
          "        },\n" +
          "        {\n" +
          "          \"quarter\": \"Q4\",\n" +
          "          \"revenue\": 30000000,\n" +
          "          \"expenses\": 20000000,\n" +
          "          \"profit\": 10000000\n" +
          "        }\n" +
          "      ]\n" +
          "    },\n" +
          "    \"hr\": {\n" +
          "      \"totalEmployees\": 150,\n" +
          "      \"departmentDistribution\": {\n" +
          "        \"研发部\": 75,\n" +
          "        \"产品部\": 25,\n" +
          "        \"销售部\": 30,\n" +
          "        \"行政部\": 20\n" +
          "      },\n" +
          "      \"attritionRate\": 8.5,\n" +
          "      \"hiringPlan\": {\n" +
          "        \"2024-Q1\": 15,\n" +
          "        \"2024-Q2\": 20,\n" +
          "        \"2024-Q3\": 25,\n" +
          "        \"2024-Q4\": 10\n" +
          "      }\n" +
          "    }\n" +
          "  },\n" +
          "  \"metadata\": {\n" +
          "    \"generatedAt\": \"2024-01-15T14:30:00Z\",\n" +
          "    \"version\": \"1.2.0\",\n" +
          "    \"source\": \"公司ERP系统\",\n" +
          "    \"lastUpdated\": \"2024-01-15T14:25:00Z\"\n" +
          "  }\n" +
          "}"
        let bytes = big_pack_json(str)
        this.message = bytes.toString()
        this.message2 = unpack_json(bytes)
      })

      Text(this.message)
      Text('-------------------')
      Text(this.message2)

    }}
  }
}