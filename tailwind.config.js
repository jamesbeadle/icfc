/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{html,js,svelte,ts}"],
  safelist: [
    "hover:text-OpenWSLBackground",
    "hover:text-OpenFPLBackground",
    "hover:text-JeffBetsBackground",
    "hover:text-FootballGodBackground",
    "hover:text-TransferKingsBackground",
    "hover:text-BrandGrayShade6",
    "bg-OpenWSLBackground",
    "bg-OpenFPLBackground",
    "bg-JeffBetsBackground",
    "bg-FootballGodBackground",
    "bg-TransferKingsBackground",
    "bg-BrandGrayShade6",
  ],
  theme: {
    screens: {
      xxs: "420px",
      xs: "480px",
      mini: "580px",
      sm: "640px",
      // => @media (min-width: 640px) { ... }

      md: "768px",
      // => @media (min-width: 768px) { ... }

      base: "900px",
      // => @media (min-width: 960px) { ... }

      lg: "1024px",
      // => @media (min-width: 1024px) { ... }

      xl: "1280px",
      // => @media (min-width: 1280px) { ... }

      "2xl": "1536px",
      // => @media (min-width: 1536px) { ... }

      "3xl": "1728px",
      // => @media (min-width: 1728px) { ... }

      "4xl": "1920px",
      // => @media (min-width: 1920px) { ... }
    },
    fontSize: {
      xxs: ".625rem",
      xs: "0.7rem",
      sm: "0.8rem",
      base: "1rem",
      lg: "1.1rem",
      xl: "1.25rem",
      "2xl": "1.563rem",
      "3xl": "1.953rem",
      "4xl": "2.441rem",
      "5xl": "3.052rem",
    },
    extend: {
      colors: {
        BrandBlue: "#1979F2",
        BrandRed: "#F2194F",
        BrandGray: "#2F2F2F",
        BrandGrayShade1: "#484848",
        BrandGrayShade2: "#757575",
        BrandGrayShade3: "#8C8C8C",
        BrandGrayShade4: "#D1D1D1",
        BrandGrayShade5: "#E8E8E8",
        BrandGrayShade6: "#F9F9F9",
        BrandSuccess: "#66E094",
        BrandError: "#FF403C",
        BrandInfo: "#3CA1FF",
        FootballGodBackground: "#7F56F1",
        OpenFPLBackground: "#2CE3A6",
        TransferKingsBackground: "#2D64E3",
        OpenWSLBackground: "#F156D2",
        JeffBetsBackground: "#D7FE49",
        FootballGodFont: "#FFFFFF",
        OpenFPLFont: "#000000",
        TransferKingsFont: "#FFFFFF",
        OpenWSLFont: "#FFFFFF",
        JeffBetsFont: "#000000",
      },
      perspective: {
        500: "500px",
        1000: "1000px",
      },
    },
  },
  plugins: [],
};
