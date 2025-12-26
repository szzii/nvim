# Java 调试配置指南

## 已配置的组件

### 1. nvim-jdtls（调试支持）
- 插件位置：`lua/plugins/java.lua`
- 用途：提供 Java 调试集成
- 不会启动 LSP（由 nvim-lspconfig 负责）

### 2. nvim-lspconfig jdtls（LSP 支持）
- 配置位置：`lua/lsp/jdtls.lua`
- 用途：提供 Java 语言服务器功能

### 3. nvim-dap（调试核心）
- 插件位置：`lua/plugins/debug.lua`
- 用途：提供调试适配器协议支持

---

## 调试快捷键

### 通用调试快捷键（所有语言）
| 键位 | 功能 |
|------|------|
| `<F5>` | 开始/继续调试 |
| `<F6>` | 重启调试 |
| `<F4>` | 停止调试并关闭 UI |
| `<F9>` | 单步后退 |
| `<F10>` | 单步跳过 |
| `<F11>` | 单步进入 |
| `<F12>` | 单步跳出 |
| `<leader>b` | 切换断点 |
| `<leader>B` | 条件断点 |

### Java 特定快捷键
| 键位 | 功能 |
|------|------|
| `<leader>df` | 调试当前 Java 类 |
| `<leader>dt` | 调试当前测试方法 |
| `<leader>dT` | 调试整个测试类 |
| `<leader>dr` | 重启调试 |

---

## Java 调试使用方法

### 方法 1：调试当前文件（最常用）

1. **打开有 main 方法的 Java 文件**
   ```bash
   nvim src/main/java/com/example/App.java
   ```

2. **设置断点**
   - 移动光标到想断点的行
   - 按 `<leader>b` 或 `F9`（如果已映射）

3. **开始调试**
   - 按 `<leader>df` （Debug current Java class）
   - 或按 `<F5>` 开始调试

### 方法 2：调试测试方法

```java
// UserServiceTest.java
@Test
public void testGetUser() {
    // 光标放在测试方法上
    User user = userService.getUser("123");
    assertNotNull(user);
}
```

1. 光标放在测试方法上
2. 按 `<leader>dt` 调试单个测试
3. 按 `<leader>dT` 调试整个测试类

### 方法 3：使用 DAP 命令

1. 打开命令面板：`:DapNew`

2. 选择配置：`Debug current Java class`

3. 开始调试

---

## 调试 UI 布局

调试启动后会自动显示：

```
┌─────────────────────────────────┬─────────────────────────────────┐
│                                 │                                 │
│  代码编辑区                      │  DAP UI (右侧 35%)              │
│                                 │  ┌──────────────────────────┐   │
│  ● public void main(...)       │  │ Stacks (40%)             │   │
│    │                           │  │ ├─ main()               │   │
│  ▶ cursor at breakpoint →     │  │ └─ getUser()            │   │
│    User user = getUser();     │  ├──────────────────────────┤   │
│                                 │  │ Scopes (60%)             │   │
│                                 │  │ ├─ user : User          │   │
└─────────────────────────────────┤  │   ├─ id : "123"          │   │
                                  │  └──────────────────────────┘   │
                                  └─────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│ DAP UI (底部 10%) - Console                                    │
│ > Interactive REPL - 可以执行 Java 代码                          │
└─────────────────────────────────────────────────────────────────┘
```

---

## 断点类型

### 1. 普通断点
```vim
" 在当前行设置断点
<leader>b

" 或使用命令
:lua require('dap').toggle_breakpoint()
```

### 2. 条件断点
```vim
" 设置条件断点（当条件满足时才暂停）
<leader>B

" 输入条件，例如：
user.getId().equals("123")

" 或使用 Lua
:lua require('dap').set_breakpoint('user.getId().equals("123")', nil, nil)
```

### 3. 日志断点
```vim
" 输出日志但不暂停执行
:lua require('dap').set_breakpoint(nil, nil, 'print("User: " + user)')
```

---

## 调试操作

### 查看变量

1. **鼠标悬停**
   - 鼠标移到变量上会显示值

2. **使用 Hover 命令**
   ```vim
   <leader>H
   ```

