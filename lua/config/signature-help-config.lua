-- Signature Help 高级配置示例
-- 将此配置添加到 lua/plugins/lsp.lua 中

-- ========== 方案 1: 基础配置（推荐）==========
-- 只配置手动触发，性能最好

vim.keymap.set("n", "<leader>m", vim.lsp.buf.signature_help, {
    desc = "signature_help"
})

vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, {
    desc = "signature_help"
})


-- ========== 方案 2: 智能自动触发 ==========
-- 使用 debounce 避免频繁请求

local signature_help_group = vim.api.nvim_create_augroup("SignatureHelp", { clear = true })
local signature_help_timer = nil

local function trigger_signature_help()
    -- 清除之前的定时器
    if signature_help_timer then
        vim.fn.timer_stop(signature_help_timer)
        signature_help_timer = nil
    end

    -- 延迟触发（避免频繁请求）
    signature_help_timer = vim.fn.timer_start(200, function()
        -- 检查是否在插入模式
        if vim.api.nvim_get_mode().mode == "i" then
            vim.lsp.buf.signature_help()
        end
    end)
end

-- 只在特定字符后触发
vim.api.nvim_create_autocmd("TextChangedI", {
    group = signature_help_group,
    callback = function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]

        -- 检查光标前的字符
        local prev_char = line:sub(col, col)
        local prev_prev_char = line:sub(col - 1, col - 1)

        -- 输入 '(' 或 ',' 后触发
        if prev_char == "(" or (prev_char == " " and prev_prev_char == ",") then
            trigger_signature_help()
        end
    end,
})


-- ========== 方案 3: 使用 cmp-nvim-lsp-signature-help ==========
-- 如果你使用 nvim-cmp，这是最佳方案

-- {
--     "hrsh7th/cmp-nvim-lsp-signature-help",
--     event = "InsertEnter",
--     dependencies = { "hrsh7th/nvim-cmp" },
--     config = function()
--         require("cmp").setup({
--             sources = {
--                 { name = "nvim_lsp_signature_help" }
--             }
--         })
--     end,
-- }


-- ========== 方案 4: 自定义浮动窗口样式 ==========

-- 配置浮动窗口边框和样式
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
        -- 使用边框
        border = "rounded",
        -- 自动聚焦到浮动窗口
        focusable = true,
        -- 浮动窗口在其他窗口之上
        zindex = 50,
        -- 关闭其他浮动窗口
        noautocmd = false,
    }
)


-- ========== 方案 5: 按语言配置 ==========

local signature_help_config = {
    -- Python: 自动触发
    python = {
        auto_trigger = true,
        trigger_chars = { "(", "," },
    },
    -- TypeScript: 自动触发
    typescript = {
        auto_trigger = true,
        trigger_chars = { "(", ",", "<" },
    },
    -- Lua: 手动触发
    lua = {
        auto_trigger = false,
        trigger_chars = { "(" },
    },
}

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end

        local filetype = vim.api.nvim_buf_get_option(ev.buf, "filetype")
        local config = signature_help_config[filetype]

        if config and config.auto_trigger then
            vim.api.nvim_create_autocmd("TextChangedI", {
                buffer = ev.buf,
                callback = function()
                    local line = vim.api.nvim_get_current_line()
                    local col = vim.api.nvim_win_get_cursor(0)[2]
                    local char = line:sub(col, col)

                    if vim.tbl_contains(config.trigger_chars, char) then
                        vim.lsp.buf.signature_help()
                    end
                end,
            })
        end
    end,
})


-- ========== 实用函数 ==========

-- 切换自动签名帮助
local auto_signature_help_enabled = false

function ToggleSignatureHelp()
    auto_signature_help_enabled = not auto_signature_help_enabled

    if auto_signature_help_enabled then
        vim.notify("Signature help auto-trigger enabled", vim.log.levels.INFO)
    else
        vim.notify("Signature help auto-trigger disabled", vim.log.levels.INFO)
    end
end

vim.api.nvim_create_user_command("ToggleSignatureHelp", ToggleSignatureHelp, {})


-- 显示当前函数签名（Normal 模式）
function ShowCurrentSignature()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, "textDocument/signatureHelp", params, function(err, result, ctx)
        if err or not result or #result.signatures == 0 then
            return
        end

        local signature = result.signatures[1]
        local signature_label = signature.label

        -- 显示在浮动窗口
        vim.lsp.util.open_floating_preview(
            { signature_label },
            {}
        )
    end)
end

vim.keymap.set("n", "<leader>sh", ShowCurrentSignature, {
    desc = "Show current function signature"
})
