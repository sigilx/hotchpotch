const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
// const UglifyJSPlugin = require('uglifyjs-webpack-plugin');

module.exports = {
  devtool: 'source-map',
  entry: {
    app: ['css/app.css', 'js/app.js'],
    board: 'js/board/board.js',
  },
  output: {
    path: path.resolve(__dirname, '../priv/static'),
    filename: 'js/[name].js'
  },
  resolve: {
    modules: ['node_modules', __dirname],
    alias: {
      'vue$': 'vue/dist/vue.esm.js',
      'phoenix': path.resolve(__dirname, '../deps/phoenix/priv/static/phoenix.js'),
      'phoenix_html': path.resolve(__dirname, '../deps/phoenix_html/priv/static/phoenix_html.js')
    },
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
        loader: 'babel-loader',
        exclude: /node_modules/,
      }, {
        test: /\.vue$/,
        loader: 'vue-loader',
        options: {
          extractCSS: true,
        }
      }, {
        test: /\.(png|jpg|gif)$/,
        exclude: /node_modules/,
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
    new ExtractTextPlugin('css/[name].css'),
    new CopyWebpackPlugin([{
      from: 'static'
    }])
  ]
}

if (process.env.NODE_ENV === 'production') {
  module.exports.devtool = '#source-map'
  // http://vue-loader.vuejs.org/en/workflow/production.html
  module.exports.plugins = (module.exports.plugins || []).concat([
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    }),
    new UglifyJSPlugin({
      sourceMap: true,
      compress: {
        warnings: false
      }
    })
  ])
}