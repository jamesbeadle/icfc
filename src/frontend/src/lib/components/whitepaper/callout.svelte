<script lang="ts">
    import { bounce } from "$lib/transitions/bounce";

    export let text: string;
    export let type: 'info' | 'warning' | 'success' = 'info';
    
    const styles = {
      info: 'bg-BrandInfo/10 border-BrandInfo text-BrandInfo',
      warning: 'bg-BrandError/10 border-BrandError text-BrandError',
      success: 'bg-BrandSuccess/10 border-BrandSuccess text-BrandSuccess',
    };
  </script>
  
  <div 
    class={`p-4 border-l-4 ${styles[type]} rounded-md shadow-md my-6`}
    in:bounce={{ delay: 400, duration: 800 }}
  >
    <p class="text-base font-medium">
      {text}
    </p>
  </div>