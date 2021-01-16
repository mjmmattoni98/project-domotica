module.exports = {
  env: {
    es6: true,
    node: true,
  },
  extends: [
    //    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
  ],
  plugins: [
    "@typescript-eslint",
    "import",
  ],
  rules: {
    quotes: ["off"],
    semi: ["off"],
    indent: ["off"],
    "comma-dangle": ["off"],
    "space-before-blocks": ["off"],
    "keyword-spacing": ["off"],
    "no-trailing-spaces": ["off"],
    "require-jsdoc": ["off"],
    "max-len": ["off"],
    "brace-style": ["off"],
    "quote-props": ["off"],
    "arrow-parens": ["off"],
  },
}
