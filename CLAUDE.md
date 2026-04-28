# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个 Neovim 配置（fork 自 [ayamir/nvimdots](https://github.com/ayamir/nvimdots)），目标版本为 Neovim 0.11 stable。插件由 [lazy.nvim](https://github.com/folke/lazy.nvim) 管理。

## 代码格式化

Lua 代码使用 [stylua](https://github.com/JohnnyMorganz/StyLua) 格式化，配置见 `stylua.toml`：Tab 缩进（宽度 4）、120 列宽、Unix 换行、双引号。

```sh
stylua .
```

## 架构

### 启动流程

`init.lua` → `require("core")` → `lua/core/init.lua`，依次执行：
1. 创建缓存目录
2. 设置 `<leader>` 为 `<Space>`
3. 配置 GUI、剪贴板、shell
4. `core.options` — vim 选项
5. `core.event` — 自动命令
6. `core.pack` — 引导 lazy.nvim 并聚合并加载全部插件
7. `keymap` — 所有按键映射

### 目录结构

```
lua/
├── core/           # 初始化核心：settings, global, options, event, pack
├── modules/
│   ├── plugins/    # 按分类聚合的插件声明（completion, editor, lang, tool, ui）
│   ├── configs/    # 各插件的配置回调（结构与 plugins/ 镜像对应）
│   └── utils/      # 公共工具函数
├── keymap/         # 按分类组织的按键映射（completion, editor, lang, tool, ui）
├── user/           # 用户个人覆盖配置（不入上游版本控制）
└── user_template/  # 新用户模板，复制到 lua/user/ 即可使用
```

### 插件系统 (`lua/core/pack.lua`)

- 插件声明定义在 `lua/modules/plugins/<分类>.lua` 中，以仓库名为键
- 配置回调位于 `lua/modules/configs/<分类>/<插件>.lua`
- `pack.lua` 将所有 `plugins/*.lua` 和 `user/plugins/*.lua` 聚合为 lazy.nvim 的 spec 列表
- 全局配置项（主题、LSP 依赖、禁用插件等）集中在 `lua/core/settings.lua`

### 用户覆盖机制

`lua/modules/utils/init.lua` 提供两个核心函数：

- **`extend_config(default, "user.xxx")`** — 将用户模块递归合并到默认配置中。用于 settings（`user.settings`）、options（`user.options`）、event（`user.event`）和 keymap。列表做追加，字典做递归合并。
- **`load_plugin(name, opts)`** — 配置一个插件，自动检查 `user/configs/<文件名>.lua` 是否存在。用户可返回 table（与默认配置合并）、function（替换默认配置）或 `false`（禁用此插件）。

用户的按键映射（`lua/user/keymap/`）通过 `require("modules.utils.keymap").replace()` 完全**替换**内置映射。

### 禁用与替换插件的陷阱

通过 `disabled_plugins` 禁用上游插件并用同名短名 fork 替换时，**必须**在 fork 声明中加 `name` 字段以避免短名冲突：

lazy.nvim 通过 **短名**（`/` 后面的部分，如 `wilder.nvim`）识别插件。`gelguy/wilder.nvim` 和 `handy-sun/wilder.nvim` 短名相同，`pack.lua` 会先注册 fork 声明，再追加 `{ "gelguy/wilder.nvim", enabled = false }`，后者合并覆盖前者导致两者一起被禁用。解决方法：

```lua
-- lua/user/plugins/tool.lua
tool["handy-sun/wilder.nvim"] = {
    name = "wilder",  -- 关键：用自定义名避开短名冲突
    branch = "fix/nvim-0.12-e704",
    -- ...
}

-- lua/user/settings.lua
settings["disabled_plugins"] = {
    "gelguy/wilder.nvim",  -- 禁用上游原版
}
```

### Vimscript E704：Neovim 0.12 的 Funcref 命名规则

Neovim 0.12 起严格执行 Vimscript 的 E704 规则：**函数内局部变量如果持有 Funcref（函数引用）类型的值，变量名必须大写开头**。

#### 规则要点

- 适用于函数内所有局部变量：`l:` 前缀（如 `l:handler`）和无前缀的（如 `handler`），两者等价
- 作用域前缀 **不豁免** 此规则——`l:expand` 和 `expand` 同样受限
- 全局变量（`g:`）、脚本变量（`s:`）等不受此规则约束
- 规则并非 0.12 新增，但此前未严格执行，0.12 开始报错

#### 高风险模式

赋值源不透明的场景最危险——变量大多数时候持有普通值（字符串、数字），但特定路径下会变成 Funcref：

```vim
" 大部分时候返回空字符串，但自定义命令补全时返回 Funcref
let l:expand = get(data, 'cmdline.expand', '')
```

典型来源：`get()`、`getbufvar()`、`getwinvar()` 等从字典/对象取值的函数，其返回值类型取决于运行时数据。

#### 适配停更插件的方法

1. grep 所有函数内的 `let l:` 和无前缀 `let` 赋值
2. 对每个变量追踪赋值源，判断是否可能为 Funcref
3. 若可能，将变量名首字母大写（如 `l:expand` → `l:Expand`），全项目批量替换
4. 仅改名不够——首字母必须大写，`l:cmd_expand` 仍小写开头同样触发 E704

#### 教训

此问题是"先宽松后严格"类兼容性问题的典型：规则长期不执行 → 开发者忽略 → 运行时严格执行 → 存量代码全部中招。类似案例：Python 2→3 的 `print` 从语句变函数、C 的隐式 int 到 C99 要求显式声明。

### 按键映射定义格式

使用 `"模式|按键"` → `map_cr(命令)` 加方法链的形式。示例（来自 `lua/keymap/init.lua`）：

```lua
["n|<leader>ph"] = map_cr("Lazy"):with_silent():with_noremap():with_nowait():with_desc("package: Show")
```

### 颜色系统

`modules/utils/init.lua` 维护一个动态调色板（自动检测 catppuccin 主题，否则 fallback 到内置暗色调色板）。提供 `blend()`、`darken()`、`lighten()` 等颜色操作函数，并为 lspsaga、alpha 仪表盘等生成高亮组。用户可通过 `settings.palette_overwrite` 覆盖调色板颜色。

## NixOS devshell

```sh
nix develop   # 设置 NVIM_APPNAME=nvimdots，将配置软链到 XDG_CONFIG_HOME
```

## 用户自定义

要自定义此配置，从 `lua/user_template/` 复制文件到 `lua/user/` 后编辑即可。模板结构与模块目录镜像对应：

```
lua/user/
├── settings.lua              # 覆盖 core.settings
├── options.lua               # 覆盖 vim 选项
├── event.lua                 # 覆盖/新增自动命令
├── keymap/                   # 替换按键映射（init.lua, completion.lua 等）
├── plugins/                  # 新增插件声明
└── configs/                  # 覆盖插件配置
```
