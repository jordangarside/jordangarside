var path = require("path");

var babelSettings = {
    presets: ['es2015']
}

module.exports = {
    production: true,
    entry: {
        app: ["./app/client/index.coffee"]
    },
    output: {
        path: path.resolve(__dirname, "public"),
        publicPath: "/public/",
        filename: "bundle.js"
    },
    devtool: "source-map", // or "inline-source-map"
    module: {
        loaders: [{
            test: /node_modules/,
            loader: 'ify',
        }, {
            test: /\.handlebars$/,
            loader: "handlebars-loader"
        }, {
            test: /\.sass$/,
            loaders: ["style", "css?sourceMap", "sass?sourceMap"]
        }, {
            test: /\.jpe?g$|\.gif$|\.png$|\.svg$|\.woff$|\.ttf$/,
            loader: "file"
        }, {
            test: /\.js$/,
            exclude: /(node_modules|bower_components)/,
            loader: 'babel', // 'babel-loader' is also a valid name to reference
            query: {
                presets: ['es2015']
            }
        }, {
            test: /\.coffee$/,
            exclude: /(node_modules|bower_components)/,
            loader: 'babel?' + JSON.stringify(babelSettings) + '!coffee'
        }]
    }
};