import fs from "node:fs/promises";
import path from "node:path";
import config from "../config.js";

let entryDatetimes: Date[] = [];

async function updateCache() {
  entryDatetimes = [];
  const yearDirs = (await fs.readdir(config.JOURNAL_DATA))
    .filter((file) => !Number.isNaN(Number(file)))
    .sort((a, b) => Number(b) - Number(a));

  for (const year of yearDirs) {
    const monthDirs = (await fs.readdir(path.join(config.JOURNAL_DATA, year)))
      .filter(
        (file) =>
          !Number.isNaN(Number(file)) && Number(file) > 0 && Number(file) <= 12,
      )
      .sort((a, b) => Number(b) - Number(a));

    for (const month of monthDirs) {
      const dayDirs = (
        await fs.readdir(path.join(config.JOURNAL_DATA, year, month))
      )
        .filter(
          (file) =>
            !Number.isNaN(Number(file)) &&
            Number(file) > 0 &&
            Number(file) <= 31,
        )
        .sort((a, b) => Number(b) - Number(a));
      for (const day of dayDirs) {
        const files = (
          await fs.readdir(path.join(config.JOURNAL_DATA, year, month, day))
        ).sort();
        for (const fileName of files) {
          if (fileName.length != 7) continue;
          const hourString = fileName.slice(0, 2);
          const minuteString = fileName.slice(2, 4);
          const hour = Number(hourString);
          const minute = Number(minuteString);
          if (Number.isNaN(hour) || Number.isNaN(minute)) continue;
          const datetime = new Date(
            Date.UTC(
              Number(year),
              Number(month) - 1,
              Number(day),
              hour,
              minute,
            ),
          );
          entryDatetimes.push(datetime);
        }
      }
    }
  }
  entryDatetimes = entryDatetimes.sort((a, b) => b.getTime() - a.getTime());
}

await updateCache();

entryDatetimes = entryDatetimes.sort((a, b) => b.getTime() - a.getTime());

function addDt(dt: Date) {
  if (!entryDatetimes.some((d) => d == dt)) {
    entryDatetimes.push(dt);
  }
  entryDatetimes = entryDatetimes.sort((a, b) => b.getTime() - a.getTime());
}

export { entryDatetimes, addDt, updateCache };
