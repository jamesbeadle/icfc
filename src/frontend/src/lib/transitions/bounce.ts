// src/lib/transitions/bounce.ts
import { cubicOut } from "svelte/easing";

export function bounce(node: HTMLElement, { delay = 0, duration = 400 }) {
  const style = getComputedStyle(node);
  const transform = style.transform === "none" ? "" : style.transform;

  return {
    delay,
    duration,
    css: (t: number) => {
      const eased = cubicOut(t);
      let y = 0;

      if (t < 0.4) {
        y = t * 2.5 * (1 - eased); // Initial drop
      } else if (t < 0.6) {
        y = 1 - (t - 0.4) * 2.5 * eased; // Bounce up
      } else {
        y = (t - 0.6) * 1.5 * eased; // Settle down
      }

      return `
        transform: ${transform} translateY(${y * 20}px);
        opacity: ${t};
      `;
    },
  };
}
