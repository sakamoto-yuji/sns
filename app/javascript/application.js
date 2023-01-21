// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// require jquery
import "@hotwired/turbo-rails"
import "controllers"
import "jquery-rails"

// フラッシュメッセージ
$(function(){
  $('.flash').fadeOut(4000);  //４秒かけて消えていく
});


