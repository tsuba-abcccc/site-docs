# site-docs 交接记录

- 记录日期：2026-11-17
- 记录人：Claude（Claude Code 会话）
- 基准提交：`b85defd`（分支 `main`）；本次改动是它之后的几个提交，已合并进 `main`
- 本文件放在仓库根目录，不在 `docs/` 下，因此不会被 VitePress 发布成网页。

本文分四部分：项目通读总结、通读时发现的问题及处理状态、本次会话的操作记录与判断依据、接手须知。

---

## 一、项目通读总结

### 1. 这个站是什么

一个 VitePress 1.6.4 的个人网站，站主 `_abcccc`（啊波呲 / 糍粑）。内容分两块：

- **个人部分**：首页、自介条、高中笔记、maimai 常用资源汇总、maimai 维护手册、《舞萌机台排队通用管理办法（试行）》及其 PDF 下载页。
- **塘沽金街舞萌公告板**：面向金街机厅玩家的公告与服务页。用 `maimai.abcccc.top` 访问根路径时，`config.ts` 里的一段内联脚本会跳转到 `/maimai-board`。机厅已于 2026-09-01 停业，公告板现在以停业通知为主。

### 2. 技术栈与依赖

| 项 | 内容 |
| --- | --- |
| 框架 | VitePress `^1.6.4`（Vue 3） |
| 包管理 | pnpm，`pnpm-workspace.yaml` 里允许 esbuild 构建脚本 |
| 页脚 | `@theojs/lumen` 的 `Footer` 组件，显示备案号和版权 |
| 图标 | `@lucide/vue` |
| PDF | `pdfjs-dist` 4.10.38、`vue-pdf-embed`、`leafer-ui`（缩略图画布） |
| 脚本 | `pnpm docs:dev` / `docs:build` / `docs:preview` |

### 3. 目录结构

```
.github/workflows/deploy.yml   推送任意 tag 或手动触发时构建并部署
deploy.cmd                     Windows 手动部署脚本
package.json                   包名 site-main
docs/
  .vitepress/
    config.ts                  站点配置
    data/FooterData.ts         页脚数据（备案号、作者链接）
    theme/
      index.ts                 注册全局组件，挂载页脚
      style.css                全站自定义样式
      utils/pageStats.ts       字数与阅读时间计算
      components/              7 个组件，见下
    cache/、dist/              构建缓存与产物（部分文件被 git 跟踪，见“接手须知”）
  public/                      静态资源：头像、PDF、捐款二维码、按键结构图等
  pdfs/                        笔记 PDF 的另一份副本（页面没有用到）
  *.md                         17 个页面
  QueueStatusPanel.vue 等 6 个文件   排队网页端，来自另一个仓库，见第三部分
```

### 4. 配置要点（`docs/.vitepress/config.ts`）

- `lang: zh-CN`，标题 `_abcccc`，`titleTemplate: 啊波呲`，`cleanUrls: true`，`lastUpdated: true`。
- Markdown 渲染钩子：在每个 `h1` 后注入 `<div class="article-meta-row"><UpdateTime /><ArticleMetadata /></div>`，显示更新日期、字数、阅读时间。
- Rollup 手动分包：`pdfjs`、`vue-pdf-embed`、`leafer` 各自成块。
- 侧边栏只有 6 项：自介条、高中笔记、排队管理办法、maimai 常用资源汇总、maimai 维护手册、塘沽金街舞萌公告板。
- 顶部导航：首页、更多（指向自介条）、GitHub。
- 本地搜索，界面文字已汉化。
- `head`：域名跳转脚本、Google Fonts（Roboto）。

### 5. 主题组件（`docs/.vitepress/theme/components/`）

| 组件 | 作用 |
| --- | --- |
| `UpdateTime.vue` | 显示页面最后更新日期（取自 git） |
| `ArticleMetadata.vue` | 统计正文字数和图片数，估算阅读时间 |
| `MaimaiBoardHome.vue` | 公告板首页内容 |
| `MaimaiBoardNav.vue` | 公告板子页面顶部和底部的“返回公告板”按钮。`current`、`backOnly` 两个属性目前不影响渲染 |
| `PdfViewer.vue` | 自写的 PDF 阅读器 |
| `PdfStandaloneViewer.vue` | 从地址栏参数读 `src`、`title` 的阅读器包装 |
| `PdfFullscreenLayout.vue` | 注册名为 `pdf-fullscreen`，作为 `pdf-viewer.md` 的自定义布局 |

`PdfViewer.vue` 的机制：先用 HEAD 或 `Range: bytes=0-0` 探测服务器是否支持分片；支持时按 512KB 一片、8 路并发下载，失败回退为整体下载；正文用虚拟滚动只渲染可见页前后各 2 页；侧栏有目录和缩略图两种模式，缩略图用 Leafer 画布绘制；支持 25% 到 1000% 缩放、全屏、下载、打印、新窗口打开。

