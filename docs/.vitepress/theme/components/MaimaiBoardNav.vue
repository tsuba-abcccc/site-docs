<script setup>
import { ChevronLeft } from '@lucide/vue'

defineProps({
  current: {
    type: String,
    default: ''
  },
  backOnly: {
    type: Boolean,
    default: false
  }
})

</script>

<template>
  <nav class="maimai-page-nav" aria-label="金街舞萌公告板导航">
    <a class="maimai-back" href="/maimai-board">
      <ChevronLeft :size="18" aria-hidden="true" />
      <span>公告板</span>
    </a>

  </nav>
</template>
