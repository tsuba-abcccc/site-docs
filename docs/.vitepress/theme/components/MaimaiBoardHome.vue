<script setup>
import {
  ChevronRight,
  Hand,
  HeartHandshake,
  ListOrdered,
  Megaphone,
  MessageCircle,
  ReceiptText,
  ScrollText,
  Wrench
} from '@lucide/vue'

// 机厅营业期间的页面。停业后不再更新，仅保留入口供查阅。
const legacyPages = [
  {
    key: 'queue',
    title: '排队状态',
    description: '现场排队状态页，服务已暂停',
    href: '/queue-status',
    icon: ListOrdered,
    tone: 'blue'
  },
  {
    key: 'items',
    title: '共享物品',
    description: '手套、耳机与清洁用品存放信息',
    href: '/get-gloves',
    icon: Hand,
    tone: 'green'
  },
  {
    key: 'rules',
    title: '游玩规则',
    description: '游玩须知、排队规则与管理办法',
    href: '/maimai-rules',
    icon: ScrollText,
    tone: 'orange'
  },
  {
    key: 'crowdfunding',
    title: '维护众筹',
    description: '采购、维护安排与资金使用公示',
    href: '/crowdfunding',
    icon: Wrench,
    tone: 'purple'
  },
  {
    key: 'crowdfunding-old',
    title: '6 月众筹账单',
    description: '2026 年 6 月维护众筹的收款明细',
    href: '/crowdfunding-old',
    icon: ReceiptText,
    tone: 'teal'
  },
  {
    key: 'thanks',
    title: '特别鸣谢',
    description: '感谢参与维护、众筹与捐赠的玩家',
    href: '/maimai-thanks',
    icon: HeartHandshake,
    tone: 'pink'
  }
]
</script>

<template>
  <main class="maimai-home">
    <header class="maimai-home-header">
      <p>塘沽金街 · 舞萌 DX</p>
      <h1>金街舞萌公告板</h1>
      <span>王者之风游乐体验中心（塘沽金街店）已停止营业</span>
    </header>

    <section class="maimai-priority-notice" aria-labelledby="maimai-priority-notice-title">
      <a href="/maimai-closure-notice">
        <span class="maimai-notice-label">
          <Megaphone :size="16" :stroke-width="2" aria-hidden="true" />
          重要通知
        </span>
        <h2 id="maimai-priority-notice-title">关于金街王者之风已停止营业的后续安排</h2>
        <p>塘沽金街店已于 2026 年 9 月 1 日正式停止营业</p>
        <span class="maimai-notice-more">
          查看机台迁移、众筹物品与剩余款项安排
          <ChevronRight :size="18" :stroke-width="2" aria-hidden="true" />
        </span>
      </a>
    </section>

    <section class="maimai-service-section" aria-labelledby="maimai-legacy-title">
      <h2 id="maimai-legacy-title">旧页面</h2>
      <p class="maimai-service-note">以下是机厅营业期间的页面，停业后不再更新，内容可能已不适用。</p>
      <div class="maimai-service-list">
        <a
          v-for="page in legacyPages"
          :key="page.key"
          class="maimai-service-row"
          :href="page.href"
        >
          <span class="maimai-service-icon" :class="`is-${page.tone}`" aria-hidden="true">
            <component :is="page.icon" :size="22" :stroke-width="1.9" />
          </span>
          <span class="maimai-service-copy">
            <strong>{{ page.title }}<em class="maimai-legacy-tag">旧页面</em></strong>
            <small>{{ page.description }}</small>
          </span>
          <ChevronRight class="maimai-service-chevron" :size="20" :stroke-width="2" aria-hidden="true" />
        </a>
      </div>
    </section>

    <section class="maimai-contact-section" aria-labelledby="maimai-contact-title">
      <h2 id="maimai-contact-title">联系</h2>
      <div class="maimai-contact-list">
        <a href="https://qm.qq.com/q/gVCWbW1Mwa">
          <span class="maimai-contact-icon is-blue" aria-hidden="true"><MessageCircle :size="21" /></span>
          <span><strong>滨海新区 maimai 交流群</strong><small>QQ群 1036015350</small></span>
          <ChevronRight :size="19" aria-hidden="true" />
        </a>
        <a href="https://qm.qq.com/q/DEf6par5v2">
          <span class="maimai-contact-icon is-gray" aria-hidden="true"><Wrench :size="21" /></span>
          <span><strong>联系维护人员</strong><small>机厅、机况或页面问题</small></span>
          <ChevronRight :size="19" aria-hidden="true" />
        </a>
      </div>
    </section>

    <footer class="maimai-home-footer">机厅关闭后，相关服务将根据后续安排陆续停止 · 详见停业通知</footer>
  </main>
</template>
