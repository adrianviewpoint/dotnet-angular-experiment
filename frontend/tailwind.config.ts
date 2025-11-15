// Tailwind CSS v4.1 note:
// https://tailwindcss.com/docs/upgrade-guide#using-a-javascript-config-file
// JavaScript config files are still supported for backward compatibility, but they are no longer detected automatically in v4.
// If you still need to use a JavaScript config file, you can load it explicitly using the @config directive:
//      @config "../../tailwind.config.js";

// The corePlugins, safelist, and separator options from the JavaScript-based config are not supported in v4.0. To safelist utilities in v4 use @source inline().

// This project uses the zero-config setup via the `@tailwindcss/postcss` plugin
// and `@import "tailwindcss";` in `src/app/globals.css`.
//
// A Tailwind config file isn't required. If you later need customization, you can convert this into a
// proper config and export the options accordingly.

// You can optionally add typing with:
// import type { Config } from 'tailwindcss';
// const config: Config = { /* ... */ };
// export default config;

const config = {};
export default config;