3. **在 Scopes 面板查看**
   - 查看所有局部变量
   - 查看对象属性

### 修改变量值

在 DAP UI 的 Scopes 面板中：
1. 按 `e` 进入编辑模式
2. 修改变量值
3. 按 `Enter` 确认

### 执行表达式

在 Console REPL 中：
```java
// 执行任意 Java 代码
user.getName()
user.getId()
userService.deleteUser("456")
```

---

## 高级功能

### 1. 附加到正在运行的 Java 进程

```vim
:DapNew
" 选择: Attach to running Java process
```

默认端口：`5005`

启动 Java 程序时需要开启调试端口：
```bash
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -jar app.jar
```

### 2. 远程调试

修改配置中的 `hostName`：
```lua
{
    type = 'java',
    request = 'attach',
    name = 'Attach to remote Java process',
    hostName = '192.168.1.100',  -- 远程服务器 IP
    port = 5005,
}
```

### 3. 调试参数配置

在 `dap.configurations.java` 中添加：
```lua
{
    type = 'java',
    request = 'launch',
    name = 'Debug with VM args',
    mainClass = 'com.example.Main',
    vmArgs = '-Xmx512m -Dspring.profiles.active=dev',
    args = '--arg1 --arg2',
    env = {
        SPRING_PROFILES_ACTIVE = 'dev',
        DATABASE_URL = 'jdbc:mysql://localhost:3306/mydb',
    },
}
```

---

## 常见问题

### Q1: 调试器无法启动
**A**: 检查 JDTLS 是否正常工作
```vim
:LspInfo
" 应该看到 jdtls 客户端已连接
```

### Q2: 断点不生效
**A**:
1. 确认代码已编译：`mvn compile` 或 `gradle build`
2. 检查是否有调试符号
3. 尝试重启 JDTLS：`:LspRestart jdtls`

### Q3: 调试时卡住
**A**:
1. 按 `<F6>` 重启调试
2. 或按 `<F4>` 停止调试

### Q4: 找不到 main class
**A**:
1. 确保当前文件有 `public static void main` 方法
2. 文件名应该与类名匹配
3. 使用 `:DapNew` 手动输入 main 类名

### Q5: 如何调试 Spring Boot 应用
**A**:
```bash
# 启动 Spring Boot 应用时开启调试
./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"

# 然后在 Neovim 中附加调试器
:DapNew
" 选择 Attach to running Java process
```

---

## 项目特定配置

### Gradle 项目

确保 `build.gradle` 包含：
```groovy
apply plugin: 'java'

java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}
```

### Maven 项目

确保 `pom.xml` 包含：
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

---

## 示例工作流

### 调试 Spring Boot 应用

1. **启动应用（带调试端口）**
   ```bash
   ./gradlew bootRun --args='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005'
   ```

2. **在 Neovim 中打开源文件**
   ```bash
   nvim src/main/java/com/example/UserController.java
   ```

3. **设置断点**
   ```vim
   :15  " 跳到第 15 行
   <leader>b  " 设置断点
   ```

4. **附加调试器**
   ```vim
   :DapNew
   " 选择: Attach to running Java process
   ```

5. **在浏览器触发请求**
   ```
   http://localhost:8080/api/users/123
   ```

6. **调试开始！**
   - Neovim 会自动暂停在断点
   - 查看 Scopes 了解变量状态
   - 按 `<F10>` 单步执行
   - 在 Console 执行表达式

---

## 调试技巧

### 1. 条件断点调试循环
```java
for (User user : users) {
    // 设置条件断点：user.getId().equals("123")
    process(user);
}
```

### 2. 评估表达式
在调试过程中：
```vim
" 查看 user 对象的 name 属性
:lua require('dap.ui.widgets').hover()
```

### 3. 监视变量
在 DAP UI 中按 `w` 添加监视表达式

### 4. 快速跳转
```vim
" 跳到断点
<F8>

" 跳到光标位置
<C-w>d
```

---

## 需要帮助？

- 查看调试配置：`:lua vim.print(require('dap').configurations.java)`
- 查看适配器：`:lua vim.print(require('dap').adapters.java)`
- 检查 JDTLS 状态：`:LspInfo`
- 查看调试日志：`:DapShowLog`
