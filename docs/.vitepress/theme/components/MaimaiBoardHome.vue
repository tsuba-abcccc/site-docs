<script setup>
import {
  ChevronRight,
  Megaphone,
  MessageCircle,
  Wrench
} from '@lucide/vue'
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
