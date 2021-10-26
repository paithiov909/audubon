const path = require('path');

module.exports = {
  target: 'web',
  entry: './srcjs/index.js',
  output: {
    library: 'audubon',
    filename: 'audubon.bundle.js',
    path: path.resolve(__dirname, 'inst/packer'),
    libraryExport: "default",
    libraryTarget: 'var'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        use: [
          {
            loader: "babel-loader",
            options: {
              presets: ["@babel/preset-env"]
            }
          }
        ]
      }
    ]
  },
  target: ['web', 'es5'],
  resolve: {
    mainFields: ['main']
  }
};