### 6. 页面清单（`docs/*.md`）

| 文件 | 内容 | 备注 |
| --- | --- | --- |
| `index.md` | 首页 Hero：头像、两个按钮 | `features` 段被注释掉 |
| `intro.md` | 自介条：头像、MBTI、社交账号、游戏和音乐偏好等 | |
| `notes.md` | 高中物理学、化学笔记的 PDF 链接 | 直接链接 PDF 文件 |
| `passage.md` | 只有一句 `hello` | 占位页 |
| `pdf-viewer.md` | 独立 PDF 阅读页，使用 `pdf-fullscreen` 布局 | |
| `maimai.md` | maimai 常用资源汇总（定数表、谱面预览、wiki、音游地图） | |
| `maimai-maintenance.md` | maimai 维护手册：按键结构、键程、吃键与震键维修 | 1.5 节、触控维护、杂项未写完 |
| `queue-management-regulations.md` | 《舞萌机台排队通用管理办法（试行）》十一章共 107 条及编制说明 | |
| `regulations-download.md` | 管理办法的 PDF 下载和项目说明 | |
| `maimai-board.md` | 公告板首页，内容是 `<MaimaiBoardHome />` | `layout: page` |
| `maimai-closure-notice.md` | 停业及后续安排通知（机台、众筹物品、剩余款项、服务） | |
| `maimai-rules.md` | 游玩须知与电子排队规则 | 旧页面 |
| `get-gloves.md` | 机厅共享物品的存放位置与取用说明 | 旧页面 |
| `crowdfunding.md` | 2026 年 7 月维护众筹计划与收款公示（31 笔，¥603.74） | 旧页面 |
| `crowdfunding-old.md` | 6 月维护众筹收款账单（34 笔，¥802.95） | 旧页面 |
| `maimai-thanks.md` | 历次众筹与捐款的鸣谢名单 | 旧页面 |
| `queue-status.md` | 排队状态页，现在是静态的“服务暂停”说明 | 旧页面 |

公告板系列页面的共同约定：`navbar: false`、`sidebar: false`，`pageClass` 为 `maimai-board-page`、`get-gloves-page` 或 `maimai-queue-page`，样式都在 `style.css` 里按这三个类名限定。两份众筹账单的金额与笔数我逐行加总核对过，与页面合计一致。

### 7. 排队网页端（`docs/` 根目录下的 6 个文件）

`QueueStatusPanel.vue`、`PlayerAccountDialog.vue`、`MobileRegistrationFlow.vue`、`MobileProfileCreationFlow.vue`、`MobileProfileSettings.vue`、`machineConfiguration.js`，合计约 330KB，是“maimai Q”排队系统的网页客户端。

- **入口**：`QueueStatusPanel.vue`。地址栏带 `mobile_registration` 参数时显示扫码登记流程，带 `player_profile_creation` 时显示扫码建档流程，带 `account_binding` 时打开账户绑定对话框，否则显示排队面板。
- **排队面板**：每 10 秒拉取 `/api/queue-status`；显示各机台的游玩位置和等待位置、预计等待时间、机台分组、营业时间提示；快照超过 90 秒未更新视为过期。
- **“我的排队”**：未登录时把选中的登记标识存在浏览器 `localStorage`（键 `maimai-q:marked-registration:v1`）；登录后只按服务端返回的登记标识匹配。
- **线上登记**：按 QQ 查询玩家资料，选机台和本次游玩偏好，提交后轮询终端处理结果；创建后须 30 分钟内到现场签到。
- **日志**：按机台和操作来源筛选，分页加载。
- **玩家账户**（`PlayerAccountDialog.vue`）：QQ 加密码登录、扫码绑定、改资料、改头像、改密码、通知与隐私设置，以及对自己登记的远程操作（暂缓一次、暂时离开、转机台、改偏好、退出排队）。写操作带 CSRF 头。
- **接口地址**：默认是当前域名下的 `/api/queue-status`、`/api/player-account`、`/api/queue-logs`、`/api/queue-versions`、`/api/queue-online/*`、`/api/queue-mobile/sessions`、`/api/player-profile-creation/sessions`，都可用 `VITE_*` 环境变量覆盖。

**现状**：机厅停业后，这 6 个文件没有被任何页面或主题引用，`queue-status.md` 只显示服务暂停。站主已确认这是正常状态。

### 8. 部署

