const webpack = require('webpack')

module.exports = {
  productionSourceMap: false,
  publicPath: '/',
  configureWebpack: {
    plugins: [
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        'window.$': 'jquery',
        'window.jQuery': 'jquery',
      }),
    ],
  },
  css: {
    loaderOptions: {
      sass: {
        additionalData: `
          @import "~@/styles/variables.scss";
          @import "~@/styles/mixin.scss";
        `,
        sassOptions: {
          silenceDeprecations: ['legacy-js-api'],
        },
      },
    },
  },
}
