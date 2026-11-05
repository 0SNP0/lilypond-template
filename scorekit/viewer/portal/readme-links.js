"use strict";
/** Resolve links inside a release README, rendered under /viewer/.
 * Local source references must point to the release's GitHub tree, not Pages.
 */
function readmeLinkTarget(href, repository, tag) {
  if (typeof href !== "string") return null;
  const raw = href.trim();
  if (!raw) return null;
  if (raw.startsWith("#")) return raw;
  if (/^(?:https?:|mailto:)/i.test(raw)) {
    try {
      const absolute = new URL(raw);
      return ["http:", "https:", "mailto:"].includes(absolute.protocol) ? absolute.href : null;
    } catch (_error) { return null; }
  }
  if (/^[a-z][a-z\d+.-]*:/i.test(raw) || raw.startsWith("/") ||
      raw.includes("\\") || raw.startsWith("?") ||
      !/^[A-Za-z\d_.-]+\/[A-Za-z\d_.-]+$/.test(repository || "") ||
      !/^[A-Za-z\d_.+/-]+$/.test(tag || "")) return null;
  const plain = raw.split(/[?#]/, 1)[0];
  if (!plain) return null;
  // Reject traversal BEFORE URL normalization, including encoded dots and
  // slashes. URL() would otherwise erase a %2e%2e segment silently.
  let originalSegments;
  try {
    originalSegments = plain.split("/").filter(Boolean).map(decodeURIComponent);
  } catch (_error) { return null; }
  if (originalSegments.some(part => part === "." || part === ".." ||
      part.includes("/") || part.includes("\\\\"))) return null;
  try {
    const parsed = new URL(raw, "https://scorekit.invalid/");
    if (parsed.origin !== "https://scorekit.invalid") return null;
    const segments = parsed.pathname.split("/").filter(Boolean).map(decodeURIComponent);
    if (!segments.length || segments.some(p => p === "." || p === ".." || p.includes("/")))
      return null;
    const path = segments.map(encodeURIComponent).join("/");
    const kind = plain.endsWith("/") ? "tree" : "blob";
    return "https://github.com/" + repository + "/" + kind + "/" +
      encodeURIComponent(tag) + "/" + path + parsed.hash;
  } catch (_error) { return null; }
}
if (typeof module !== "undefined" && module.exports)
  module.exports = { readmeLinkTarget };
