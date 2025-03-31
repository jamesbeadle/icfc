<script lang="ts">
  import { signOut } from "$lib/services/auth.services";
  import { goto } from "$app/navigation";
  
  export let isMenuOpen: boolean;
  export let toggleMenu: () => void;
  
  let menuRef: HTMLDivElement;

  async function handleDisconnect(){
    await signOut();
    goto('/', { replaceState: true });
  }

</script>
<div 
  class="{isMenuOpen ? 'translate-x-0' : 'translate-x-full'} fixed inset-y-0 right-0 z-40 w-full sm:w-80 bg-white shadow-xl transform transition-transform duration-300 ease-in-out"
  bind:this={menuRef}
>

  <button
    on:click={toggleMenu}
    class="absolute p-2 text-BrandGrayShade4 top-4 right-4 hover:text-BrandGrayShade5"
    aria-label="Close sidebar"
  >
    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
    </svg>
  </button>

  <nav class="h-full px-6 pt-16 text-lg text-white bg-BrandBlueComp cta-text">
    <ul class="space-y-4">
      <li><a class="hover:text-BrandBlue" href="/" on:click={toggleMenu}>Home</a></li>
      <li><a class="hover:text-BrandBlue" href="/apps" on:click={toggleMenu}>Apps</a></li>
      <li><a class="hover:text-BrandBlue" href="/profile" on:click={toggleMenu}>Profile</a></li>
      <li><a class="hover:text-BrandBlue" href="/membership" on:click={toggleMenu}>Membership</a></li>
      <li><a class="hover:text-BrandBlue" href="/channels" on:click={toggleMenu}>Channels</a></li>
      <li><a class="hover:text-BrandBlue" href="/shop" on:click={toggleMenu}>Shop</a></li>
      <li><a class="hover:text-BrandBlue" href="/whitepaper" on:click={toggleMenu}>Whitepaper</a></li>
      <li><a class="hover:text-BrandBlue" href="/sale" on:click={toggleMenu}>Decentralisation Sale 2</a></li>
      <li><a class="hover:text-BrandBlue" href="/tokens" on:click={toggleMenu}>Token Balances</a></li>
      <li><a class="hover:text-BrandBlue" href="/" on:click={handleDisconnect}>Sign Out</a></li>
    </ul>
  </nav>
</div>