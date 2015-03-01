// TODO: Add coffee version as a separate repo
// TODO: Add comments to classes

(function() {
  (function($) {
    "use strict";
    var methods, namespace;
    namespace = "loading";
    methods = {
      init: function(options) {
        var overlay;
        options = $.extend({
          className: "loading",
          links: "nav a",
          text: "loading",
          loadOnClick: false,
          where: "body"
        }, options);
        overlay = $(options.where).prepend('<div class="' + options.className + '"><div class="contents"><div class="animation"></div>' + options.text + '</div></div>');
        if (options.loadOnClick) {
          $(options.links).on("click", function() {
            return $(".loading").show();
          });
        }
        return $(window).on("load", function() {
          return $(".loading").fadeOut();
        });
      }
    };
    return $.fn.loading = function(method) {
      if (methods[method]) {
        methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === "object" || !method) {
        methods.init.apply(this, arguments);
      } else {
        $.error("Method " + method + " does not exist on jQuery." + namespace);
      }
    };
  })(jQuery);

}).call(this);
