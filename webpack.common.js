const path = require('path');

module.exports = {
  target: 'node',
  entry: './srcjs/index.js',
  output: {
    filename: 'audubon.bundle.js',
    path: path.resolve(__dirname, 'inst/packer'),
    library: {
      name: 'audubon',
      type: 'window',
      export: 'default'
    },
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
