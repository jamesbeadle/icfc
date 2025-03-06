<script lang="ts">
    export let isMenuOpen: boolean;
    let menuRef: HTMLDivElement;
    export let toggleMenu: () => void;

</script>
<div
class="{isMenuOpen ? 'translate-x-0' : 'translate-x-full'} fixed inset-y-0 right-0 z-40 w-full sm:w-80 
bg-white shadow-xl transform transition-transform duration-300 ease-in-out"
bind:this={menuRef}
>

<button
  on:click={toggleMenu}
  class="absolute top-4 right-4 p-2 text-gray-600 hover:text-gray-800"
>
  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
  </svg>
</button>

<nav class="pt-16 px-6 h-full text-lg bg-BrandBlue text-white cta-text">
  <ul class="space-y-4">
    <li><a class="hover:text-BrandInfo" href="/" on:click={toggleMenu}>Home</a></li>
    <li><a class="hover:text-BrandInfo" href="/apps" on:click={toggleMenu}>Apps</a></li>
    <li><a class="hover:text-BrandInfo" href="/profile" on:click={toggleMenu}>Profile</a></li>
    <li><a class="hover:text-BrandInfo" href="/membership" on:click={toggleMenu}>Membership</a></li>
    <li><a class="hover:text-BrandInfo" href="/podcasts" on:click={toggleMenu}>Podcasts</a></li>
    <li><a class="hover:text-BrandInfo" href="/shop" on:click={toggleMenu}>Shop</a></li>
    <li><a class="hover:text-BrandInfo" href="/whitepaper" on:click={toggleMenu}>Whitepaper</a></li>
    <li><a class="hover:text-BrandInfo" href="/sale" on:click={toggleMenu}>Decentralisation Sale 2</a></li>
  </ul>
</nav>
</div>