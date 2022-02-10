// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start();
require('@rails/activestorage').start();
require('jquery');
require('jquery.easing');
require('moment');
require('bootstrap/dist/js/bootstrap.bundle.min.js');
require('@fortawesome/fontawesome-free/js/all.js');
var DataTable = require('datatables.net/js/jquery.dataTables.js');
require('datatables.net-bs4/js/dataTables.bootstrap4.js');
require('datatable-sorting-datetime-moment');
require('channels');
require('@kanety/jquery-nested-form');

require('../partials/_nested_forms');
// special multi nested forms:
require('../partials/_nested_content_block_form');
require('../partials/_nested_lunch_form');

// map in forms
require('../partials/_leaflet_map');

// ckeditor custom build
require('../ckeditor');

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

const initClassicEditor = (htmlEditor, rich = false) => {
  ClassicEditor.create(
    htmlEditor,
    !rich && {
      toolbar: [
        'heading',
        '|',
        'bulletedList',
        'numberedList',
        'link',
        'bold',
        'italic',
        '|',
        'undo',
        'redo'
      ]
    }
  )
    .then(() => {
      // SVA-315
      $('.ck-file-dialog-button button svg').insertBefore($('.ck-file-dialog-button button'));
      $('.ck-file-dialog-button button').remove();
      $('.ck-file-dialog-button').on('click', (e) => {
        e.preventDefault();
        $('.ck-file-dialog-button + .ck-splitbutton__arrow').trigger('click');
      });
    })
    .catch((error) => {
      console.error(error);
    });
};

/* eslint-disable func-names */
$(function () {
  document.querySelectorAll('.html-editor').forEach((htmlEditor) => initClassicEditor(htmlEditor));
  document
    .querySelectorAll('.html-editor-rich')
    .forEach((htmlEditor) => initClassicEditor(htmlEditor, true));

  // Init DataTables for all tables with css-class 'data_table'
  $.fn.dataTable = DataTable;
  $.fn.dataTable.moment('DD.MM.YYYY HH:mm [Uhr]');
  $.fn.dataTable.moment('DD.MM.YYYY');
  $.fn.dataTableSettings = DataTable.settings;
  $.fn.dataTableExt = DataTable.ext;
  DataTable.$ = $;
  $.fn.DataTable = function (opts) {
    return $(this).dataTable(opts).api();
  };

  $('.data_table').DataTable({
    searching: true,
    language: {
      url: '//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/German.json'
    },
    order: [[0, 'desc']],
    columnDefs: [
      {
        bSortable: false,
        targets: 'nosort'
      }
    ]
  });

  // Toggle the side navigation
  $('#sidebarToggle, #sidebarToggleTop').on('click', function () {
    $('.sidebar, #sidebarToggleTop').toggleClass('toggled');
  });

  // Close any open menu accordions when window is resized below 992px.
  // Resize event gets triggered on mobile scroll as the address bar gets smaller,
  // therefore check for difference in width inside resize event.
  var width = $(window).width();

  $(window).on('resize', function () {
    if ($(window).width() != width && $(window).width() < 992) {
      $('.sidebar, #sidebarToggleTop').addClass('toggled');
    }
  });

  // on rotation change remove resize listener, update `width` and bin resize listener again
  $(window).on('orientationchange', function () {
    $(window).off('resize');

    // wait a bit until orientation is changed and new dimensions set
    setTimeout(() => {
      width = $(window).width();

      $(window).on('resize', function () {
        if ($(window).width() != width && $(window).width() < 992) {
          $('.sidebar, #sidebarToggleTop').addClass('toggled');
        }
      });
    }, 500);
  });

  // Prevent the content wrapper from scrolling when the fixed side navigation hovered over
  $('body.fixed-nav .sidebar').on('mousewheel DOMMouseScroll wheel', function (e) {
    if ($(window).width() > 991) {
      var e0 = e.originalEvent,
        delta = e0.wheelDelta || -e0.detail;
      this.scrollTop += (delta < 0 ? 1 : -1) * 30;
      e.preventDefault();
    }
  });

  // Scroll to top button appear
  $(document).on('scroll', function () {
    var scrollDistance = $(this).scrollTop();
    if (scrollDistance > 100) {
      $('.scroll-to-top').fadeIn();
    } else {
      $('.scroll-to-top').fadeOut();
    }
  });

  // Smooth scrolling using jQuery
  $(document).on('click', 'a.scroll-to-top', function (e) {
    $('html, body').stop().animate(
      {
        scrollTop: 0
      },
      500,
      'swing'
    );
    e.preventDefault();
  });
});
/* eslint-enable func-names */
