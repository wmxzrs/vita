module.exports = {
  productionSourceMap: false,
  publicPath: '/',
  css: {
    loaderOptions: {
      sass: {
        additionalData: `
          @use "~@/styles/variables.scss" as *;
          @use "~@/styles/mixin.scss" as *;
        `,
        sassOptions: {
          silenceDeprecations: ['legacy-js-api'],
        },
      },
    },
  },
}
