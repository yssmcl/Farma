// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.md5
//= require bootbox.min
//= require ckeditor/init
//= require jquery_ckeditor_adapter
//= require underscore
//= require underscore.string
//= require backbone
//= require backbone-relational
//= require backbone.sync.rails
//= require Backbone.ModelBinder
//= require backbone.marionette
//= require twitter/bootstrap
//= require bootstrap-modalmanager
//= require bootstrap-modal
//= require handlebars
//= require monkeys
//= require carrie
//= require parser
//= require visualsearch
//= require timelineJS/embed
//= require_tree ./lib
//= require_tree ./helpers
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views
// require_tree ./routers
//= require_tree .

// Show loading feedback on ajax
$(document).ajaxStart(function () {
  $('.loading').show();
}).ajaxStop(function () {
  $('.loading').hide();
});


//$(this).scroll(function() {
//   if ($(this).scrollTop() > 120){
//      $('.sidebar-nav').addClass('sidebar-nav-fixed');
//      console.log(">")
//   } else {
//      console.log("<")
//      $('.sidebar-nav').removeClass('sidebar-nav-fixed');
//   }
//});

//$(function() {
//
//    var $sidebar   = $(".sidebar-nav"), 
//        $window    = $(window),
//        offset     = $sidebar.offset(),
//        topPadding = 40;
//
//    $window.scroll(function() {
//        if ($window.scrollTop() > offset.top) {
//            $sidebar.stop().animate({
//                marginTop: $window.scrollTop() - offset.top + topPadding
//            });
//        } else {
//            $sidebar.stop().animate({
//                marginTop: 0
//            });
//        }
//    });
//    
//});
