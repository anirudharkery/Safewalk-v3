const globals = require("globals");

module.exports = [
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: 2018,
      sourceType: "commonjs",
      globals: {
        ...globals.node,
      },
    },
    rules: {
      "quotes": ["error", "double"],
      "max-len": ["error", { "code": 120 }],
      "require-jsdoc": "off",
      "indent": ["error", 2],
      "semi": ["error", "always"],
      "no-unused-vars": "warn",
      "camelcase": "error",
    },
  },
];
