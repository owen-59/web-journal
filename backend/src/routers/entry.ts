import { Hono } from "hono";
import { describeRoute, resolver, validator } from "hono-openapi";
import { EntryQuery, EntrySchema } from "../schemas.js";
import {
  getNewEntryDt,
  PutEntryResponse,
  readEntry,
  writeEntry,
} from "../repository/entry.js";
import * as v from "valibot";

type Env = {
  Variables: {
    dt: Date;
  };
};

const app = new Hono<Env>();

app.get(
  "/:year/:month/:day/:hour/:minute",
  describeRoute({
    description: "Get entry at some datetime",
    responses: {
      200: {
        description: "Success",
        content: {
          "application/json": { schema: resolver(EntrySchema) },
        },
      },
      404: {
        description: "Entry not found.",
      },
    },
  }),
  validator("param", EntryQuery),
  async (c, next) => {
    c.set(
      "dt",
      new Date(
        c.req.valid("param").year,
        c.req.valid("param").month - 1,
        c.req.valid("param").day,
        c.req.valid("param").hour,
        c.req.valid("param").minute,
      ),
    );
    await next();
  },
  async (c) => {
    const entry = await readEntry(c.get("dt"));
    if (entry) {
      return c.json(entry, 200);
    }
    return c.body(null, 404);
  },
);

app.put(
  "/:year/:month/:day/:hour/:minute",
  describeRoute({
    description: "Put an entry at some datetime",
    responses: {
      201: {
        description: "Created",
      },
      204: {
        description: "Modification successful",
      },
    },
  }),
  validator("param", EntryQuery),
  validator("json", EntrySchema),
  async (c, next) => {
    c.set(
      "dt",
      new Date(
        c.req.valid("param").year,
        c.req.valid("param").month - 1,
        c.req.valid("param").day,
        c.req.valid("param").hour,
        c.req.valid("param").minute,
      ),
    );
    await next();
  },
  async (c) => {
    const putEntryResponseCode = await writeEntry(c.req.valid("json"));
    return c.body(
      null,
      putEntryResponseCode == PutEntryResponse.Created ? 201 : 204,
    );
  },
);

app.post(
  "/new",
  describeRoute({
    description: "Create a new entry.",
    responses: {
      201: {
        description: "Created the entry.",
        content: {
          "application/json": { schema: resolver(v.date()) },
        },
      },
    },
  }),
  async (c) => {
    const dt = await getNewEntryDt();
    return c.json(dt, 201);
  },
);

export default app;
