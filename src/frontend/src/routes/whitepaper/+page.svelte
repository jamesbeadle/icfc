<script lang="ts">
    
    import TitleSection from '$lib/components/whitepaper/title-section.svelte';
    import TextBlock from '$lib/components/whitepaper/text-block.svelte';
    import Callout from '$lib/components/whitepaper/callout.svelte';
    import ImageFigure from '$lib/components/whitepaper/image-figure.svelte';
    import Layout from '../Layout.svelte';
  
    import { writable } from 'svelte/store';
    const sectionsVisible = writable(false);
  
    import { onMount } from 'svelte';
    import { fadeFly } from '$lib/transitions/fade-fly';
    
    onMount(() => {
      sectionsVisible.set(true);
    });
  </script>
  
  <Layout>
    <div class="max-w-4xl mx-auto p-6 bg-fgbg rounded-lg shadow-xl">
      {#if $sectionsVisible}
        <div 
          in:fadeFly={{ delay: 200, duration: 800, x: -100 }}
          class="mb-8"
        >
          <TitleSection 
            title="ICFC Whitepaper" 
            subtitle="The Internet Computer Football Club" 
          />
        </div>
  
        <div 
          in:fadeFly={{ delay: 400, duration: 800, x: -100 }}
          class="my-6"
        >
          <TextBlock 
            heading="Introduction" 
            text="The team are busy putting together the final touches of our world football club."
          />
        </div>
  
        <div 
          in:fadeFly={{ delay: 600, duration: 800, x: -100 }}
          class="my-6"
        >
          <Callout 
            text="The full ICFC whitepaper will be released soon." 
            type="success" 
          />
        </div>
  
        <div 
          in:fadeFly={{ delay: 800, duration: 800, x: -100 }}
          class="my-8"
        >
          <ImageFigure 
            src="background.jpg" 
            alt="ICFC Whitepaper" 
            caption="Let the takeover begin."
          />
        </div>
  
      {/if}
    </div>
  </Layout>
  
  