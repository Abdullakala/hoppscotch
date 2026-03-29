<template>
  <aside class="flex h-full justify-between md:flex-col">
    <nav class="flex flex-1 flex-nowrap bg-primaryDark md:flex-none md:flex-col md:gap-1 md:p-1.5">
      <HoppSmartLink
        v-for="(navigation, index) in primaryNavigation"
        :key="`navigation-${index}`"
        v-tippy="{
          theme: 'tooltip',
          placement: mdAndLarger ? 'right' : 'bottom',
          content: !EXPAND_NAVIGATION ? t(navigation.title) : null,
        }"
        :to="navigation.target"
        class="nav-link"
        tabindex="0"
        :exact="navigation.exact"
      >
        <div v-if="navigation.svg">
          <component :is="navigation.svg" class="svg-icons" />
        </div>
        <span v-if="EXPAND_NAVIGATION" class="nav-title">
          {{ t(navigation.title) }}
        </span>
      </HoppSmartLink>
    </nav>
  </aside>
</template>

<script setup lang="ts">
import { breakpointsTailwind, useBreakpoints } from "@vueuse/core"
import IconLink2 from "~icons/lucide/link-2"
import IconGraphql from "~icons/hopp/graphql"
import IconGlobe from "~icons/lucide/globe"
import IconSettings from "~icons/lucide/settings"
import { useSetting } from "@composables/settings"
import { useI18n } from "@composables/i18n"

const t = useI18n()

const breakpoints = useBreakpoints(breakpointsTailwind)
const mdAndLarger = breakpoints.greater("md")

const EXPAND_NAVIGATION = useSetting("EXPAND_NAVIGATION")

const primaryNavigation = [
  {
    target: "/",
    svg: IconLink2,
    title: "navigation.rest",
    exact: true,
  },
  {
    target: "/graphql",
    svg: IconGraphql,
    title: "navigation.graphql",
    exact: false,
  },
  {
    target: "/realtime",
    svg: IconGlobe,
    title: "navigation.realtime",
    exact: false,
  },
  {
    target: "/settings",
    svg: IconSettings,
    title: "navigation.settings",
    exact: false,
  },
]
</script>

<style lang="scss" scoped>
.nav-link {
  @apply relative;
  @apply p-3;
  @apply flex flex-1 flex-col;
  @apply items-center;
  @apply justify-center;
  @apply text-secondary;
  @apply rounded-xl;
  @apply transition-all;
  @apply duration-200;
  @apply hover:bg-primary;
  @apply hover:text-secondaryDark;
  @apply focus-visible:text-secondaryDark;

  .svg-icons {
    @apply opacity-60;
    @apply transition-all;
    @apply duration-200;
  }

  .nav-title {
    @apply mt-1.5;
    @apply text-tiny;
    @apply font-medium;
  }

  &:hover .svg-icons {
    @apply opacity-100;
  }

  &.router-link-active {
    @apply text-accent;
    @apply bg-accent/10;
    @apply hover:text-accent;

    .svg-icons {
      @apply opacity-100;
    }
  }

  &.exact-active-link {
    @apply text-accent;
    @apply bg-accent/10;
    @apply hover:text-accent;

    .svg-icons {
      @apply opacity-100;
    }
  }
}

@media (max-width: 767px) {
  .nav-link {
    @apply p-3;
    @apply rounded-none;
    @apply bg-primaryDark;

    &.router-link-active,
    &.exact-active-link {
      @apply bg-primaryDark;
      @apply border-t-2;
      @apply border-accent;
    }
  }
}
</style>
