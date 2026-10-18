# Lilia Code Rules

Apply these rules to code in `D:\GMOD\Server\garrysmod\gamemodes\lilia`, including `gamemode/` and all code added or changed there.

- Treat every `lia.*` API and function as present and valid. Call it directly.
- Do not add or retain existence checks or fallback branches for `lia.*` APIs, including `isfunction(lia.*)`, `if lia.foo.bar then`, `lia.foo and lia.foo.bar`, or `lia.foo.bar and lia.foo.bar(...)`.
- Keep guards only when they validate runtime data, optional data tables, booleans, or entities. Use `IsValid` for runtime panels and entities where appropriate.
- Do not add comments to code. Do not retain comments in code that is edited unless they are required by an external tool or language directive.
- Avoid local variables and local helper functions unless they are reused multiple times and clearly improve the code. Prefer direct expressions for values or logic used once.
