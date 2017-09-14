const path = require("path");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require('copy-webpack-plugin');
// const UglifyJSPlugin = require('uglifyjs-webpack-plugin');

module.exports = {
  devtool: 'source-map',
  entry: {
    app: ['css/app.css', 'js/app.js'],
    board: 'js/board/board.js',
  },
  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: 'js/[name].js'
  },
  resolve: {
    modules: ["node_modules", __dirname,
      path.resolve(__dirname, "../deps/phoenix"),
      path.resolve(__dirname, "../deps/phoenix_html")
    ],
    extensions: ['.js', '.vue']
  },
  module: {
    rules: [{
        test: /\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: 'css-loader'
        })
      }, {
        test: /\.js$/,
        loader: 'babel-loader'
      }, {
        test: /\.vue$/,
        loader: 'vue-loader',
        options: {
          extractCSS: true,
        }
      }, {
        test: /\.(png|jpg|gif)$/,
        use: [{
          loader: 'url-loader',
          options: {
            limit: 8192
          }
        }]
      },
    ]
  },
  plugins: [
    new ExtractTextPlugin("css/[name].css"),
    new CopyWebpackPlugin([{
      from: "static"
    }]),
    // new UglifyJSPlugin({
    //   parallel: true
    // })
  ]
}