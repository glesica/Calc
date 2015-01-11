# Calc

A silly calculator API using Elixir and Phoenix.

## Run

1. Install dependencies: `mix deps.get`
2. Start the server: `mix phoenix.start`

Now you can visit `localhost:4000` from your browser.

## Use

Issue a `GET` request of the form `/calc/<value>/<operator>/<value>` to evaluate a
binary expression or `/calc/<operator>/<value>` to evaluate a unary expression. For
example, `/calc/5/mul/3` would evaluate `5 * 3`.

Assign a value to a symbol (slot) by issuing a `PUT` request to `/mem/<symbol>`
with a JSON payload of the form:

```json
{ "value": <value> }
```

The symbol can be any simple string, like "x" or "multiplier". This value can
then be retrieved using a `GET` request to `/mem/<symbol>`. Stored symbols can
also be used in any situation where a value is accepted.

Values can be numbers like `5.1` or `-17` or symbols. Available operators are
listed below.

### Binary operators

  * add - `x + y`
  * sub - `x - y`
  * mul - `x * y`
  * div - `x / y`
  * pow - `x ^ y`

### Unary operators

  * exp - `e ^ x`
  * neg - `-x`
