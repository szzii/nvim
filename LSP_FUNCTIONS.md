# Neovim LSP 所有可用功能参考

## 1. vim.lsp.buf - Buffer 相关功能

### 代码导航
| 函数 | 描述 | 默认键位 (0.11) |
|------|------|----------------|
| `vim.lsp.buf.definition()` | 跳转到定义 | `<C-]>` |
| `vim.lsp.buf.declaration()` | 跳转到声明 | `gD` |
| `vim.lsp.buf.type_definition()` | 跳转到类型定义 | - |
| `vim.lsp.buf.implementation()` | 跳转到实现 | `gri` |
| `vim.lsp.buf.references()` | 查找引用 | `grr` |

### 文档和帮助
| 函数 | 描述 | 默认键位 (0.11) |
|------|------|----------------|
| `vim.lsp.buf.hover()` | 显示悬停文档 | `K` |
| `vim.lsp.buf.signature_help()` | 显示签名帮助 | `<C-s>` (插入模式) |
| `vim.lsp.buf.document_symbol()` | 显示当前文档符号 | `gO` |

### 代码操作
| 函数 | 描述 | 默认键位 (0.11) |
|------|------|----------------|
| `vim.lsp.buf.code_action()` | 执行代码操作 | `gra` |
| `vim.lsp.buf.rename()` | 重命名符号 | `grn` |
| `vim.lsp.buf.format()` | 格式化代码 | - |

### 工作区功能
| 函数 | 描述 |
|------|------|
| `vim.lsp.buf.workspace_symbol()` | 搜索工作区符号 |
| `vim.lsp.buf.add_workspace_folder()` | 添加工作区文件夹 |
| `vim.lsp.buf.remove_workspace_folder()` | 移除工作区文件夹 |
| `vim.lsp.buf.list_workspace_folders()` | 列出工作区文件夹 |

### 高级功能
| 函数 | 描述 |
|------|------|
| `vim.lsp.buf.incoming_calls()` | 显示调用者 |
| `vim.lsp.buf.outgoing_calls()` | 显示被调用者 |
| `vim.lsp.buf.typehierarchy()` | 显示类型层次结构 |
| `vim.lsp.buf.call_hierarchy()` | 显示调用层次结构 |

### 其他
| 函数 | 描述 |
|------|------|
| `vim.lsp.buf.document_highlight()` | 高亮引用 |
| `vim.lsp.buf.clear_references()` | 清除高亮 |
| `vim.lsp.buf.execute_command()` | 执行自定义命令 |

## 2. vim.diagnostic - 诊断相关功能

### 导航
| 函数 | 描述 | 默认键位 (0.11) |
|------|------|----------------|
| `vim.diagnostic.goto_prev()` | 跳转到上一个诊断 | `[d` |
| `vim.diagnostic.goto_next()` | 跳转到下一个诊断 | `]d` |

### 显示
| 函数 | 描述 | 默认键位 (0.11) |
|------|------|----------------|
| `vim.diagnostic.open_float()` | 浮动窗口显示诊断 | `<C-w>d` |
| `vim.diagnostic.setloclist()` | 将诊断添加到 location list | - |
| `vim.diagnostic.setqflist()` | 将诊断添加到 quickfix list | - |

### 配置
| 函数 | 描述 |
|------|------|
| `vim.diagnostic.config()` | 配置诊断显示 |
| `vim.diagnostic.disable()` | 禁用诊断 |
| `vim.diagnostic.enable()` | 启用诊断 |
| `vim.diagnostic.reset()` | 重置诊断 |
| `vim.diagnostic.is_disabled()` | 检查是否禁用 |
| `vim.diagnostic.is_enabled()` | 检查是否启用 |
| `vim.diagnostic.hide()` | 隐藏诊断 |
| `vim.diagnostic.show()` | 显示诊断 |

### 获取信息
| 函数 | 描述 |
|------|------|
| `vim.diagnostic.get()` | 获取诊断信息 |
| `vim.diagnostic.from_positions()` | 从位置创建诊断 |

## 3. vim.lsp - 核心 LSP 功能

### 客户端管理
| 函数 | 描述 |
|------|------|
| `vim.lsp.start()` | 启动 LSP 客户端 |
| `vim.lsp.stop()` | 停止 LSP 客户端 |
| `vim.lsp.restart()` | 重启 LSP 客户端 |
| `vim.lsp.get_active_clients()` | 获取活跃客户端 |
| `vim.lsp.get_client_by_id()` | 通过 ID 获取客户端 |
| `vim.lsp.get_clients()` | 获取客户端列表 |

