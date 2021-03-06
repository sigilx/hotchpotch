exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        "js/app.js": [/^js/, /^node_modules/],
        "js/board.js": /js\/board/
      }

      // To use a separate vendor.js bundle, specify two files path
      // http://brunch.io/docs/config#-files-
      // joinTo: {
      //   "js/app.js": /^js/,
      //   "js/vendor.js": /^(?!js)/
      // }
      //
      // To change the order of concatenation of files, explicitly mention here
      // order: {
      //   before: [
      //     "vendor/js/jquery-2.1.1.js",
      //     "vendor/js/bootstrap.min.js"
      //   ]
      // }
    },
    stylesheets: {
      joinTo: {
        "css/app.css": [/^css/, /^node_modules/],
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor"],
    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/]
    },
    vue: {
      extractCSS: true,
      out: "css/bundle.css"
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app", "js/ga"]
    }
  },

  npm: {
    enabled: true,
    styles: {
      "bootstrap": ["dist/css/bootstrap.css"],
      "bootstrap-vue": ["dist/bootstrap-vue.css"]
    },
    globals: {
      Vue: "vue/dist/vue.common.js",
      Vuex: "vuex/dist/vuex.common.js",
      jQuery: "jquery/dist/jquery.slim.js",
      Bootstrap: "bootstrap/dist/js/bootstrap.js"
    }
  }
};
