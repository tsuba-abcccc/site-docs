#!/usr/bin/env bash
#
# 手动部署脚本（macOS / Linux 版），与 deploy.cmd 做的事情相同：
#   1. 在本机构建网站
#   2. 把构建结果上传到服务器的临时目录 dist-next
#   3. 在服务器上检查上传结果
#   4. 用 dist-next 替换正在使用的 dist，旧版本保留为 dist-previous
#
# 用法：在仓库根目录运行  ./deploy.sh
# 前提：这台电脑能用 SSH 登录服务器（见文件末尾的说明）。

# 任何一步出错就立刻停止，避免带着错误继续往下执行。
set -euo pipefail

# 服务器地址和网站所在目录。需要临时换地址时可以这样运行：
#   REMOTE=root@别的地址 ./deploy.sh
REMOTE="${REMOTE:-root@1.15.101.124}"
REMOTE_ROOT="${REMOTE_ROOT:-/var/www/main}"

# 无论从哪个目录运行，都先切换到脚本所在的仓库根目录。
cd "$(dirname "$0")"

# 让下面几次连接共用同一条 SSH 通道。
# 如果是用密码登录，这样只需要输入一次密码，而不是每一步都输一次。
SSH_SOCKET="/tmp/site-docs-deploy-$$.sock"
SSH_OPTS=(-o ControlMaster=auto -o "ControlPath=${SSH_SOCKET}" -o ControlPersist=120)
cleanup() {
  ssh "${SSH_OPTS[@]}" -O exit "${REMOTE}" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "==> 1/4 构建网站"
pnpm docs:build

# 构建结果里必须有首页，否则不上传。
test -s docs/.vitepress/dist/index.html

echo "==> 2/4 上传到服务器的临时目录 ${REMOTE_ROOT}/dist-next"
ssh "${SSH_OPTS[@]}" "${REMOTE}" \
  "rm -rf '${REMOTE_ROOT}/dist-next' && install -d -m 755 '${REMOTE_ROOT}/dist-next'"
# -r 递归复制目录，-l 保留符号链接，-t 保留修改时间；
# 不上传 macOS 访达自动生成的 .DS_Store 文件。
rsync -rlt --exclude='.DS_Store' \
  -e "ssh ${SSH_OPTS[*]}" \
  docs/.vitepress/dist/ "${REMOTE}:${REMOTE_ROOT}/dist-next/"

echo "==> 3/4 在服务器上检查上传结果"
# 目录权限设为 755、文件设为 644；确认首页存在且不为空；确认样式文件存在且不为空。
ssh "${SSH_OPTS[@]}" "${REMOTE}" "set -eu
  find '${REMOTE_ROOT}/dist-next' -type d -exec chmod 755 {} +
  find '${REMOTE_ROOT}/dist-next' -type f -exec chmod 644 {} +
  test -s '${REMOTE_ROOT}/dist-next/index.html'
  find '${REMOTE_ROOT}/dist-next/assets' -maxdepth 1 -type f -name 'style.*.css' -size +0c | grep -q ."

echo "==> 4/4 切换到新版本"
# 先把正在使用的 dist 改名为 dist-previous，再把 dist-next 改名为 dist。
# 如果第二步失败，就把 dist-previous 改回 dist，网站保持原样。
ssh "${SSH_OPTS[@]}" "${REMOTE}" "set -eu
  rm -rf '${REMOTE_ROOT}/dist-previous'
  mv '${REMOTE_ROOT}/dist' '${REMOTE_ROOT}/dist-previous'
  if ! mv '${REMOTE_ROOT}/dist-next' '${REMOTE_ROOT}/dist'; then
    mv '${REMOTE_ROOT}/dist-previous' '${REMOTE_ROOT}/dist'
    exit 1
  fi"

echo "网站部署成功。上一个版本保留在：${REMOTE_ROOT}/dist-previous"

# ---------------------------------------------------------------------------
# 关于 SSH 登录
#
# 第一次连接服务器时，在终端运行：
#   ssh root@1.15.101.124
# 看到服务器指纹的提示后输入 yes，然后输入服务器的 root 密码。
#
# 想以后免密码，可以把这台电脑的公钥登记到服务器上（只需做一次）：
#   ssh-copy-id root@1.15.101.124
#
# 如果需要回退到上一个版本，登录服务器后把 dist-previous 换回来即可。
# ---------------------------------------------------------------------------
