# LSP 高级代码分析功能使用指南

## 已配置的快捷键

### 1. 调用关系分析

| 快捷键 | 功能 | 描述 |
|--------|------|------|
| `<leader>ci` | incoming_calls | 显示调用者（谁调用了当前函数） |
| `<leader>co` | outgoing_calls | 显示被调用者（当前函数调用了谁） |

### 2. 层次结构分析

| 快捷键 | 功能 | 描述 |
|--------|------|------|
| `<leader>th` | type_hierarchy | 显示类型层次结构（继承关系） |
| `<leader>ch` | call_hierarchy | 显示调用层次结构 |

---

## 功能详解

### 1. Incoming Calls（调用者）

**作用**: 查看哪些地方调用了当前函数/方法

**快捷键**: `<leader>ci`

**使用示例**:

```python
# utils.py
def process_user(user_id: str) -> User:
    # 光标放在 process_user 上，按 <leader>ci
    return get_user(user_id)

# main.py
user = process_user("123")    # ← 会显示这个调用
user = process_user("456")    # ← 和这个调用

# api.py
def handle_request():
    process_user("789")       # ← 还有这个调用
```

**返回结果**:
```
Incoming calls to process_user:
  main.py:15  - process_user("123")
  main.py:20  - process_user("456")
  api.py:8    - handle_request() → process_user("789")
```

### 2. Outgoing Calls（被调用者）

**作用**: 查看当前函数调用了哪些其他函数

**快捷键**: `<leader>co`

**使用示例**:

```python
def handle_request(user_id: str):
    # 光标放在 handle_request 上，按 <leader>co
    user = get_user(user_id)          # ← 调用了 get_user
    validated = validate(user)        # ← 调用了 validate
    result = save_to_db(user)         # ← 调用了 save_to_db
    send_notification(user.email)     # ← 调用了 send_notification
    return result
```

**返回结果**:
```
Outgoing calls from handle_request:
  get_user(user_id)
  validate(user)
  save_to_db(user)
  send_notification(user.email)
```

### 3. Type Hierarchy（类型层次结构）

**作用**: 查看类的继承关系和类型层次

**快捷键**: `<leader>th`

**使用示例**:

```typescript
// 光标放在 Dog 类上，按 <leader>th
class Animal {
    name: string;
}

class Dog extends Animal {
    breed: string;
}

class Labrador extends Dog {
    color: string;
}
```

**返回结果**:
```
Type Hierarchy for Dog:
  ↑ (父类)
  Animal
    ↑
    Dog (当前)
    ↓ (子类)
    Labrador
```

### 4. Call Hierarchy（调用层次结构）

**作用**: 完整的调用链分析

**快捷键**: `<leader>ch`

**使用示例**:

```typescript
function main() {
    processOrder();
}

function processOrder() {
    validateOrder();
    chargePayment();
}

function validateOrder() {
    checkInventory();
    verifyAddress();
}
```

**返回结果**:
```
Call Hierarchy:
  main()
    └─ processOrder()
        ├─ validateOrder()
        │   ├─ checkInventory()
        │   └─ verifyAddress()
        └─ chargePayment()
```

---

## 实际使用场景

### 场景 1: 代码重构

**问题**: 需要重构一个函数，想知道会影响哪些地方

**解决**:
1. 光标放在函数上
2. 按 `<leader>ci` 查看所有调用者
3. 评估重构影响范围

```python
# 光标在 calculate_discount 上
def calculate_discount(amount, customer_level):
    # 按 <leader>ci
    return amount * get_discount_rate(customer_level)

# 会显示所有调用 calculate_discount 的地方：
# checkout.py:42
# order.py:18
# cart.py:105
```

### 场景 2: 理解复杂代码

**问题**: 接手新代码，需要理解函数调用了哪些依赖

**解决**:
1. 光标放在目标函数上
2. 按 `<leader>co` 查看所有依赖
3. 绘制调用图

```typescript
function processPayment(orderId: string) {
    // 光标在这里，按 <leader>co
    const order = getOrder(orderId);
    const payment = createPayment(order);
    const result = chargePayment(payment);
    notifyUser(order.customerId);
    return result;
}
```

### 场景 3: 面向对象设计分析

