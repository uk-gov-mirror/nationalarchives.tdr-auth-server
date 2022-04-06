const path = require("path")
const webpack = require('webpack');

module.exports = {
  entry: "./themes/tdr/login/src/index.ts",
  module: {
    rules: [
      {
        test: /\.ts?$/,
        use: "ts-loader",
        exclude: /node_modules/
      }
    ]
  },
  resolve: {
    extensions: [".ts", ".js"],
    fallback: {
      buffer: require.resolve('buffer/'),
    },
  },
  plugins: [
    new webpack.ProvidePlugin({
      Buffer: ['buffer', 'Buffer'],
    }),
  ],
  output: {
    filename: "webauthn.js",
    path: path.resolve(__dirname, "./themes/tdr/login/resources/js/")
  }
}
