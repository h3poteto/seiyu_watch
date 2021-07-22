const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
module.exports = {
  entry: {
    "css/app.css": "./css/app.scss",
    "js/app.js": "./js/app.js",
  },
  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: "[name]",
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: ["babel-loader"],
      },
      {
        test: /\.(scss|css)$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: "css-loader",
            options: {
              esModule: false,
            },
          },
          "sass-loader",
        ],
      },
      {
        test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/,
        use: "url-loader?limit=10000&mimetype=application/font-woff",
      },
      {
        test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        use: "url-loader?limit=10000&mimetype=application/octet-stream",
      },
      {
        test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
        use: "file-loader",
      },
      {
        test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
        use: "url-loader?limit=10000&mimetype=image/svg+xml",
      },
      {
        test: /\.(jpg|jpeg|png)$/,
        use: "url-loader",
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: "css/style.css" }),
    new CopyWebpackPlugin({
      patterns: [
        {
          from: path.join(__dirname, "./static"),
          to: path.join(__dirname, "../priv/static"),
        },
      ],
    }),
  ],
  resolve: {
    extensions: ["", ".css", ".scss", ".js"],
    roots: [path.resolve(__dirname, "./"), path.resolve(__dirname, "./static")],
  },
};