- **GitHub Actions**（`.github/workflows/deploy.yml`）：推送任意 tag 或手动触发。流程是安装依赖、构建、打包并发布为 GitHub Release、用 rsync 同步到服务器的 `/var/www/main/dist`，最后比对线上的 `.deploy-sha` 与本次提交。需要仓库密钥 `HOST`、`USERNAME`、`SSH_KEY`。
- **手动**（`deploy.cmd`）：Windows 脚本，构建后上传到 `dist-next`，校验后与 `dist` 互换，旧版本留在 `dist-previous`。
- 历史 tag 有两类：`queue-status-v*`（人工打的发布 tag）和 `deploy-<run id>-<attempt>`（工作流生成）。

---

## 二、通读时发现的问题及处理状态

| # | 问题 | 状态 |
| --- | --- | --- |
| 1 | 排队网页端 6 个文件没有被任何页面引用 | 站主确认正常（停业所致），不处理 |
| 2 | 页脚 GitHub 链接是 `aboci-abcccc`，其余地方是 `tsuba-abcccc` | **已修正** |
| 3 | 规则、鸣谢、众筹、共享物品等页面在公告板首页没有入口 | **已加入“旧页面”分组** |
| 4 | `queue-client-version.json` 是 0.13.4，而最近一条相关提交信息写的是 0.10.2 | 已查清，0.13.4 正确，见第三部分 |
| 5 | 维护手册未完成处和几处笔误 | 站主表示不用管 |
| 6 | `get-gloves.md` 里糍粑的 QQ 是 1335930347，自介条和规则页是 2249381656 | **未处理**，站主未回复 |
| 7 | `PdfViewer` 已注册但没有页面使用，`notes.md` 直接链接 PDF | **未处理**，站主未回复 |
| 8 | `.gitignore` 忽略了 `dist` 和 `cache`，但两者仍有部分文件被 git 跟踪 | **未处理**，站主未回复 |
| 9 | `docs/pdfs/` 与 `docs/public/` 各有一份笔记 PDF（约 19MB，两份 `note1.pdf` 大小不同），页面只用 `public` 那份 | **未处理**，站主未回复 |
| 10 | 源码里没有引用的图片：`zhongchou.png`、`zhongchou7.png`、`众筹群.bmp`、`透明头像2.jpg`、`头像5.webp` | **未处理**，站主未回复 |

第 6 到 10 项我在第一轮总结里提过，站主没有逐条回应，所以没有动。接手时如要处理，请先问站主。

---

## 三、本次会话的操作记录与判断依据

### 第 1 轮：通读项目

**要求**：通读网站源文件，细致到每个文件。

**做法**：逐个读完配置、部署脚本、主题、全部 Markdown 页面和 6 个排队组件。没有逐个打开的是图片、PDF、`pnpm-lock.yaml` 和已提交的构建产物。没有改动任何文件。

### 第 2 轮：按站主批注修改

**修改 1：页脚 GitHub 地址**

- 文件：`docs/.vitepress/data/FooterData.ts`，`aboci-abcccc` 改为 `tsuba-abcccc`。
- 判断：全仓库搜索 `aboci` 只有两处。另一处是 `intro.md` 里的微信号 `aboci_abcccc`（下划线），不是 GitHub 地址，没有动。

**修改 2：公告板首页加入旧页面入口**

- 文件：`docs/.vitepress/theme/components/MaimaiBoardHome.vue`、`docs/.vitepress/theme/style.css`。
- 做法：在停业通知与联系方式之间加一个“旧页面”分组，分组下有一句说明，每一行标题旁带“旧页面”小标签。
- 判断：
  - 从 git 历史取回了停业前的首页（`b85defd` 的上一个版本），当时有一个“服务”列表，对应的样式类 `maimai-service-*` 仍留在 `style.css` 里。所以直接复用原有结构和样式，只新增了标签样式 `.maimai-legacy-tag`。
  - 链接都是站内相对路径，在 `maimai.abcccc.top` 和主域名下都能用。
  - “游玩规则”的说明写成“排队规则”，停业前写的是“排卡规则”，因为规则页现在讲的是电子排队。

**查证：版本号的来源**

站主说版本号应与 GitHub 上的 `maimai-queue-terminal` 项目同步，但不清楚以前的更新逻辑。我在本机同级目录 `../maimai-queue-terminal` 里查到：

- `queue-client-version.json` 里的是“队列网站”自己的版本号，不是终端 App 的版本号。终端只发补丁时网站版本不动，所以终端是 0.13.6 时网站仍是 0.13.4。
- 取值来源是终端项目 `public-site/package.json` 的 `version`。
- 终端项目有脚本 `public-site/scripts/sync-site-main.mjs`（命令 `pnpm run sync:site-main -- --site-main <本仓库路径>`，加 `--check` 只比对不写入），把上述 6 个排队文件复制到本仓库 `docs/`。它不复制版本文件，版本文件每次是另外手改的。
- 用途：QQ Bot 读取线上的 `/queue-client-version.json` 并上报服务端，显示在排队页“机厅与系统 → 版本信息”里；服务端的“最新版本”来自环境变量 `QUEUE_LATEST_WEBSITE_VERSION`。
- 本仓库里这个文件只改过三次：2026-08-11 建为 0.10.1，08-12 改为 0.10.2，10-26 随组件大同步改为 0.13.4。
- 我用 `--check` 比对过，本仓库的 6 个排队文件与终端项目当前一致。

