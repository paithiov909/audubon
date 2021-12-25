const japanese = require("japanese");
const budoux = require("budoux");

const parser = budoux.loadDefaultJapaneseParser();

const audubon = {
  japanese: japanese,
  parser: parser,
};

export default audubon;
