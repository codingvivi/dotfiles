// Scrolling
glide.keymaps.set("normal", "j", "scroll_half_page_down");
glide.keymaps.set("normal", "k", "scroll_half_page_up");

glide.keymaps.del("normal", "G");
glide.keymaps.set("normal", "ge", "scroll_bottom");

// Tab navigation
glide.keymaps.set("normal", "h", "tab_prev");
glide.keymaps.set("normal", "l", "tab_next");

// History navigation
glide.keymaps.set("normal", "H", "back");
glide.keymaps.set("normal", "L", "forward");

glide.keymaps.del("normal", "<leader>d");
glide.keymaps.set("normal", "d", "tab_close");


glide.keymaps.set("normal", "o", "tab_new");

glide.keymaps.del("normal", "<leader>r");
glide.keymaps.set("normal", "r", "reload");

glide.keymaps.set("normal", "<leader>hr", "config_reload");

// Relocate default <leader>f (browser-ui hint) onto <leader>fb
glide.keymaps.del("normal", "<leader>f");
glide.keymaps.set("normal", "<leader>fb", () => {
  glide.hints.show({ location: "browser-ui" });
}, { description: "hint [b]rowser UI" });

// <leader>fv — hint a link and open it with mpv
// Glide runs in the browser sandbox, so we can't spawn directly:
// copy the href to clipboard, then `mpv "$(wl-paste)"` from a shell.
glide.keymaps.set("normal", "<leader>fv", () => {
  glide.hints.show({
    async action({ content }) {
      const href = await content.execute(
        (t) => (t as HTMLAnchorElement).href ?? ""
      );
      await navigator.clipboard.writeText(href);
    },
  });
}, { description: "hint link → clipboard for mpv" });
