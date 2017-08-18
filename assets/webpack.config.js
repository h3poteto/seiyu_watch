const path = require("path");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
module.exports = {
  entry: {
    "css/app.css": "./css/app.scss",
    "js/app.js": "./js/app.js"
  },
  output: {
    path: "../priv/static",
    filename: "[name]"
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel",
        query: {
          presets: ["babel-preset-es2016"]
        }
      },
      {
        test: /\.(scss|css)$/,
        loader: ExtractTextPlugin.extract("style-loader", "css-loader!sass-loader")
      },
      {
        test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/,
        loader: "url?limit=10000&mimetype=application/font-woff"
      },
      {
        test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        loader: "url?limit=10000&mimetype=application/octet-stream"
      },
      {
        test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
        loader: "file"
      },
      {
        test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
        loader: "url?limit=10000&mimetype=image/svg+xml"
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin("[name]"),
    new CopyWebpackPlugin([{ from: "./static" }])
  ],
  resolve: {
    extensions: ["", ".css", ".scss", ".js"],
    root: path.resolve(__dirname, "./")
  }
};