**结论**：版本文件不需要改。以后同步排队组件时，记得同时把这个文件改成 `public-site/package.json` 的版本号。

### 第 3 轮：补充两个入口

**要求**：把 6 月众筹账单页和排队状态页也加进“旧页面”。

- `MaimaiBoardHome.vue`：列表加入“排队状态”（放在最前，与停业前的顺序一致）和“6 月众筹账单”（放在“维护众筹”之后）。现在共 6 项：排队状态、共享物品、游玩规则、维护众筹、6 月众筹账单、特别鸣谢。
- `style.css`：新增图标底色 `.maimai-service-icon.is-teal`，给 6 月账单用，避免与已有五种颜色重复。
- `docs/crowdfunding-old.md`：在标题下加了 `<MaimaiBoardNav backOnly />`。原因是这一页原本没有返回公告板的按钮，而它隐藏了导航栏，从首页进去后只能靠浏览器后退。其余旧页面本来就有这个按钮。

### 第 4 轮：撰写本文件

**要求**：把操作和思考摘要以 Markdown 附在项目中，包含最初的通读总结。

- 放在仓库根目录而不是 `docs/`，因为 `docs/` 下的 Markdown 会被发布成网页。

### 验证方式

- 两次改动后都执行了 `pnpm docs:build`，构建通过。
- 用 `pnpm docs:preview` 起本地预览，在浏览器里以手机宽度查看了公告板首页（浅色和深色）、规则页、6 月账单页，并核对了首页三个 GitHub 链接都指向 `tsuba-abcccc`。
- 没有部署，也没有在线上环境验证。

### 本次会话改动的文件

| 文件 | 改动 |
| --- | --- |
| `docs/.vitepress/data/FooterData.ts` | 页脚 GitHub 地址 |
| `docs/.vitepress/theme/components/MaimaiBoardHome.vue` | 新增“旧页面”分组和 6 个入口 |
| `docs/.vitepress/theme/style.css` | 新增 `.maimai-legacy-tag`、`.maimai-service-icon.is-teal` |
| `docs/crowdfunding-old.md` | 新增返回公告板按钮 |
| `HANDOVER.md` | 本文件（新增） |
| `docs/.vitepress/dist/` 下 7 个文件 | 构建顺带刷新，不是手改，见下 |

### 第 5 轮：提交

**要求**：用合适的提交信息提交工作树中的更改。

- 当时位于默认分支 `main`，所以先新建了分支 `claude/board-legacy-pages`，再在该分支上提交，`main` 没有新增提交。
- 按内容分成四个提交：页脚地址修正、公告板旧页面入口、本交接记录、构建产物刷新。构建产物单独一个提交，不想保留时可以单独丢弃。

### 第 6 轮：合并

**要求**：合并到 `main`。

- 以快进方式把 `claude/board-legacy-pages` 合并进 `main`，没有产生合并提交；合并后删除了这个本地分支。
- **没有推送，也没有部署。** 要上线需要先推送 `main`，再按第一部分第 8 节的方式部署（推送 tag 才会触发）。

---

## 四、接手须知

1. **`docs/` 下的 `.md` 都会变成网页。** 不想公开的文档不要放进去。
2. **仓库在 GitHub 上是公开的。** 本文件一旦提交也会公开，提交前请确认内容可以公开。
3. **`dist` 被部分跟踪。** `docs/.vitepress/dist/` 下有一批文件被 git 跟踪（几个页面、头像图片、字体等）。每次本地构建都会让其中 7 个显示为已修改：`404.html`、`index.html`、`intro.html`、`notes.html`、`passage.html`、`get-gloves.html`、`hashmap.json`。以往的提交里带过这类文件。不想带上时，提交前执行 `git checkout -- docs/.vitepress/dist` 还原。
4. **本地环境。** 本次在仓库里执行过 `pnpm install --frozen-lockfile`，生成了 `node_modules/`（已被忽略）。仓库所在磁盘是 exFAT，安装约需两分钟。
5. **排队组件不要在本仓库里直接改。** 它们的源头在 `maimai-queue-terminal/public-site/src/queue/`，在本仓库改了会被下次同步覆盖。
6. **部署由 tag 触发。** 推送提交不会部署，推送 tag 才会。
7. **旧页面只在入口处做了标注。** 6 个旧页面的正文里没有“本页已不再更新”之类的提示，如需要可在各页标题下加一个提示块。
8. **未处理事项**见第二部分第 6 到 10 项。
