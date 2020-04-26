---
title: Graphql
date: 2020-04-25 13:27:25
tags:
typora-root-url: ..
---

# 优点
## 一种用于 API 的查询语言
GraphQL 既是一种用于 API 的查询语言也是一个满足你数据查询的运行时。 GraphQL 对你的 API 中的数据提供了一套易于理解的完整描述，使得客户端能够准确地获得它需要的数据，而且没有任何冗余，也让 API 更容易地随着时间推移而演进，还能用于构建强大的开发者工具。

## 请求你所要的数据 不多不少
向你的 API 发出一个 GraphQL 请求就能准确获得你想要的数据，不多不少。 GraphQL 查询总是返回可预测的结果。使用 GraphQL 的应用可以工作得又快又稳，因为控制数据的是应用，而不是服务器。

## 获取多个资源 只用一个请求
GraphQL 查询不仅能够获得资源的属性，还能沿着资源间引用进一步查询。典型的 REST API 请求多个资源时得载入多个 URL，而 GraphQL 可以通过一次请求就获取你应用所需的所有数据。这样一来，即使是比较慢的移动网络连接下，使用 GraphQL 的应用也能表现得足够迅速。

## 描述所有的可能 类型系统
GraphQL API 基于类型和字段的方式进行组织，而非入口端点。你可以通过一个单一入口端点得到你所有的数据能力。GraphQL 使用类型来保证应用只请求可能的数据，还提供了清晰的辅助性错误信息。应用可以使用类型，而避免编写手动解析代码。

## API 演进 无需划分版本

给你的 GraphQL API 添加字段和类型而无需影响现有查询。老旧的字段可以废弃，从工具中隐藏。通过使用单一演进版本，GraphQL API 使得应用始终能够使用新的特性，并鼓励使用更加简洁、更好维护的服务端代码。

## 使用你现有的 数据和代码

GraphQL 让你的整个应用共享一套 API，而不用被限制于特定存储引擎。GraphQL 引擎已经有多种语言实现，通过 GraphQL API 能够更好利用你的现有数据和代码。你只需要为类型系统的字段编写函数，GraphQL 就能通过优化并发的方式来调用它们。

# 入门

## Maven

graphql-java需要运行在java 8 及其以上

```xml
<dependency>
    <groupId>com.graphql-java</groupId>
    <artifactId>graphql-java</artifactId>
    <version>14.0</version>
</dependency>
```

## Hello World

```java
import graphql.ExecutionResult;
import graphql.GraphQL;
import graphql.schema.GraphQLSchema;
import graphql.schema.StaticDataFetcher;
import graphql.schema.idl.RuntimeWiring;
import graphql.schema.idl.SchemaGenerator;
import graphql.schema.idl.SchemaParser;
import graphql.schema.idl.TypeDefinitionRegistry;

import static graphql.schema.idl.RuntimeWiring.newRuntimeWiring;

public class HelloWorld {

    public static void main(String[] args) {
        String schema = "type Query{hello: String}";

        SchemaParser schemaParser = new SchemaParser();
        TypeDefinitionRegistry typeDefinitionRegistry = schemaParser.parse(schema);

        RuntimeWiring runtimeWiring = newRuntimeWiring()
                .type("Query", builder -> builder.dataFetcher("hello", new StaticDataFetcher("world")))
                .build();

        SchemaGenerator schemaGenerator = new SchemaGenerator();
        GraphQLSchema graphQLSchema = schemaGenerator.makeExecutableSchema(typeDefinitionRegistry, runtimeWiring);

        GraphQL build = GraphQL.newGraphQL(graphQLSchema).build();
        ExecutionResult executionResult = build.execute("{hello}");

        System.out.println(executionResult.getData().toString());
        // Prints: {hello=world}
    }
}
```

# Schema
## SDL

```javascript
# 审判组织成员
interface Spzzcy{
    # 编号
    bh: ID
    # 角色
    js: String
    # 姓名
    xm: String
}
# 通用审判组织成员
type T_FY_SPZZCY implements Spzzcy{
    bh: ID
    js: String
    xm: String
}

```

## DataFetcher

```java
/**
 * 获取诉讼档案
 * @return 诉讼档案获取器
 */
public DataFetcher getSsda() {
	return env -> {
		GraphQLContext context = env.getContext();
		Set<String> columns = GraphQLUtils.getColumns(env.getSelectionSet(), env.getFieldType());
		Integer ajlb = context.get("ajlb");
		String bhaj = context.get("bhaj");
		return graphqlDao.getSsda(ajlb, bhaj, columns);
	};
}
```

## TypeResolver

```java
/**
 * 获取类型转换器
 * @return 类型转换器
 */
public static TypeResolver getTypeResolver(String alias) {
	return env -> {
		GraphQLContext context = env.getContext();
		return GraphQLUtils.getType(env.getSchema(), context.get("ajlb"), alias);
	};
}
```

## Types

GraphQL 支持以下数据类型

- Scalar
- Object
- Interface
- Union
- InputObject
- Enum

# Execution

## 查询

```java
/**
 * 查询数据
 * @param ywlx 业务类型
 * @param query 查询条件
 * @param variables 查询变量
 * @return 案件数据
 */
@Override
public Map<String, Object> query(Integer ywlx, String query, Map<String, Object> variables) {
	//当业务类型查询不到相应的案件类别时，（有可能是业务标识为<司法辅助>司法辅助没有业务类型，用的是业务标识）如果案件类别为空，则返回
	Integer ajlb = ZzfwGyUtils.getAjlbByYwlx(ywlx);
	if (ajlb == null) {
		logger.error("未根据所传业务类型找到对应的案件类别,业务类型:{}", ywlx);
		return NOT_FOUND;
	}
	IDictCache dict = DictManager.getDict(ajlb);
	logger.info("ywlx:{},query:{},variables,{}",ywlx,query,variables);
	ExecutionInput executionInput = ExecutionInput.newExecutionInput()
			.context(GraphQLContext.newContext().of("ywlx",ywlx).of("ajlb", ajlb))
			.variables(variables)
			.root(dict)
			.query(query)
			.build();
	ExecutionResult execute = graphQL.execute(executionInput);
	return execute.toSpecification();
}
```

## Data Fetchers

每个graphql字段类型都有一个`graphql.schema.DataFetcher`关联。其他语言的graphql实现通常将这种代码称为`resolvers`。

如果没有在字段上指定DataFetcher，则将使用`graphql.schema.PropertyDataFetcher`来获取Java POJO对象的字段值。



# Data mapping

## PropertyDataFetcher

GraphQL-Java默认的`graphql.schema.PropertyDataFetcher`支持Map或者POJO
对于Schema中的每个对象，会通过Map的get(String key)方法或者POJO的getter方法获取它并返回



# SDL Directives

## 附加操作

### 原来的SDL

我们可以看到js属性是个代码值我们需要进行转换，这个通常需要在data fetcher中进行处理

```javascript
# 通用审判组织成员
type T_FY_SPZZCY implements Spzzcy{
    bh: ID
    js: String
    xm: String
}

```

### 但是我们现在有更简单的方法
```javascript
# 设置代码转换 使用Artery数据字典
directive @dict on FIELD_DEFINITION
# 通用审判组织成员
type T_FY_SPZZCY implements Spzzcy{
    bh: ID
    js: String @dict
    xm: String
}
```
