const { environment } = require('@rails/webpacker')
const typescript =  require('./loaders/typescript')
const webpack = require('webpack');

environment.loaders.append('typescript', typescript)
environment.plugins.append('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
}));
module.exports = environment
