$(function(){"use strict";$(".wrap-slick1").each(function(){var s=$(this),i=$(this).find(".slick1"),t=$(i).find(".item-slick1"),a=$(i).find(".layer-slick1"),e=[];$(i).on("init",function(){for(var s=$(t[0]).find(".layer-slick1"),i=0;i<e.length;i++)clearTimeout(e[i]);$(a).each(function(){$(this).removeClass($(this).data("appear")+" visible-true")});for(i=0;i<s.length;i++)e[i]=setTimeout(function(i){$(s[i]).addClass($(s[i]).data("appear")+" visible-true")},$(s[i]).data("delay"),i)});var o=!1;$(s).find(".wrap-slick1-dots").length>0&&(o=!0),$(i).slick({pauseOnFocus:!1,pauseOnHover:!1,slidesToShow:1,slidesToScroll:1,fade:!0,speed:1e3,infinite:!0,autoplay:!0,autoplaySpeed:6e3,arrows:!0,appendArrows:$(s),prevArrow:'<button class="arrow-slick1 prev-slick1"><i class="zmdi zmdi-caret-left"></i></button>',nextArrow:'<button class="arrow-slick1 next-slick1"><i class="zmdi zmdi-caret-right"></i></button>',dots:o,appendDots:$(s).find(".wrap-slick1-dots"),dotsClass:"slick1-dots",customPaging:function(s,i){return'<img src="'+$(s.$slides[i]).data("thumb")+'"><span class="caption-dots-slick1">'+$(s.$slides[i]).data("caption")+"</span>"}}),$(i).on("afterChange",function(s,i,o){for(var l=$(t[o]).find(".layer-slick1"),r=0;r<e.length;r++)clearTimeout(e[r]);$(a).each(function(){$(this).removeClass($(this).data("appear")+" visible-true")});for(r=0;r<l.length;r++)e[r]=setTimeout(function(s){$(l[s]).addClass($(l[s]).data("appear")+" visible-true")},$(l[r]).data("delay"),r)})}),$(".wrap-slick2").each(function(){$(this).find(".slick2").slick({slidesToShow:4,slidesToScroll:4,infinite:!1,autoplay:!1,autoplaySpeed:6e3,arrows:!0,appendArrows:$(this),prevArrow:'<button class="arrow-slick2 prev-slick2"><i class="fa fa-angle-left" aria-hidden="true"></i></button>',nextArrow:'<button class="arrow-slick2 next-slick2"><i class="fa fa-angle-right" aria-hidden="true"></i></button>',responsive:[{breakpoint:1200,settings:{slidesToShow:4,slidesToScroll:4}},{breakpoint:992,settings:{slidesToShow:3,slidesToScroll:3}},{breakpoint:768,settings:{slidesToShow:2,slidesToScroll:2}},{breakpoint:576,settings:{slidesToShow:1,slidesToScroll:1}}]})}),$('a[data-toggle="tab"]').on("shown.bs.tab",function(s){var i=$(s.target).attr("href");$(i).find(".slick2").slick("reinit")}),$(".wrap-slick3").each(function(){$(this).find(".slick3").slick({slidesToShow:1,slidesToScroll:1,fade:!0,infinite:!0,autoplay:!1,autoplaySpeed:6e3,arrows:!0,appendArrows:$(this).find(".wrap-slick3-arrows"),prevArrow:'<button class="arrow-slick3 prev-slick3"><i class="fa fa-angle-left" aria-hidden="true"></i></button>',nextArrow:'<button class="arrow-slick3 next-slick3"><i class="fa fa-angle-right" aria-hidden="true"></i></button>',dots:!0,appendDots:$(this).find(".wrap-slick3-dots"),dotsClass:"slick3-dots",customPaging:function(s,i){return'<img src=" '+$(s.$slides[i]).data("thumb")+' "/><div class="slick3-dot-overlay"></div>'}})})});