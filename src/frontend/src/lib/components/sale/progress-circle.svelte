<script lang="ts">
    export let percentage: number;

    const radius = 36;
    const mobileRadius = 28;
    const circumference = radius * 2 * Math.PI;
    const mobileCircumference = mobileRadius * 2 * Math.PI;

    $: displayPercentage = Math.min(percentage, 100);
    $: offset = circumference - (displayPercentage / 100) * circumference;
    $: mobileOffset = mobileCircumference - (displayPercentage / 100) * mobileCircumference;
</script>

<div class="relative inline-flex">
    <svg class="w-24 h-24 md:w-32 md:h-32">
        <circle
            class="text-BrandGrayShade2 md:hidden"
            stroke-width="6"
            stroke="currentColor"
            fill="transparent"
            r={mobileRadius}
            cx="48"
            cy="48"
        />
        <circle
            class="hidden text-BrandGrayShade2 md:block"
            stroke-width="6"
            stroke="currentColor"
            fill="transparent"
            r={radius}
            cx="64"
            cy="64"
        />
        <circle
            class="transition-all duration-500 text-BrandBlue md:hidden"
            stroke-width="6"
            stroke-linecap="round"
            stroke="currentColor"
            fill="transparent"
            r={mobileRadius}
            cx="48"
            cy="48"
            style="stroke-dasharray: {mobileCircumference}; stroke-dashoffset: {mobileOffset};"
        />
        <circle
            class="hidden transition-all duration-500 text-BrandBlue md:block"
            stroke-width="6"
            stroke-linecap="round"
            stroke="currentColor"
            fill="transparent"
            r={radius}
            cx="64"
            cy="64"
            style="stroke-dasharray: {circumference}; stroke-dashoffset: {offset};"
        />
    </svg>
    <div class="absolute inset-0 flex items-center justify-center text-white">
        <span class="text-base md:text-xl cta-text">{displayPercentage.toFixed(0)}%</span>
    </div>
</div> 