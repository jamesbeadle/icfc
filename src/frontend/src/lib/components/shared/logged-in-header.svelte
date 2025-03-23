<script lang="ts">

    import LogoIcon from "$lib/icons/LogoIcon.svelte";

    export let toggleMenu: () => void;

</script>

<header class="fixed top-0 left-0 right-0 z-30 flex items-center justify-between h-16 px-4 text-white bg-BrandBlue shadow-md">
  <a href="/" class="flex items-center">
    <LogoIcon className='w-8' />
  </a>

  <div class="flex items-center gap-4">
    <button
      on:click={toggleMenu}
      class="fixed z-50 p-2 text-white transition-colors bg-blue-600 rounded-md top-4 right-4 hover:bg-blue-700"
      aria-label="Toggle menu"
    >
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
      </svg>
    </button>
  </div>
</header>