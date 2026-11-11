import { type Entry } from "../schemas.js";
import { getPathFromDt } from "../utils/path.js";
import matter from "gray-matter";
import fs from "node:fs/promises";
import path from "node:path";
import * as v from "valibot";
import { stringify } from "yaml";
import { addDt, entryDatetimes, updateCache } from "./cache.js";
import { write } from "node:fs";

const FrontMatterSchema = v.object({
  tags: v.nullish(v.array(v.string()), []),
  images: v.nullish(v.array(v.string()), []),
  location: v.optional(v.strictTuple([v.number(), v.number()])),
  place_name: v.optional(v.string()),
  address: v.optional(v.string()),
});

export async function readEntry(dt: Date): Promise<Entry | null> {
  const entryPath = getPathFromDt(dt);
  try {
    const rawContent = await fs.readFile(entryPath, "utf8");
    const { data: rawData, content } = matter(rawContent);

    const parsedFrontmatter = v.safeParse(FrontMatterSchema, rawData);
    let data: v.InferOutput<typeof FrontMatterSchema>;
    if (!parsedFrontmatter.success) {
      data = v.parse(FrontMatterSchema, {});
    } else {
      data = parsedFrontmatter.output;
    }

    return {
      body: content,
      datetime: dt,
      tags: data.tags,
      images: data.images,
      location: data.location
        ? {
            coordinates: data.location,
            address: data.address,
            placeName: data.place_name,
          }
        : undefined,
    };
  } catch (err) {
    if (err instanceof Error && "code" in err && err.code == "ENOENT") {
      return null;
    }
    console.error(`Unknown error occurred when reading ${entryPath}: ${err}`);
    return null;
  }
}

export enum PutEntryResponse {
  Created,
  Updated,
}

export async function writeEntry(entry: Entry): Promise<PutEntryResponse> {
  const entryPath = getPathFromDt(entry.datetime);
  const data: Record<string, any> = {
    tags: entry.tags,
    images: entry.images,
  };
  if (entry.location) {
    data["location"] = [
      entry.location.coordinates[0],
      entry.location.coordinates[1],
    ];
    if (entry.location.placeName) {
      data["place_name"] = entry.location.placeName;
    }
    if (entry.location.address) {
      data["address"] = entry.location.address;
    }
  }
  const yamlText = stringify(data);
  const content = `---\n${yamlText}---\n${entry.body}`;
  let fileExists = true;
  try {
    await fs.access(entryPath, fs.constants.F_OK);
  } catch {
    fileExists = false;
  }
  await fs.mkdir(path.dirname(entryPath), { recursive: true });
  await fs.writeFile(entryPath, content, "utf8");

  updateCache();

  return fileExists ? PutEntryResponse.Updated : PutEntryResponse.Created;
}

export async function getNewEntryDt(): Promise<Date> {
  let dt = new Date(Date.now());

  dt.setSeconds(0);
  dt.setMilliseconds(0);

  while (entryDatetimes.some((d) => d.getTime() == dt.getTime())) {
    dt.setMinutes(dt.getMinutes() + 1);
  }

  let emptyEntry: Entry = { body: "", datetime: dt, tags: [], images: [] };
  await writeEntry(emptyEntry);
  return dt;
}
