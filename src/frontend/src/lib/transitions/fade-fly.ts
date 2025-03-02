// src/lib/transitions/fadeFly.ts
import { cubicOut } from "svelte/easing";

export function fadeFly(
  node: HTMLElement,
  { delay = 0, duration = 400, x = 0 },
) {
  return {
    delay,
    duration,
    css: (t: number) => {
      const eased = cubicOut(t);
      return `
        opacity: ${t};
        transform: translateX(${x * (1 - eased)}px);
      `;
    },
  };
}
