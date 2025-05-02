<script lang="ts">
    import { onMount, onDestroy } from "svelte";
    import { activeDropdownId } from "$lib/stores/dropdown-store";
    import CheckmarkIcon from "$lib/icons/CheckmarkIcon.svelte";
    import ArrowUpIcon from "$lib/icons/ArrowUpIcon.svelte";
    import ArrowDownIcon from "$lib/icons/ArrowDownIcon.svelte";
    import SearchIcon from "$lib/icons/SearchIcon.svelte";

    interface Props {
        value: any;
        options: Array<{ id: number | string | bigint; label: string }>;
        placeholder: string;
        compact: boolean;
        onChange: ((value: any) => void) | undefined;
        allOptionText: string | undefined;
        scrollOnOpen: boolean;
        searchOn: boolean;
        disabled: boolean;
    }

    let { value, options, placeholder, compact, onChange, allOptionText, scrollOnOpen, searchOn, disabled  } : Props = $props();

    const dropdownId = Math.random().toString(36).substring(7);
    let isDropdownOpen = false;
    let dropdownElement: HTMLDivElement;
    let searchTerm = '';

    activeDropdownId.subscribe((id) => {
        if (id !== dropdownId) {
            isDropdownOpen = false;
        }
    });

    let allOptions = allOptionText 
        ? [{ id: BigInt(0), label: `All ${allOptionText}` }, ...options]
        : options;
    let selectedOption = allOptions.find(opt => opt.id === value);
    let filteredOptions = searchOn 
        ? allOptions.filter(opt => 
            opt.label.toLowerCase().includes(searchTerm.toLowerCase())
          )
        : allOptions;

    function toggleDropdown(e: MouseEvent) {
        e.stopPropagation();
        isDropdownOpen = !isDropdownOpen;
        if (isDropdownOpen) {
            activeDropdownId.set(dropdownId);
        } else {
            activeDropdownId.set(null);
        }
        if (scrollOnOpen && isDropdownOpen) {
            setTimeout(() => {
                dropdownElement?.scrollIntoView({ 
                    behavior: 'smooth',
                    block: 'center'
                });
            }, 50);
        }
    }

    function selectOption(optionId: any, e: MouseEvent) {
        e.stopPropagation();
        if (onChange) {
            onChange(optionId);
        } else {
            value = optionId;
        }
        isDropdownOpen = false;
    }

    function handleClickOutside(event: MouseEvent) {
        if (dropdownElement && !dropdownElement.contains(event.target as Node)) {
            isDropdownOpen = false;
        }
    }

    function clickOutside(node: HTMLElement, callback: () => void) {
        const handleClick = (event: MouseEvent) => {
            if (node && !node.contains(event.target as Node)) {
                callback();
            }
        };
        
        document.addEventListener('click', handleClick, true);
        
        return {
            destroy() {
                document.removeEventListener('click', handleClick, true);
            }
        };
    }

    onMount(() => {
        if (typeof window !== 'undefined') {
            document.addEventListener('click', handleClickOutside);
        }
    });

    onDestroy(() => {
        if (typeof window !== 'undefined') {
            document.removeEventListener('click', handleClickOutside);
        }
    });
</script>

<div class="relative w-full" bind:this={dropdownElement} use:clickOutside={() => isDropdownOpen = false}>
    <button
        {disabled}
        class="flex items-center justify-between w-full rounded-lg border border-BrandGrayShade3 hover:border-BrandBlueComp  focus:border-BrandBlueComp focus:ring-1 focus:ring-BrandBlueComp/30 {compact ? ' bg-BrandGray/5  hover:bg-BrandGray/10' : 'px-2 py-3 bg-BrandBlack hover:bg-BrandBlack/50'}"
        on:click={e => toggleDropdown(e)}
    >
        <span class="truncate {!selectedOption ? 'text-BrandGrayShade2' : 'text-BrandDarkGray'}">
            {selectedOption?.label ?? placeholder}
        </span>
        <span class="w-4 h-4">
            {#if isDropdownOpen}
                <ArrowUpIcon fill="white" />
            {:else}
                <ArrowDownIcon fill="white" />
            {/if}
        </span>
    </button>
    
    {#if isDropdownOpen}
        <ul 
            class="absolute z-50 py-1 mt-1 rounded-lg overflow-hidden shadow-lg w-[calc(100%-2rem)] max-h-[240px] overflow-y-auto scrollbar-thin border border-BrandGrayShade3"
            role="listbox"
            tabindex="-1"
        >
            {#if searchOn}
                <div class="sticky top-0 z-[100] p-3 bg-BrandBlack border-b border-BrandGrayShade3">
                    <div class="relative flex items-center justify-between px-3 py-2 space-x-2 border rounded border-BrandGrayShade3">
                        <SearchIcon className="w-4 h-4" fill="white" />
                        <input
                            type="text"
                            bind:value={searchTerm}
                            placeholder="Search..."
                            class="w-full text-white outline-none bg-BrandBlack placeholder:text-BrandGrayShade2"
                        />
                       
                    </div>
                </div>
            {/if}
            
            <div class={searchOn ? "pt-1" : ""}>
                {#each filteredOptions as option, index (option.id)}
                    <li>
                        <button
                            {disabled}
                            class={`w-full px-4 py-2 text-left transition-colors duration-150 flex items-center justify-between ${value === option.id ? "text-white bg-BrandBlueComp/50" : "text-BrandGrayShade2 hover:text-white bg-BrandBlack hover:bg-BrandBlueComp"}`}
                            on:click={e => selectOption(option.id, e)}
                        >
                            <span class="truncate">{option.label}</span>
                            {#if value === option.id}
                                <CheckmarkIcon className="w-4 h-4" />
                            {/if}
                        </button>
                    </li>
                {/each}
            </div>
        </ul>
    {/if}
</div> 
