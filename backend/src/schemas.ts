import * as v from "valibot";

export const Location = v.object({
  coordinates: v.strictTuple([v.number(), v.number()]),
  address: v.optional(v.string()),
  placeName: v.optional(v.string()),
});

export const EntrySchema = v.object({
  body: v.string(),
  datetime: v.union([v.date(), v.pipe(v.string(), v.toDate())]),
  tags: v.array(v.string()),
  images: v.array(v.string()),
  location: v.nullish(Location),
});

export type Entry = v.InferOutput<typeof EntrySchema>;

export const EntryQuery = v.object({
  year: v.pipe(v.string(), v.toNumber(), v.integer()),
  month: v.pipe(
    v.string(),
    v.toNumber(),
    v.integer(),
    v.minValue(1),
    v.maxValue(12),
  ),
  day: v.pipe(
    v.string(),
    v.toNumber(),
    v.integer(),
    v.minValue(1),
    v.maxValue(31),
  ),
  hour: v.pipe(
    v.string(),
    v.toNumber(),
    v.integer(),
    v.minValue(0),
    v.maxValue(23),
  ),
  minute: v.pipe(
    v.string(),
    v.toNumber(),
    v.integer(),
    v.minValue(0),
    v.maxValue(59),
  ),
});
