// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

String.prototype.replaceAll = function(org, dest){  
    return this.split(org).join(dest);  
}; 

if (!window['console']){
    window.console = {
        info: function(){},
        log: function(){},
        warn: function(){},
        error: function(){},
        debug: function(){}
    };
};

$(function () {
  $("body").height($(window).height());
  $('body').layout({
    closable: false,
    resizable: false,
    slidable: false
  });

  $(":text").attr("size", 60);
});

