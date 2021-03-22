// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import "@fortawesome/fontawesome-free/js/all";

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import "../stylesheets/application"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("trix")
require("@rails/actiontext")


$(function () {
  // TOPに戻るボタン
  var topBtn = $("#page-top");
  topBtn.hide();

  //スクロールが100に達したらボタン表示
  $(window).scroll(function () {
    var w = $(window).width();
    if ($(this).scrollTop() > 100) {
      topBtn.fadeIn();
    } else {
      topBtn.fadeOut();
    }
  });

  //スムーススクロールでページトップへ
  topBtn.click(function () {
    $("body,html").animate(
      {
        scrollTop: 0,
      },
      500
    );
    return false;
  });
});