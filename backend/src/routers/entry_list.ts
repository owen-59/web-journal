import { Hono } from "hono";
import { describeRoute, resolver } from "hono-openapi";
import * as v from "valibot";
import { entryDatetimes } from "../repository/cache.js";

const app = new Hono();

app.get(
  "/",
  describeRoute({
    description: "Get a list of the datetimes of all entries.",
    responses: {
      200: {
        description: "Success",
        content: {
          "application/json": { schema: resolver(v.array(v.date())) },
        },
      },
    },
  }),
  async (c) => {
    return c.json(entryDatetimes, 200);
  },
);

export default app;