**问题**: 需要理解类之间的继承关系

**解决**:
1. 光标放在类名上
2. 按 `<leader>th` 查看继承层次

```java
// 光标在 UserService 上
public class UserService extends BaseService {
    // 按 <leader>th 查看继承关系
}
```

### 场景 4: 追踪执行流程

**问题**: 需要理解完整的执行流程

**解决**:
1. 光标放在入口函数
2. 按 `<leader>ch` 查看完整调用链

```typescript
function handleUserLogin(username: string) {
    // 光标在这里，按 <leader>ch
    const user = authenticateUser(username);
    const session = createSession(user);
    logAccess(user);
    return redirect(user);
}
```

---

## 支持的语言

| 功能 | Python | TypeScript/JS | Java | C++ | Go |
|------|--------|----------------|------|-----|-----|
| incoming_calls | ✅ pyright | ✅ | ✅ | ⚠️ | ⚠️ |
| outgoing_calls | ✅ pyright | ✅ | ✅ | ⚠️ | ⚠️ |
| type_hierarchy | ⚠️ | ✅ | ✅ | ⚠️ | ⚠️ |
| call_hierarchy | ✅ pyright | ✅ | ✅ | ⚠️ | ⚠️ |

✅ 完全支持  | ⚠️ 部分支持  | ❌ 不支持

---

## 快捷键速查表

| 键位 | 功能 | 记忆技巧 |
|------|------|----------|
| `<leader>ci` | incoming_calls | **C**alls **I**ncoming (进入的调用) |
| `<leader>co` | outgoing_calls | **C**alls **O**utgoing (出去的调用) |
| `<leader>th` | type_hierarchy | **T**ype **H**ierarchy (类型层次) |
| `<leader>ch` | call_hierarchy | **C**all **H**ierarchy (调用层次) |

---

## 完整的 LSP 快捷键列表

### 代码导航
| 键位 | 功能 |
|------|------|
| `<leader>d` | 跳转到定义 |
| `<leader>D` | 跳转到类型定义 |
| `<leader>v` | 跳转到实现 |
| `<leader>r` | 查找引用 |
| `<leader>h` | 悬停文档 |
| `<leader>m` | 签名帮助 |

### 代码分析
| 键位 | 功能 |
|------|------|
| `<leader>ci` | 显示调用者 |
| `<leader>co` | 显示被调用者 |
| `<leader>th` | 类型层次结构 |
| `<leader>ch` | 调用层次结构 |

### 代码操作
| 键位 | 功能 |
|------|------|
| `<leader>z` | 代码操作 |
| `<space>k` | 重命名符号 |

### 诊断导航
| 键位 | 功能 |
|------|------|
| `<leader>[` | 上一个诊断 |
| `<leader>]` | 下一个诊断 |
| `<leader>q` | 诊断列表 |
| `<space>w` | 浮动窗口显示诊断 |

---

## 注意事项

1. **LSP 支持差异**: 不同 LSP 服务器对这4个功能的支持程度不同
   - **最佳支持**: Java (jdtls), TypeScript (ts_ls)
   - **良好支持**: Python (basedpyright)
   - **有限支持**: Go (gopls), C++ (clangd)

2. **性能考虑**: 在大型项目中，调用层次分析可能需要几秒钟

3. **配合使用**: 建议结合 `definition` 和 `references` 一起使用

4. **Telescope 集成**: 这些功能会使用 Telescope 或 Quickfix 窗口显示结果

---

## 示例工作流

### 理解新代码库

1. **找到入口点** - 使用 `<leader>d` 跳转到 main 函数
2. **查看调用链** - 使用 `<leader>ch` 查看完整流程
3. **深入细节** - 使用 `<leader>co` 查看每个函数的依赖
4. **理解结构** - 使用 `<leader>th` 查看类继承关系

### 调试和优化

1. **找到问题函数** - 使用 `<leader>ci` 查看谁在调用
2. **分析依赖** - 使用 `<leader>co` 查看函数依赖
3. **重构优化** - 使用 `<leader>r` 查找所有引用后重构

---

## 需要帮助？

- 查看完整的 LSP 功能列表: `:help lsp`
- 检查 LSP 状态: `:LspInfo`
- 查看日志: `:LspLog`
