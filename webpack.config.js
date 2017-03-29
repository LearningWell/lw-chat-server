const path = require('path');
const webpack = require('webpack');

const resolvePath = (pathToAdd) => {
  return path.resolve(__dirname, pathToAdd);
}

const outputPath = resolvePath('dist/');

module.exports = {
  entry: resolvePath('src/index.js'),
  output: { 
    path: outputPath,
    filename: 'app.js',
    publicPath: '/'
  },
  resolve: {
    modules: ['node_modules'],
    extensions: ['*', '.js', '.elm']
  },
  module: { 
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack-loader?pathToMake=node_modules/.bin/elm-make'
      }
    ],
    noParse: [/.elm$/]
  },
  plugins: []
};