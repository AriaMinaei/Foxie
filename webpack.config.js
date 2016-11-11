module.exports = {
  entry: './src/Foxie.coffee',
  output: {
    filename: './build/Foxie.js',
    library: './build/Foxie.js',
    libraryTarget: 'umd'
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee" }
    ]
  },
  resolve: {
    extensions: ["", ".web.coffee", ".web.js", ".coffee", ".js"]
  }
}