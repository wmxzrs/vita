module.exports = {
  productionSourceMap: false,
  publicPath: '/',
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