### 协议功能
| 函数 | 描述 |
|------|------|
| `vim.lsp.protocol()` | LSP 协议常量 |
| `vim.lsp.util` | LSP 工具函数 |
| `vim.lsp.codelens` | 代码镜头功能 |
| `vim.lsp.semantic_tokens` | 语义标记功能 |
| `vim.lsp.inlay_hint` | 内联提示功能 |
| `vim.lsp.completion` | 补全功能 |

### 日志
| 函数 | 描述 |
|------|------|
| `vim.lsp.set_log_level()` | 设置日志级别 |
| `vim.lsp.get_log_level()` | 获取日志级别 |
| `vim.lsp.get_log_path()` | 获取日志文件路径 |

### 配置 (Neovim 0.11+)
| 函数 | 描述 |
|------|------|
| `vim.lsp.config()` | 配置 LSP 服务器 |
| `vim.lsp.enable()` | 启用 LSP 服务器 |
| `vim.lsp.disable()` | 禁用 LSP 服务器 |
| `vim.lsp.add()` | 添加 LSP 配置 |
| `vim.lsp.reset()` | 重置 LSP 配置 |

### 其他
| 函数 | 描述 |
|------|------|
| `vim.lsp.buf_request_all()` | 向所有服务器发送请求 |
| `vim.lsp.buf_request_sync()` | 同步发送请求 |
| `vim.lsp.tagfunc()` | 标签函数 |
| `vim.lsp.cxx_symbols()` | C++ 符号支持 |
| `vim.lsp.status()` | LSP 状态 |

## 4. Neovim 0.11 内置默认键位

### 模式：Normal
| 键位 | 功能 |
|------|------|
| `K` | 显示悬停文档 |
| `grr` | 查找引用 |
| `gri` | 跳转到实现 |
| `grn` | 重命名符号 |
| `gra` | 代码操作 |
| `gO` | 文档符号列表 |
| `gD` | 跳转到声明 |
| `[d` | 上一个诊断 |
| `]d` | 下一个诊断 |
| `<C-w>d` | 浮动窗口显示诊断 |
| `<C-]>` | 跳转到定义 |
| `<C-t>` | 返回跳转前位置 |

### 模式：Insert
| 键位 | 功能 |
|------|------|
| `<C-s>` | 签名帮助 |

### 模式：Visual
| 键位 | 功能 |
|------|------|
| `gra` | 代码操作（选中文本） |

## 5. 你的配置中的映射

### 诊断导航
| 键位 | 功能 |
|------|------|
| `<leader> [` | 上一个诊断 |
| `<leader> ]` | 下一个诊断 |
| `<leader>q` | 诊断列表 |
| `<space>w` | 浮动窗口显示诊断 |

### 自定义 LSP 功能
| 键位 | 功能 |
|------|------|
| `<leader>d` | 跳转到定义 |
| `<leader>h` | 悬停文档 |
| `<leader>D` | 类型定义 |
| `<leader>z` | 代码操作 |
| `<space>k` | 重命名符号 |

## 6. 常用命令

| 命令 | 描述 |
|------|------|
| `:LspInfo` | 显示 LSP 客户端信息 |
| `:LspLog` | 打开 LSP 日志文件 |
| `:LspRestart` | 重启 LSP 客户端 |
| `:LspStop` | 停止 LSP 客户端 |
| `:LspStart` | 启动 LSP 客户端 |
| `:checkhealth lsp` | 检查 LSP 健康状态 |

## 7. 可以添加的功能

### 1. 格式化
```lua
vim.keymap.set('n', '<space>f', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format' })
```

### 2. 工作区符号搜索
```lua
vim.keymap.set('n', '<leader>s', vim.lsp.buf.workspace_symbol, { desc = 'Workspace Symbol' })
```

### 3. 高亮引用
```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd('CursorHold', {
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
```

### 4. 内联提示（如果支持）
```lua
vim.keymap.set('n', '<leader>th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle Inlay Hints' })
```

## 8. 性能优化提示

- 禁用语义高亮（你已配置）
- 使用 `maxResults` 限制补全结果
- 禁用不需要的 Code Lens
- 使用 `debounce_text_changes` 减少请求频率
- 只在需要时启用诊断功能
