const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const UglifyJSPlugin = require('uglifyjs-webpack-plugin');

module.exports = {
  devtool: 'source-map',
  stats: { children: false },
  entry: {
    app: ['css/app.css', 'js/app.js'],
    board: ['js/board/board.js']
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
        exclude: [/node_modules/, path.resolve(__dirname, '../deps/')],
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['es2015']
          }
        }
      }, {
        test: /\.vue$/,
        loader: 'vue-loader',
        options: {
          extractCSS: true,
          loaders: {
          },
          include: [
            path.resolve(__dirname, './node_modules/vuetify')
          ]
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
    }]),
    new webpack.optimize.ModuleConcatenationPlugin()
  ]
}

if (process.env.MIX_ENV === 'prod') {
  module.exports.devtool = '#source-map'
  module.exports.plugins = (module.exports.plugins || []).concat([
    new UglifyJSPlugin({
      sourceMap: true,
      compress: {
        warnings: false
      }
    })
  ])
}