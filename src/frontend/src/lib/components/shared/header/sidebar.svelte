<script lang="ts">
  import { signOut } from "$lib/services/auth.services";
  import { goto } from "$app/navigation";
  import type { MenuItem } from "$lib/types/menu";

  interface Props {
    isMenuOpen: boolean;
    toggleMenu: () => void;
    isSaleOnly: boolean;
  }
  let { isMenuOpen, toggleMenu, isSaleOnly }: Props = $props();
  
  let menuRef: HTMLDivElement;

  async function handleDisconnect(){
    await signOut();
    goto('/', { replaceState: true });
  }

  const menuItems: MenuItem[] = [
    { path: '/', label: 'Home', showForSaleOnly: true },
    { path: '/apps', label: 'Apps', showForSaleOnly: true },
    { path: '/sale', label: 'Membership Sale', showForSaleOnly: true },
    { path: '/sale-participation', label: 'Sale Participation', showForSaleOnly: true },
    { path: '/profile', label: 'Profile', showForSaleOnly: true },
    { path: '/membership', label: 'Membership', showForSaleOnly: true },
    { path: '/channels', label: 'Channels', showForSaleOnly: true },
    { path: '/shop', label: 'Shop', showForSaleOnly: false },
    { path: '/whitepaper', label: 'Whitepaper', showForSaleOnly: true },
    { path: '/tokens', label: 'Token Balances', showForSaleOnly: true },
    { path: '/', label: 'Sign Out', showForSaleOnly: true }
  ]

  let visibleItems = $derived(menuItems.filter(item => 
    item.showForSaleOnly === undefined || 
    (isSaleOnly ? item.showForSaleOnly : true) 
  ));
</script>
<div 
  class="{isMenuOpen ? 'translate-x-0' : 'translate-x-full'} fixed inset-y-0 right-0 z-40 w-full sm:w-80 bg-white shadow-xl transform transition-transform duration-300 ease-in-out"
  bind:this={menuRef}
>

  <button
    onclick={toggleMenu}
    class="absolute p-2 transition-all duration-200 text-BrandGrayShade4 top-4 right-4 hover:text-BrandBlue hover:scale-110"
    aria-label="Close sidebar"
  >
    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
    </svg>
  </button>

  <nav class="h-full px-6 pt-16 text-lg text-white bg-BrandBlueComp cta-text">
    <ul class="space-y-4">
      {#each visibleItems as item}
        <li>
          <a 
            href={item.path}
            onclick={(e) => {
              e.preventDefault();
              toggleMenu();
              if (item.label === 'Sign Out') {
                handleDisconnect();
              } else {
                goto(item.path);
              }
            }}
            class="hover:text-BrandBlue"
          >
            {item.label}
          </a>
        </li>
      {/each}
    </ul>
  </nav>
</div>