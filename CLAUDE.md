本文件为 Claude Code 在此仓库中工作时提供指导。

## 项目概览

「听书(tingshu)」微服务项目,基于 Spring Cloud Alibaba 技术栈。所有中间件已在本地 Docker 中由我自行管理,**不需要 Claude 启动、停止或操作任何容器**,直接使用下方地址连接即可。

## 中间件访问地址

| 服务 | 访问地址 | 说明 |
|---|---|---|
| MySQL | `localhost:3306` | MySQL 8.0.x |
| MongoDB | `mongodb://localhost:27017` | MongoDB 4.2 |
| Redis | `localhost:6379` | Redis 7.0.x |
| Nacos | `localhost:8848`,控制台 http://localhost:8848/nacos | 注册中心 + 配置中心 |
| Seata | 服务端 `localhost:8091`,控制台 http://localhost:7091 | 分布式事务 |
| RabbitMQ | AMQP `localhost:5672`,管理台 http://localhost:15672 | 消息队列 |
| Elasticsearch | http://localhost:9200 | 全文检索 |
| Kibana | http://localhost:5601 | ES 可视化 |
| Logstash | `localhost:5044` | 日志收集 |
| MinIO | API http://localhost:9000,控制台 http://localhost:9001 | 对象存储 |
| Zipkin | http://localhost:9411 | 链路追踪 |
| YApi | http://localhost:3000 | 接口文档 / Mock |

## 技术栈约定

- 后端:Java 17 + Spring Boot + Spring Cloud Alibaba(Nacos 服务发现与配置)
- ORM:MyBatis-Plus,连接示例 `jdbc:mysql://localhost:3306/<库名>?useSSL=false&serverTimezone=Asia/Shanghai`
- 分布式事务:跨服务写操作使用 Seata `@GlobalTransactional`
- 异步解耦:RabbitMQ
- 搜索:专辑/声音检索走 Elasticsearch
- 文件:音频与封面上传至 MinIO,业务表只存对象 key/URL
- 缓存:Redis 用于热点数据缓存、分布式锁(Redisson)、登录令牌
- 链路:微服务间调用接入 Zipkin

## 开发规范

1. 不要在代码中硬编码中间件地址,统一从 Nacos 配置中心读取;本地默认均为上表地址。
2. 新增微服务时在 Nacos 中注册,本地 `application.yml` 只保留 nacos 地址等引导配置。
3. 涉及多个服务的数据一致性,优先考虑 RabbitMQ 最终一致性,强一致场景才使用 Seata。
4. 不要把数据库密码等敏感信息提交到仓库。
5. 容器的启动/停止由我自己负责,如果连接某个中间件失败,提示我检查容器状态即可,不要尝试执行 docker 命令。

## 项目结构(多模块 Maven 项目,父工程 tingshu-parent)
- model:存放实体类、查询对象、VO,基础包为 com.atguigu.tingshu.model
- service:各业务微服务,Mapper 接口和 XML 都放在 service 模块下
- service-client:Feign 远程调用接口,不放 Mapper
- common:公共工具,不放业务代码
- server-gateway:网关,不涉及数据库
## 功能实现规范(开发任意新接口可参考按此流程)
### 开发顺序
按 Controller → Service 接口 → ServiceImpl → Mapper → 自测校验 的顺序实现,
每一层写完先保证编译通过,再写下一层。

### 1. Controller 层
- 位置:service/<微服务>/src/main/java/com/atguigu/tingshu/<模块>/api/
- 类上加 @RestController、@RequestMapping("/api/<模块>"),
  注入 Service 用构造器注入或 @Autowired(与项目现有风格一致)
- 方法上加 @Operation(summary = "接口说明")(Swagger/Knife4j 注解)
- 统一返回 Result<T> 包装类,不直接返回实体
- 只做三件事:接收参数、调用 Service、返回结果;不写任何业务逻辑
- 参数校验:入参对象加 @Validated,必填字段在 VO/Query 类上用
  @NotNull/@NotBlank 等注解声明,不在 Controller 里手写 if 判空

