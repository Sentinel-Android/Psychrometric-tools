(() => {
  // src/shared/site.mjs
  if (location.protocol === "file:") {
    for (const link of document.querySelectorAll("a[href]")) {
      const target = new URL(link.href);
      if (target.protocol === "file:" && target.pathname.endsWith("/")) {
        target.pathname += "index.html";
        link.href = target.href;
      }
    }
  }
})();
