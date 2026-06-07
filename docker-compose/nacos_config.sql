/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80029
 Source Host           : localhost:3306
 Source Schema         : nacos_config

 Target Server Type    : MySQL
 Target Server Version : 80029
 File Encoding         : 65001

 Date: 14/04/2025 10:56:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for config_info
-- ----------------------------
DROP TABLE IF EXISTS `config_info`;
CREATE TABLE `config_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `c_use` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `effect` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `type` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `c_schema` text CHARACTER SET utf8 COLLATE utf8_bin NULL,
  `encrypted_data_key` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '秘钥',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfo_datagrouptenant`(`data_id` ASC, `group_id` ASC, `tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 115 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'config_info' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info
-- ----------------------------
INSERT INTO `config_info` VALUES (23, 'common.yaml', 'DEFAULT_GROUP', 'mybatis-plus:\n  configuration:\n    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl\n  mapper-locations: classpath:mapper/*Mapper.xml\nfeign:\n  sentinel:\n    enabled: true\n  client:\n    config:\n      default:\n        readTimeout: 3000\n        connectTimeout: 1000\nspring:\n  main:\n    allow-bean-definition-overriding: true #当遇到同样Bean名字的时候，是否允许覆盖注册\n  cloud:\n    sentinel:\n      transport:\n        dashboard: localhost:8858\n    openfeign:\n      lazy-attributes-resolution: true #开启懒加载，否则启动报错\n      client:\n        config:\n          default:\n            connectTimeout: 30000\n            readTimeout: 30000\n            loggerLevel: basic\n  rabbitmq:\n    host: localhost\n    port: 5672\n    username: admin\n    password: admin\n    virtual-host: /tingshu  #作用隔离环境\n    publisher-confirm-type: correlated      # 开启生产者确认机制\n    publisher-returns: true                 # 开启生产者回退机制\n    listener:\n      simple:\n        acknowledge-mode: manual # 手动确认消息\n        prefetch: 10   # Rabbitmq服务端一次投递10个消息给消费者，当10个消息应答完毕以后在投递10个消息过来\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      database: 0\n      timeout: 1800000\n      # password: #如果redis有密码需要设置\n      lettuce:\n        pool:\n          max-active: 20 #最大连接数\n          max-wait: -1    #最大阻塞等待时间(负数表示没限制)\n          max-idle: 5    #最大空闲\n          min-idle: 0     #最小空闲\n    mongodb:\n      host: localhost\n      port: 27017\n      database: tingshu #指定操作的数据库\n  jackson:\n    date-format: yyyy-MM-dd HH:mm:ss\n    time-zone: GMT+8\n  servlet:\n    multipart:\n      max-file-size: 10MB     #单个文件最大限制\n      max-request-size: 20MB  #多个文件最大限制\nmanagement:\n  zipkin:\n    tracing:\n      endpoint: http://localhost:9411/api/v2/spans\n  tracing:\n    sampling:\n      probability: 1.0 # 记录速率100%', 'c8833f3c2a847719621d68ddfd236226', '2023-11-11 11:45:26', '2025-03-07 10:12:46', 'nacos', '192.168.200.1', '', '', '', '', '', 'yaml', '', '');
INSERT INTO `config_info` VALUES (24, 'server-gateway-dev.yaml', 'DEFAULT_GROUP', 'server:\n  port: 8500\nspring:\n  cloud:\n    openfeign:\n      lazy-attributes-resolution: true\n      client:\n        config:\n          default:\n            connectTimeout: 30000\n            readTimeout: 30000\n            loggerLevel: basic\n    gateway:\n      discovery:      #是否与服务发现组件进行结合，通过 serviceId(必须设置成大写) 转发到具体的服务实例。默认为false，设为true便开启通过服务中心的自动根据 serviceId 创建路由的功能。\n        locator:      #路由访问方式：http://Gateway_HOST:Gateway_PORT/大写的serviceId/**，其中微服务应用名默认大写访问。\n          enabled: true\n      routes:\n        - id: service-album\n          uri: lb://service-album\n          predicates:\n            - Path=/*/album/**\n        - id: service-user\n          uri: lb://service-user\n          predicates:\n            - Path=/*/user/**\n        - id: service-order\n          uri: lb://service-order\n          predicates:\n            - Path=/*/order/**\n        - id: service-live\n          uri: lb://service-live\n          predicates:\n            - Path=/*/live/**\n        - id: service-live-websocket\n          uri: lb:ws://service-live #ws://localhost:8507\n          predicates:\n            - Path=/websocket/**\n        - id: service-account\n          uri: lb://service-account\n          predicates:\n            - Path=/*/account/**\n        - id: service-comment\n          uri: lb://service-comment\n          predicates:\n            - Path=/*/comment/**\n        - id: service-dispatch\n          uri: lb://service-dispatch\n          predicates:\n            - Path=/*/dispatch/**\n        - id: service-payment\n          uri: lb://service-payment\n          predicates:\n            - Path=/*/payment/**\n        - id: service-system\n          uri: lb://service-system\n          predicates:\n            - Path=/*/system/**\n        - id: service-search\n          uri: lb://service-search\n          predicates:\n            - Path=/*/search/**\n        - id: service-search\n          uri: lb://service-system\n          predicates:\n            - Path=/*/system/**', 'f53ad797ed9933ef6c53440975227b4e', '2023-11-11 11:45:26', '2023-11-11 11:45:26', NULL, '192.168.200.1', '', '', NULL, NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (25, 'service-account-dev.yaml', 'DEFAULT_GROUP', 'server:\n  port: 8505\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_account?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nseata:\n  enabled: true\n  tx-service-group: ${spring.application.name}-group # 事务组名称\n  service:\n    vgroup-mapping:\n      #指定事务分组至集群映射关系，集群名default需要与seata-server注册到Nacos的cluster保持一致\n      service-account-group: default\n  registry:\n    type: nacos # 使用nacos作为注册中心\n    nacos:\n      server-addr: localhost:8848 # nacos服务地址\n      group: DEFAULT_GROUP # 默认服务分组\n      namespace: \"\" # 默认命名空间\n      cluster: default # 默认TC集群名称\n', '6f655d0a57f664f0b9c0e80657c8315c', '2023-11-11 11:45:26', '2024-08-21 14:50:45', 'nacos', '192.168.200.1', '', '', '', '', '', 'yaml', '', '');
INSERT INTO `config_info` VALUES (26, 'service-album-dev.yaml', 'DEFAULT_GROUP', 'server:\n  port: 8501\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_album?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nminio:\n  endpointUrl: http://localhost:9000\n  accessKey: admin\n  secreKey: admin123456\n  bucketName: tingshu\nvod:\n  appId: 1500036874 \n  secretId: AKIDNaYJpIeowqX0EcmiPr43oKhspZ9VeYDe\n  secretKey: GH3ZrvkJeldGdokRs54qNgmdFguugCTW\n  region: ap-beijing\n  procedure: SimpleAesEncryptPreset #任务流\n  #tempPath: /root/tingshu/tempPath\n  tempPath: D:\\code\\workspace2025\\tingshu\\temp   #临时存放上传文件\n', '72ed421dda36fe96e9bde014eeb928e5', '2023-11-11 11:45:26', '2025-04-14 10:51:26', 'nacos', '192.168.200.1', '', '', '', '', '', 'yaml', '', '');
INSERT INTO `config_info` VALUES (27, 'service-comment-dev.yaml', 'DEFAULT_GROUP', 'server:\n  port: 8508\nspring:\n  data:\n    mongodb:\n      host: localhost\n      port: 27017\n      database: tingshu #指定操作的数据库\n', '90cdaed91defef147a9dbbe05328d9ae', '2023-11-11 11:45:26', '2023-11-11 11:45:26', NULL, '192.168.200.1', '', '', NULL, NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (28, 'service-dispatch-dev.yaml', 'DEFAULT_GROUP', '# server:\n#   port: 8509', '124d4666e6fe08e91d4b8e7235b8f8f4', '2023-11-11 11:45:26', '2024-08-26 11:51:26', 'nacos', '192.168.200.1', '', '', '', '', '', 'yaml', '', '');
INSERT INTO `config_info` VALUES (29, 'service-order-dev.yaml', 'DEFAULT_GROUP', 'server:\n  port: 8504\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_order?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nseata:\n  enabled: true\n  tx-service-group: ${spring.application.name}-group # 事务组名称\n  service:\n    vgroup-mapping:\n      #指定事务分组至集群映射关系，集群名default需要与seata-server注册到Nacos的cluster保持一致\n      service-order-group: default\n  registry:\n    type: nacos # 使用nacos作为注册中心\n    nacos:\n      server-addr: localhost:8848 # nacos服务地址\n      group: DEFAULT_GROUP # 默认服务分组\n      namespace: \"\" # 默认命名空间\n      cluster: default # 默认TC集群名称\norder:\n  cancel: 900', '2dc0f49438424d8b7f2a09b701bb7760', '2023-11-11 11:45:26', '2025-03-26 14:13:57', 'nacos', '192.168.200.1', '', '', '', '', '', 'yaml', '', '');
INSERT INTO `config_info` VALUES (30, 'service-payment-dev.yaml', 'DEFAULT_GROUP', 'server:\n  port: 8506\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_payment?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nwechat:\n    v3pay:\n        #支付场景中只能使用课件提供应用ID 该应用开通微信支付商户功能\n        appid: wxcc651fcbab275e33\n        merchantId: 1631833859\n        #确保应用私钥路径正确 - 需要修改为自己的\n        privateKeyPath: D:\\\\code\\\\workspace2024\\\\apiclient_key.pem\n        merchantSerialNumber: 4AE80B52EBEAB2B96F68E02510A42801E952E889\n        apiV3key: 84dba6dd51cdaf779e55bcabae564b53\n        #支付成功回调：当前用户付款成功后，微信会主动调用商户提供地址，通知支付结果 需要修改自己的\n        notifyUrl: http://khfshu.natappfree.cc/api/payment/wxPay/notify\nseata:\n  enabled: true\n  tx-service-group: ${spring.application.name}-group # 事务组名称\n  service:\n    vgroup-mapping:\n      #指定事务分组至集群映射关系，集群名default需要与seata-server注册到Nacos的cluster保持一致\n      service-payment-group: default\n  registry:\n    type: nacos # 使用nacos作为注册中心\n    nacos:\n      server-addr: localhost:8848 # nacos服务地址\n      group: DEFAULT_GROUP # 默认服务分组\n      namespace: \"\" # 默认命名空间\n      cluster: default # 默认TC集群名称\n', '54a9c336db1d989eaa752d4bd9143a04', '2023-11-11 11:45:26', '2025-03-28 11:26:53', 'nacos', '192.168.200.1', '', '', '', '', '', 'yaml', '', '');
INSERT INTO `config_info` VALUES (31, 'service-search-dev.yaml', 'DEFAULT_GROUP', 'server:\n  port: 8502\nspring:\n  elasticsearch:\n      uris: http://localhost:9200\n      username: elastic\n      password: 111111\n', 'cf045bfd3addf1d7168ddf57cabe3101', '2023-11-11 11:45:26', '2023-11-11 11:45:26', NULL, '192.168.200.1', '', '', NULL, NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (32, 'service-user-dev.yaml', 'DEFAULT_GROUP', 'server:\n  port: 8503\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_user?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nwx:\n  miniapp:\n    appid: wxcc651fcbab275e33  # 小程序微信公众平台appId 改成同学申请测试号应用id\n    secret: 5f353399a2eae7ff6ceda383e924c5f6  # 小程序微信公众平台api秘钥 改成同学申请测试号秘钥\n    msgDataFormat: JSON\nseata:\n  enabled: true\n  tx-service-group: ${spring.application.name}-group # 事务组名称\n  service:\n    vgroup-mapping:\n      #指定事务分组至集群映射关系，集群名default需要与seata-server注册到Nacos的cluster保持一致\n      service-user-group: default\n  registry:\n    type: nacos # 使用nacos作为注册中心\n    nacos:\n      server-addr: localhost:8848 # nacos服务地址\n      group: DEFAULT_GROUP # 默认服务分组\n      namespace: \"\" # 默认命名空间\n      cluster: default # 默认TC集群名称\n', '6fc1f4a84e40b13de4dad24f952ea84d', '2023-11-11 11:45:26', '2024-08-21 14:51:15', 'nacos', '192.168.200.1', '', '', '', '', '', 'yaml', '', '');
INSERT INTO `config_info` VALUES (37, 'seata-server.properties', 'DEFAULT_GROUP', '#For details about configuration items, see https://seata.io/zh-cn/docs/user/configurations.html\n#Transport configuration, for client and server\ntransport.type=TCP\ntransport.server=NIO\ntransport.heartbeat=true\ntransport.enableTmClientBatchSendRequest=false\ntransport.enableRmClientBatchSendRequest=true\ntransport.enableTcServerBatchSendResponse=false\ntransport.rpcRmRequestTimeout=30000\ntransport.rpcTmRequestTimeout=30000\ntransport.rpcTcRequestTimeout=30000\ntransport.threadFactory.bossThreadPrefix=NettyBoss\ntransport.threadFactory.workerThreadPrefix=NettyServerNIOWorker\ntransport.threadFactory.serverExecutorThreadPrefix=NettyServerBizHandler\ntransport.threadFactory.shareBossWorker=false\ntransport.threadFactory.clientSelectorThreadPrefix=NettyClientSelector\ntransport.threadFactory.clientSelectorThreadSize=1\ntransport.threadFactory.clientWorkerThreadPrefix=NettyClientWorkerThread\ntransport.threadFactory.bossThreadSize=1\ntransport.threadFactory.workerThreadSize=default\ntransport.shutdown.wait=3\ntransport.serialization=seata\ntransport.compressor=none\n\n#Transaction routing rules configuration, only for the client\nservice.vgroupMapping.default_tx_group=default\n#If you use a registry, you can ignore it\nservice.default.grouplist=127.0.0.1:8091\nservice.enableDegrade=false\nservice.disableGlobalTransaction=false\n\n#Transaction rule configuration, only for the client\nclient.rm.asyncCommitBufferLimit=10000\nclient.rm.lock.retryInterval=10\nclient.rm.lock.retryTimes=30\nclient.rm.lock.retryPolicyBranchRollbackOnConflict=true\nclient.rm.reportRetryCount=5\nclient.rm.tableMetaCheckEnable=true\nclient.rm.tableMetaCheckerInterval=60000\nclient.rm.sqlParserType=druid\nclient.rm.reportSuccessEnable=false\nclient.rm.sagaBranchRegisterEnable=false\nclient.rm.sagaJsonParser=fastjson\nclient.rm.tccActionInterceptorOrder=-2147482648\nclient.tm.commitRetryCount=5\nclient.tm.rollbackRetryCount=5\nclient.tm.defaultGlobalTransactionTimeout=60000\nclient.tm.degradeCheck=false\nclient.tm.degradeCheckAllowTimes=10\nclient.tm.degradeCheckPeriod=2000\nclient.tm.interceptorOrder=-2147482648\nclient.undo.dataValidation=true\nclient.undo.logSerialization=jackson\nclient.undo.onlyCareUpdateColumns=true\nserver.undo.logSaveDays=7\nserver.undo.logDeletePeriod=86400000\nclient.undo.logTable=undo_log\nclient.undo.compress.enable=true\nclient.undo.compress.type=zip\nclient.undo.compress.threshold=64k\n#For TCC transaction mode\ntcc.fence.logTableName=tcc_fence_log\ntcc.fence.cleanPeriod=1h\n\n#Log rule configuration, for client and server\nlog.exceptionRate=100\n\n#Transaction storage configuration, only for the server. The file, DB, and redis configuration values are optional.\nstore.mode=db\nstore.lock.mode=db\nstore.session.mode=db\n#Used for password encryption\nstore.publicKey=\n\n#If `store.mode,store.lock.mode,store.session.mode` are not equal to `file`, you can remove the configuration block.\nstore.file.dir=file_store/data\nstore.file.maxBranchSessionSize=16384\nstore.file.maxGlobalSessionSize=512\nstore.file.fileWriteBufferCacheSize=16384\nstore.file.flushDiskMode=async\nstore.file.sessionReloadReadSize=100\n\n#These configurations are required if the `store mode` is `db`. If `store.mode,store.lock.mode,store.session.mode` are not equal to `db`, you can remove the configuration block.\nstore.db.datasource=druid\nstore.db.dbType=mysql\nstore.db.driverClassName=com.mysql.jdbc.Driver\nstore.db.url=jdbc:mysql://localhost:3306/seata?useUnicode=true&rewriteBatchedStatements=true\nstore.db.user=root\nstore.db.password=Atguigu.123\nstore.db.minConn=5\nstore.db.maxConn=30\nstore.db.globalTable=global_table\nstore.db.branchTable=branch_table\nstore.db.distributedLockTable=distributed_lock\nstore.db.queryLimit=100\nstore.db.lockTable=lock_table\nstore.db.maxWait=5000\n\n#These configurations are required if the `store mode` is `redis`. If `store.mode,store.lock.mode,store.session.mode` are not equal to `redis`, you can remove the configuration block.\nstore.redis.mode=single\nstore.redis.single.host=127.0.0.1\nstore.redis.single.port=6379\nstore.redis.sentinel.masterName=\nstore.redis.sentinel.sentinelHosts=\nstore.redis.maxConn=10\nstore.redis.minConn=1\nstore.redis.maxTotal=100\nstore.redis.database=0\nstore.redis.password=\nstore.redis.queryLimit=100\n\n#Transaction rule configuration, only for the server\nserver.recovery.committingRetryPeriod=1000\nserver.recovery.asynCommittingRetryPeriod=1000\nserver.recovery.rollbackingRetryPeriod=1000\nserver.recovery.timeoutRetryPeriod=1000\nserver.maxCommitRetryTimeout=-1\nserver.maxRollbackRetryTimeout=-1\nserver.rollbackRetryTimeoutUnlockEnable=false\nserver.distributedLockExpireTime=10000\nserver.xaerNotaRetryTimeout=60000\nserver.session.branchAsyncQueueSize=5000\nserver.session.enableBranchAsyncRemove=false\nserver.enableParallelRequestHandle=false\n\n#Metrics configuration, only for the server\nmetrics.enabled=false\nmetrics.registryType=compact\nmetrics.exporterList=prometheus\nmetrics.exporterPrometheusPort=9898', '459b34637721eb91de7a5ea126988002', '2023-11-29 11:46:39', '2023-11-29 15:11:49', 'nacos', '192.168.200.1', '', '', 'Seata外部配置-指定存储为DB，DB配置，Seata服务启动会读取该配置', '', '', 'properties', '', '');
INSERT INTO `config_info` VALUES (103, 'service-canal-dev.yaml', 'DEFAULT_GROUP', 'server:\n  port: 8601\ncanal:\n  server: localhost:11111\n  destination: tingshuTopic', '12067e2b89c29cce5fd1a2ba7077c9f5', '2025-03-21 17:00:54', '2025-04-14 10:52:04', 'nacos', '192.168.200.1', '', '', '', '', '', 'yaml', '', '');

-- ----------------------------
-- Table structure for config_info_aggr
-- ----------------------------
DROP TABLE IF EXISTS `config_info_aggr`;
CREATE TABLE `config_info_aggr`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `datum_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'datum_id',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '内容',
  `gmt_modified` datetime NOT NULL COMMENT '修改时间',
  `app_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfoaggr_datagrouptenantdatum`(`data_id` ASC, `group_id` ASC, `tenant_id` ASC, `datum_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '增加租户字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_aggr
-- ----------------------------

-- ----------------------------
-- Table structure for config_info_beta
-- ----------------------------
DROP TABLE IF EXISTS `config_info_beta`;
CREATE TABLE `config_info_beta`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `app_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'content',
  `beta_ips` varchar(1024) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'betaIps',
  `md5` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'source ip',
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '租户字段',
  `encrypted_data_key` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '秘钥',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfobeta_datagrouptenant`(`data_id` ASC, `group_id` ASC, `tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'config_info_beta' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_beta
-- ----------------------------

-- ----------------------------
-- Table structure for config_info_tag
-- ----------------------------
DROP TABLE IF EXISTS `config_info_tag`;
CREATE TABLE `config_info_tag`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT 'tenant_id',
  `tag_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'tag_id',
  `app_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'source ip',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfotag_datagrouptenanttag`(`data_id` ASC, `group_id` ASC, `tenant_id` ASC, `tag_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'config_info_tag' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_tag
-- ----------------------------

-- ----------------------------
-- Table structure for config_tags_relation
-- ----------------------------
DROP TABLE IF EXISTS `config_tags_relation`;
CREATE TABLE `config_tags_relation`  (
  `id` bigint NOT NULL COMMENT 'id',
  `tag_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'tag_name',
  `tag_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'tag_type',
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT 'tenant_id',
  `nid` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`nid`) USING BTREE,
  UNIQUE INDEX `uk_configtagrelation_configidtag`(`id` ASC, `tag_name` ASC, `tag_type` ASC) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'config_tag_relation' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_tags_relation
-- ----------------------------

-- ----------------------------
-- Table structure for group_capacity
-- ----------------------------
DROP TABLE IF EXISTS `group_capacity`;
CREATE TABLE `group_capacity`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
  `quota` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '配额，0表示使用默认值',
  `usage` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用量',
  `max_size` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '聚合子配置最大个数，，0表示使用默认值',
  `max_aggr_size` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_group_id`(`group_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '集群、各Group容量信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_capacity
-- ----------------------------

-- ----------------------------
-- Table structure for his_config_info
-- ----------------------------
DROP TABLE IF EXISTS `his_config_info`;
CREATE TABLE `his_config_info`  (
  `id` bigint UNSIGNED NOT NULL,
  `nid` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `group_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `app_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `md5` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `src_user` text CHARACTER SET utf8 COLLATE utf8_bin NULL,
  `src_ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `op_type` char(10) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '租户字段',
  `encrypted_data_key` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '秘钥',
  PRIMARY KEY (`nid`) USING BTREE,
  INDEX `idx_gmt_create`(`gmt_create` ASC) USING BTREE,
  INDEX `idx_gmt_modified`(`gmt_modified` ASC) USING BTREE,
  INDEX `idx_did`(`data_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '多租户改造' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of his_config_info
-- ----------------------------
INSERT INTO `his_config_info` VALUES (26, 109, 'service-album-dev.yaml', 'DEFAULT_GROUP', '', 'server:\n  port: 8501\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_album?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nminio:\n  endpointUrl: http://localhost:9000\n  accessKey: admin\n  secreKey: admin123456\n  bucketName: tingshu\nvod:\n  appId: 1500036874 \n  secretId: AKIDNaYJpIeowqX0EcmiPr43oKhspZ9VeYDe\n  secretKey: GH3ZrvkJeldGdokRs54qNgmdFguugCTW\n  region: ap-beijing\n  procedure: SimpleAesEncryptPreset #任务流\n  #tempPath: /root/tingshu/tempPath\n  tempPath: D:\\code\\workspace2025\\tingshu\\temp   #临时存放上传文件\n', '72ed421dda36fe96e9bde014eeb928e5', '2025-03-21 11:42:26', '2025-03-21 11:42:26', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (0, 110, 'service-canal.yaml', 'DEFAULT_GROUP', '', 'canal:\r\n  server: localhost:11111\r\n  destination: tingshuTopic\r\n', '4901aaf82b3ad86fd0348f73f61b8e01', '2025-03-21 16:18:11', '2025-03-21 16:18:12', NULL, '192.168.200.1', 'I', '', '');
INSERT INTO `his_config_info` VALUES (100, 111, 'service-canal.yaml', 'DEFAULT_GROUP', '', 'canal:\r\n  server: localhost:11111\r\n  destination: tingshuTopic\r\n', '4901aaf82b3ad86fd0348f73f61b8e01', '2025-03-21 16:20:07', '2025-03-21 16:20:08', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (100, 112, 'service-canal.yaml', 'DEFAULT_GROUP', '', 'canal:\n  server: localhost:11112\n  destination: tingshuTopic\n', '4faed7f87aaa3d2196157fbad58bbb15', '2025-03-21 16:20:44', '2025-03-21 16:20:45', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (0, 113, 'service-canal-dev.yaml', 'DEFAULT_GROUP', '', 'server:\r\n  port: 8601\r\ncanal:\r\n  server: localhost:11112\r\n  destination: tingshuTopic', 'd00c5504c437b9a5fbac84d7483a4af3', '2025-03-21 17:00:54', '2025-03-21 17:00:54', NULL, '192.168.200.1', 'I', '', '');
INSERT INTO `his_config_info` VALUES (100, 114, 'service-canal.yaml', 'DEFAULT_GROUP', '', 'server:\n  port: 8601\ncanal:\n  server: localhost:11112\n  destination: tingshuTopic\n', 'ed91198e894c7f512cad84c65ed88e39', '2025-03-21 17:01:02', '2025-03-21 17:01:03', NULL, '192.168.200.1', 'D', '', '');
INSERT INTO `his_config_info` VALUES (103, 115, 'service-canal-dev.yaml', 'DEFAULT_GROUP', '', 'server:\r\n  port: 8601\r\ncanal:\r\n  server: localhost:11112\r\n  destination: tingshuTopic', 'd00c5504c437b9a5fbac84d7483a4af3', '2025-03-21 17:03:22', '2025-03-21 17:03:23', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (103, 116, 'service-canal-dev.yaml', 'DEFAULT_GROUP', '', 'server:\n  port: 8601\ncanal:\n  server: localhost:11112\n  destination: tingshuTopic', '06bec66415aebd0e42893c992a0d193b', '2025-03-21 17:27:34', '2025-03-21 17:27:35', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (29, 117, 'service-order-dev.yaml', 'DEFAULT_GROUP', '', 'server:\n  port: 8504\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_order?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nseata:\n  enabled: true\n  tx-service-group: ${spring.application.name}-group # 事务组名称\n  service:\n    vgroup-mapping:\n      #指定事务分组至集群映射关系，集群名default需要与seata-server注册到Nacos的cluster保持一致\n      service-order-group: default\n  registry:\n    type: nacos # 使用nacos作为注册中心\n    nacos:\n      server-addr: localhost:8848 # nacos服务地址\n      group: DEFAULT_GROUP # 默认服务分组\n      namespace: \"\" # 默认命名空间\n      cluster: default # 默认TC集群名称\norder:\n  cancel: 3600', 'fe1356332ef994815e36e4d49b2c88ca', '2025-03-26 10:51:50', '2025-03-26 10:51:50', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (29, 118, 'service-order-dev.yaml', 'DEFAULT_GROUP', '', 'server:\n  port: 8504\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_order?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nseata:\n  enabled: true\n  tx-service-group: ${spring.application.name}-group # 事务组名称\n  service:\n    vgroup-mapping:\n      #指定事务分组至集群映射关系，集群名default需要与seata-server注册到Nacos的cluster保持一致\n      service-order-group: default\n  registry:\n    type: nacos # 使用nacos作为注册中心\n    nacos:\n      server-addr: localhost:8848 # nacos服务地址\n      group: DEFAULT_GROUP # 默认服务分组\n      namespace: \"\" # 默认命名空间\n      cluster: default # 默认TC集群名称\norder:\n  cancel: 20', '08523c4dddce9cff0093fb3b3d6f772a', '2025-03-26 14:13:57', '2025-03-26 14:13:57', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (30, 119, 'service-payment-dev.yaml', 'DEFAULT_GROUP', '', 'server:\n  port: 8506\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_payment?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nwechat:\n    v3pay:\n        #支付场景中只能使用课件提供应用ID 该应用开通微信支付商户功能\n        appid: wxcc651fcbab275e33\n        merchantId: 1631833859\n        #确保应用私钥路径正确 - 需要修改为自己的\n        privateKeyPath: D:\\\\code\\\\workspace2024\\\\apiclient_key.pem\n        merchantSerialNumber: 4AE80B52EBEAB2B96F68E02510A42801E952E889\n        apiV3key: 84dba6dd51cdaf779e55bcabae564b53\n        #支付成功回调：当前用户付款成功后，微信会主动调用商户提供地址，通知支付结果 需要修改自己的\n        notifyUrl: http://2w2fp9.natappfree.cc/api/payment/wxPay/notify\nseata:\n  enabled: true\n  tx-service-group: ${spring.application.name}-group # 事务组名称\n  service:\n    vgroup-mapping:\n      #指定事务分组至集群映射关系，集群名default需要与seata-server注册到Nacos的cluster保持一致\n      service-payment-group: default\n  registry:\n    type: nacos # 使用nacos作为注册中心\n    nacos:\n      server-addr: localhost:8848 # nacos服务地址\n      group: DEFAULT_GROUP # 默认服务分组\n      namespace: \"\" # 默认命名空间\n      cluster: default # 默认TC集群名称\n', '4fa0064f3ffebc6f4abad6b041ef6d34', '2025-03-26 14:35:43', '2025-03-26 14:35:44', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (30, 120, 'service-payment-dev.yaml', 'DEFAULT_GROUP', '', 'server:\n  port: 8506\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_payment?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nwechat:\n    v3pay:\n        #支付场景中只能使用课件提供应用ID 该应用开通微信支付商户功能\n        appid: wxcc651fcbab275e33\n        merchantId: 1631833859\n        #确保应用私钥路径正确 - 需要修改为自己的\n        privateKeyPath: D:\\\\code\\\\workspace2024\\\\apiclient_key.pem\n        merchantSerialNumber: 4AE80B52EBEAB2B96F68E02510A42801E952E889\n        apiV3key: 84dba6dd51cdaf779e55bcabae564b53\n        #支付成功回调：当前用户付款成功后，微信会主动调用商户提供地址，通知支付结果 需要修改自己的\n        notifyUrl: http://5mxpst.natappfree.cc/api/payment/wxPay/notify\nseata:\n  enabled: true\n  tx-service-group: ${spring.application.name}-group # 事务组名称\n  service:\n    vgroup-mapping:\n      #指定事务分组至集群映射关系，集群名default需要与seata-server注册到Nacos的cluster保持一致\n      service-payment-group: default\n  registry:\n    type: nacos # 使用nacos作为注册中心\n    nacos:\n      server-addr: localhost:8848 # nacos服务地址\n      group: DEFAULT_GROUP # 默认服务分组\n      namespace: \"\" # 默认命名空间\n      cluster: default # 默认TC集群名称\n', 'cc29ed213c08caa8ded4cec2893b7d05', '2025-03-28 08:55:49', '2025-03-28 08:55:50', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (30, 121, 'service-payment-dev.yaml', 'DEFAULT_GROUP', '', 'server:\n  port: 8506\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_payment?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nwechat:\n    v3pay:\n        #支付场景中只能使用课件提供应用ID 该应用开通微信支付商户功能\n        appid: wxcc651fcbab275e33\n        merchantId: 1631833859\n        #确保应用私钥路径正确 - 需要修改为自己的\n        privateKeyPath: D:\\\\code\\\\workspace2024\\\\apiclient_key.pem\n        merchantSerialNumber: 4AE80B52EBEAB2B96F68E02510A42801E952E889\n        apiV3key: 84dba6dd51cdaf779e55bcabae564b53\n        #支付成功回调：当前用户付款成功后，微信会主动调用商户提供地址，通知支付结果 需要修改自己的\n        notifyUrl: http://khfshu.natappfree.cc/api/payment/wxPay/notify\nseata:\n  enabled: true\n  tx-service-group: ${spring.application.name}-group # 事务组名称\n  service:\n    vgroup-mapping:\n      #指定事务分组至集群映射关系，集群名default需要与seata-server注册到Nacos的cluster保持一致\n      service-payment-group: default\n  registry:\n    type: nacos # 使用nacos作为注册中心\n    nacos:\n      server-addr: localhost:8848 # nacos服务地址\n      group: DEFAULT_GROUP # 默认服务分组\n      namespace: \"\" # 默认命名空间\n      cluster: default # 默认TC集群名称\n', '54a9c336db1d989eaa752d4bd9143a04', '2025-03-28 11:26:52', '2025-03-28 11:26:53', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (0, 122, 'service-flow-dev.yaml', 'DEFAULT_GROUP', '', 'server:\r\n  port: 8510\r\nspring:\r\n  datasource:\r\n    type: com.zaxxer.hikari.HikariDataSource\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    url: jdbc:mysql://localhost:3306/flowlong?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\r\n    username: root\r\n    password: Atguigu.123\r\n    hikari:\r\n      connection-test-query: SELECT 1\r\n      connection-timeout: 60000\r\n      idle-timeout: 500000\r\n      max-lifetime: 540000\r\n      maximum-pool-size: 10\r\n      minimum-idle: 5\r\n      pool-name: GuliHikariPool\r\n', 'f05376d8cad7e9e715d33817eaba3d53', '2025-03-28 16:59:46', '2025-03-28 16:59:47', NULL, '192.168.200.1', 'I', '', '');
INSERT INTO `his_config_info` VALUES (26, 123, 'service-album-dev.yaml', 'DEFAULT_GROUP', '', '# server:\n#   port: 8501\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_album?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nminio:\n  endpointUrl: http://localhost:9000\n  accessKey: admin\n  secreKey: admin123456\n  bucketName: tingshu\nvod:\n  appId: 1500036874 \n  secretId: AKIDNaYJpIeowqX0EcmiPr43oKhspZ9VeYDe\n  secretKey: GH3ZrvkJeldGdokRs54qNgmdFguugCTW\n  region: ap-beijing\n  procedure: SimpleAesEncryptPreset #任务流\n  #tempPath: /root/tingshu/tempPath\n  tempPath: D:\\code\\workspace2025\\tingshu\\temp   #临时存放上传文件\n', 'e14a360b6a9ea6309a172079424951d6', '2025-03-28 17:00:03', '2025-03-28 17:00:04', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (26, 124, 'service-album-dev.yaml', 'DEFAULT_GROUP', '', '# server:\n#   port: 8501\nspring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/tingshu_album?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\n    username: root\n    password: Atguigu.123\n    hikari:\n      connection-test-query: SELECT 1\n      connection-timeout: 60000\n      idle-timeout: 500000\n      max-lifetime: 540000\n      maximum-pool-size: 10\n      minimum-idle: 5\n      pool-name: GuliHikariPool\nminio:\n  endpointUrl: http://localhost:9000\n  accessKey: admin\n  secreKey: admin123456\n  bucketName: tingshu\nvod:\n  appId: 1500036874 \n  secretId: AKIDNaYJpIeowqX0EcmiPr43oKhspZ9VeYDe\n  secretKey: GH3ZrvkJeldGdokRs54qNgmdFguugCTW\n  region: ap-beijing\n  procedure: SimpleAesEncryptPreset #任务流\n  #tempPath: /root/tingshu/tempPath\n  tempPath: D:\\code\\workspace2025\\tingshu\\temp   #临时存放上传文件\n', 'e14a360b6a9ea6309a172079424951d6', '2025-04-14 10:51:25', '2025-04-14 10:51:26', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (103, 125, 'service-canal-dev.yaml', 'DEFAULT_GROUP', '', 'server:\n  port: 8601\ncanal:\n  server: localhost:11112\n  destination: tingshuTopic', '06bec66415aebd0e42893c992a0d193b', '2025-04-14 10:52:03', '2025-04-14 10:52:04', 'nacos', '192.168.200.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (111, 126, 'service-flow-dev.yaml', 'DEFAULT_GROUP', '', 'server:\r\n  port: 8510\r\nspring:\r\n  datasource:\r\n    type: com.zaxxer.hikari.HikariDataSource\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    url: jdbc:mysql://localhost:3306/flowlong?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&useSSL=true\r\n    username: root\r\n    password: Atguigu.123\r\n    hikari:\r\n      connection-test-query: SELECT 1\r\n      connection-timeout: 60000\r\n      idle-timeout: 500000\r\n      max-lifetime: 540000\r\n      maximum-pool-size: 10\r\n      minimum-idle: 5\r\n      pool-name: GuliHikariPool\r\n', 'f05376d8cad7e9e715d33817eaba3d53', '2025-04-14 10:52:18', '2025-04-14 10:52:18', NULL, '192.168.200.1', 'D', '', '');

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `resource` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `action` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  UNIQUE INDEX `uk_role_permission`(`role` ASC, `resource` ASC, `action` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permissions
-- ----------------------------

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  UNIQUE INDEX `idx_user_role`(`username` ASC, `role` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES ('nacos', 'ROLE_ADMIN');

-- ----------------------------
-- Table structure for tenant_capacity
-- ----------------------------
DROP TABLE IF EXISTS `tenant_capacity`;
CREATE TABLE `tenant_capacity`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Tenant ID',
  `quota` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '配额，0表示使用默认值',
  `usage` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用量',
  `max_size` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '聚合子配置最大个数',
  `max_aggr_size` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '租户容量信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tenant_capacity
-- ----------------------------

-- ----------------------------
-- Table structure for tenant_info
-- ----------------------------
DROP TABLE IF EXISTS `tenant_info`;
CREATE TABLE `tenant_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `kp` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'kp',
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT 'tenant_id',
  `tenant_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT 'tenant_name',
  `tenant_desc` varchar(256) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'tenant_desc',
  `create_source` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'create_source',
  `gmt_create` bigint NOT NULL COMMENT '创建时间',
  `gmt_modified` bigint NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_info_kptenantid`(`kp` ASC, `tenant_id` ASC) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'tenant_info' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tenant_info
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`username`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', 1);

SET FOREIGN_KEY_CHECKS = 1;
