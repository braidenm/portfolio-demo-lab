import {readFile} from "node:fs/promises";

const catalog = JSON.parse(await readFile(new URL("../catalog/apps.json", import.meta.url), "utf8"));
const allowedStatuses = new Set(["available", "source-recovery-required"]);
const seen = new Set();

if (catalog.schemaVersion !== 1 || typeof catalog.comparisonMessage !== "string" || !catalog.comparisonMessage.includes("progression")) {
  throw new Error("Catalog must declare schema version 1 and explicit progression framing.");
}

for (const app of catalog.apps) {
  if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(app.id) || seen.has(app.id)) {
    throw new Error(`Invalid or duplicate app id: ${app.id}`);
  }
  seen.add(app.id);
  if (!allowedStatuses.has(app.status)) throw new Error(`Unsupported status for ${app.id}`);
  if (!app.sourceUrl.startsWith("https://github.com/braidenm/")) throw new Error(`Unexpected source URL for ${app.id}`);
  if (app.status === "available" && !app.embedUrl?.startsWith("https://")) {
    throw new Error(`Available app ${app.id} requires an HTTPS embed URL.`);
  }
  if (app.status !== "available" && app.embedUrl !== null) {
    throw new Error(`Unavailable app ${app.id} must not publish an embed URL.`);
  }
}

console.log(`Verified ${seen.size} progression demo catalog entries.`);

