tingshu-parent (聚合父工程, pom)
│
├── server-gateway          ★ 网关服务 (Spring Cloud Gateway)
│   ├── CorsConfig          跨域配置
│   └── AuthGlobalFilter    全局鉴权过滤器
│
├── service                 ★ 微服务业务模块 (聚合)
│   ├── service-album       专辑服务 (27个类, 最核心)
│   │   ├── 专辑/声音/分类 CRUD
│   │   └── 文件上传 (MinIO) + 点播 (腾讯云VOD)
│   ├── service-user        用户服务 (微信登录、VIP配置、收听进度、已购记录)
│   ├── service-account     账户服务 (余额账户)
│   ├── service-order       订单服务
│   ├── service-payment     支付服务 (微信支付 wxpay-sdk)
│   ├── service-search      搜索服务 (Elasticsearch)
│   └── service-dispatch    调度服务 (XXL-Job 定时任务)
│
├── service-client          ★ Feign 远程调用 API 模块 (聚合)
│   ├── service-album-client      ┐
│   ├── service-user-client       │ 每个 client 含:
│   ├── service-account-client    │  XxxFeignClient (接口)
│   ├── service-order-client      │  XxxDegradeFeignClient (降级)
│   └── service-search-client     ┘
│
├── common                  ★ 公共模块 (聚合)
│   ├── common-util         通用工具 (Result 统一返回、工具类)
│   ├── service-util        服务公共配置 (Redis/MyBatis-Plus/Knife4j 配置、
│   │                       全局异常、拦截器、常量)
│   ├── common-log          日志切面 (@注解 + AOP)
│   └── rabbit-util         RabbitMQ 封装 (配置/实体/常量/service)
│
├── model                   ★ 实体模块 (102个类, 被所有服务依赖)
│   ├── entity (model/)     按域分包: album, user, account, order,
│   ├── vo                  payment, search, comment, live,
│   ├── query               dispatch, system, base
│   └── validation
│
├── docker-compose          ★ 中间件部署 (非代码模块)
│   └── MySQL 8 / Redis 7 / Nacos 2.1 / Seata 1.6 / ES 8.5 +
│       Logstash + Kibana / Zipkin / MinIO / MongoDB / RabbitMQ / YApi
│
└── temp                    (空目录)
