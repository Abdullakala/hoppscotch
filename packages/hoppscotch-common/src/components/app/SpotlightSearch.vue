<template>
  <button
    class="relative flex flex-1 cursor-text items-center justify-between self-stretch rounded-xl bg-primary/50 border border-divider px-3 py-1.5 text-secondaryLight transition-all duration-200 hover:border-accent/30 hover:bg-primary hover:text-secondary focus-visible:border-accent/30 focus-visible:bg-primary focus-visible:text-secondary overflow-hidden backdrop-blur-sm"
    @click="invokeAction('modals.search.toggle', undefined, 'mouseclick')"
  >
    <span class="inline-flex flex-1 items-center">
      <icon-lucide-search class="svg-icons mr-2 opacity-50" />

      {{ t("app.search") }}
    </span>
    <span class="flex space-x-1">
      <kbd class="shortcut-key !border-divider !bg-primaryDark/50">{{ getPlatformSpecialKey() }}</kbd>
      <kbd class="shortcut-key !border-divider !bg-primaryDark/50">K</kbd>
    </span>
  </button>
</template>

<script lang="ts" setup>
import { useI18n } from "~/composables/i18n"
import { invokeAction } from "~/helpers/actions"
import { getPlatformSpecialKey } from "~/helpers/platformutils"

const t = useI18n()
</script>
