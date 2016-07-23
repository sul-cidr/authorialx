export default {

  options: {

    transform: [
      'babelify',
    ],

    watch: true,
    browserifyOptions: {
      debug: true
    }

  },

  dist: {
    src: '<%= src %>/javascripts/index.js',
    dest: '<%= dist %>/script.js'
  }

};