### 2. Service 接口
- 位置:.../service/ 包下,接口名 I 不加前缀,如 BaseCategoryService
- 继承 IService<实体类>(MyBatis-Plus)
- 每个方法写 Javadoc:说明功能、参数含义、返回值

### 3. ServiceImpl 实现类
- 位置:.../service/impl/ 包下,命名为 XxxServiceImpl
- 继承 ServiceImpl<XxxMapper, Xxx> 并实现对应接口,类上加 @Service
- 业务逻辑全部写在这一层:
  - 单表简单 CRUD 优先用 MP 提供的方法(save/getById/lambdaQuery 等)
  - 多表或复杂 SQL 才下沉到 Mapper XML
  - 涉及多次写操作必须加 @Transactional(rollbackFor = Exception.class)
  - 业务异常统一 throw new GuiguException(错误码枚举),不返回 null 兜底
- 查询不到数据、状态不合法等场景要有明确的异常或空集合处理

### 4. Mapper 层
- 接口继承 BaseMapper<实体类>,加 @Mapper
- 自定义方法必须写 Javadoc,并在同名 XML 中实现
- XML 规范:
  - resultMap 命名为 实体名+Map,column/property 一一对应
  - 多表查询的列要写明别名,禁止 select *
  - 动态 SQL 用 <where>/<if>,模糊查询用 CONCAT('%', #{xx}, '%')
  - 一律使用 #{} 占位,禁止 ${}(排序字段白名单校验后除外)
- 逻辑删除字段 is_deleted 由 MP 全局配置处理,SQL 中不要手写 is_deleted = 0
  (除非是手写的多表关联查询,关联表要补上该条件)

### 5. 校验与自测(每个功能完成后必做)
1. 编译:mvn compile -pl 对应模块 -am,确保无报错
2. 启动该微服务,确认 Nacos 注册成功、无启动异常
3. 用 curl 或 Knife4j 调用接口自测,至少覆盖:
  - 正常场景:返回 200,数据结构符合 Result 规范
  - 参数缺失/非法:返回明确的校验错误信息,而不是 500
  - 数据不存在:返回业务错误码,而不是空指针
4. 检查 SQL:在控制台日志确认实际执行的 SQL 符合预期,
   无 N+1 查询,where 条件齐全
5. 自测通过后,汇报:新增/修改了哪些文件、接口路径、自测结果

## Mapper 生成规范(MyBatis-Plus)
- 实体类放在 model/src/main/java/com/atguigu/tingshu/model/entity/<业务模块>/
  例如专辑相关:com.atguigu.tingshu.model.entity.album.BaseCategory1
- 实体类规范:
    - 使用 Lombok @Data,继承项目已有的 BaseEntity(含 id、createTime、updateTime、isDeleted)
    - 类上加 @TableName("表名"),@Schema(description = "表注释")
    - 字段上加 @Schema(description = "字段注释"),不要重复生成 BaseEntity 已有的字段
- Mapper 接口放在 service/<对应微服务>/src/main/java/com/atguigu/tingshu/<模块>/mapper/
    - 继承 BaseMapper<实体类>,加 @Mapper 注解
- XML 放在对应微服务的 src/main/resources/mapper/ 下
    - namespace 与 Mapper 接口全限定名一致
    - 由于继承了 BaseMapper,XML 只需保留空骨架 + 自定义 SQL,
      不要生成 insert/selectById 等 MP 已提供的基础方法
- 字段命名:数据库 snake_case → Java camelCase
- 类型映射:tinyint(1) → Boolean,datetime → LocalDateTime,decimal → BigDecimal
- 生成前先用 SHOW FULL COLUMNS 获取字段注释,把表注释和字段注释写进 @Schema