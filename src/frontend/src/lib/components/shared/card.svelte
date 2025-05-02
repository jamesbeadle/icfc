<script lang="ts">

    interface Props {
        isFlipped: boolean;
        onFlip: (id: string, e: MouseEvent | KeyboardEvent) => void;
        id: string;
        isModal: boolean;
        disableFlip: boolean;
        frontClasses: string;
        backClasses: string;
    }
  
    let { isFlipped, onFlip, id, isModal, disableFlip, frontClasses, backClasses  } : Props = $props();
    
</script>

<div 
    class={`relative w-full group perspective transition-transform duration-300 aspect-[1/1.54] min-h-[400px] min-w-[260px] xs:min-h-[320px] xs:min-w-[208px] mini:min-h-[400px] mini:min-w-[260px] ${
        isModal ? '' : 'hover:scale-[1.02] cursor-pointer'
    }`}
    on:click={(e) => {
        if (!disableFlip && !(e.target as HTMLElement).closest('a')) {
            onFlip(id, e);
        }
    }}
    on:keydown={(e) => e.key === 'Enter' && onFlip(id, e)}
    tabindex="0"
    role="button"
>
    <div class={`relative w-full h-full transition-all duration-500 transform-style-3d ${isFlipped ? 'rotate-y-180' : ''}`}>
        <div class={`absolute w-full h-full min-h-[400px] min-w-[260px] p-8 text-left rounded-2xl backface-hidden transform transition-all duration-200 overflow-hidden flex flex-col ${frontClasses} ${
            isModal ? '' : 'hover:-translate-y-1 hover:shadow-xl'
        }`}>
            <slot name="front" />
        </div>

        <div class={`absolute w-full h-full min-h-[400px] min-w-[260px] p-8 text-left rounded-2xl backface-hidden rotate-y-180 flex flex-col ${backClasses}`}>
            <slot name="back" />
        </div>
    </div>
</div>

<style>
    .perspective {
        perspective: 1000px;
    }
    
    .transform-style-3d {
        transform-style: preserve-3d;
    }
    
    .backface-hidden {
        backface-visibility: hidden;
    }
    
    .rotate-y-180 {
        transform: rotateY(180deg);
    }
</style> 