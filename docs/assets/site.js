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

// Load Google AdSense once on public content pages.
(() => {
  if (typeof location === 'undefined' || location.protocol !== 'https:') return;

  // Keep privacy and error pages free of advertising.
  if (/(?:^|\/)(?:privacy|404)(?:\.html|\/|$)/i.test(location.pathname)) {
    return;
  }

  if (document.querySelector(
    'script[src*="pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"]'
  )) {
    return;
  }

  const script = document.createElement('script');
  script.async = true;
  script.crossOrigin = 'anonymous';
  script.src =
    'https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js' +
    '?client=ca-pub-6483738937839008';

  document.head.appendChild(script);
})();
