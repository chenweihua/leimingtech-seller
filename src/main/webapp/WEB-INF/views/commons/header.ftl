<!-- 卖家头开始 -->
<#macro header title="">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${title}</title>
    <meta name="keywords" content="美享电子商务系统"/>
    <meta name="description" content="美享电子商务系统"/>
    <meta name="author" content="美享电子商务系统">
    <meta name="copyright" content="美享电子商务系统">
    <link rel="shortcut icon" href="${base}/res/css/favicon.ico"/>
    <link href="${base}/res/css/base.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/res/css/member.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/res/css/member_store.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/res/css/font-icons/style.css"  rel="stylesheet" />
    <!--[if IE 6]>
    <style type="text/css">
    	body {_behavior: url(${base}/res/css/csshover.htc);}
	</style>
    <![endif]-->
    <script type="text/javascript" src="${base}/res/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/res/js/jquery-ui/jquery.ui.js"></script>
    <script type="text/javascript" src="${base}/res/js/jquery.validation.min.js"></script>
    <script type="text/javascript" src="${base}/res/js/common.js"></script>
    <script type="text/javascript" src="${base}/res/js/member/member.js" charset="utf-8"></script>
    <script type="text/javascript" src="${base}/res/js/utils.js" charset="utf-8"></script>
    <script type="text/javascript" src="${base}/res/js/jquery.cookie.js"></script>
    <script type="text/javascript" src="${base}/res/js/layer/layer.js"></script>
    <script type="text/javascript" src="${base}/res/js/menu.js"></script>
    <script type="text/javascript" src="${base}/res/js/index.js"></script>
    <script type="text/javascript" src="${base}/res/js/menuleft.js"></script>
    <!-- IE8兼容性 -->
   	<script src="${frontServer}/res/js/html5shiv.min.js"></script>
    <!--[if IE]>
    <script src="${base}/res/js/html5.js"></script>
    <![endif]-->
    <!--[if IE 6]>
    <script src="${base}/res/js/IE6_PNG.js"></script>
    <script>
        DD_belatedPNG.fix('.pngFix');
    </script>
    <script>
        // <![CDATA[
        if((window.navigator.appName.toUpperCase().indexOf("MICROSOFT")>=0)&&(document.execCommand))
        try{
        document.execCommand("BackgroundImageCache", false, true);
           }
        catch(e){}
        // ]]>
     </script>
     <![endif]-->
    <script type="text/javascript">
        COOKIE_PRE = '5C83_';_CHARSET = 'utf-8';SITEURL = '${sellerServer}/';
        var PRICE_FORMAT = '&yen;%s';
        $(function(){
            //search
            $("#details").children('ul').children('li').click(function(){
                $(this).parent().children('li').removeClass("current");
                $(this).addClass("current");
                $('#search_act').attr("value",$(this).attr("act"));
            });
            var search_act = $("#details").find("li[class='current']").attr("act");
            $('#search_act').attr("value",search_act);
            $("#keyword").blur();
        });
    </script>
    <script type="text/javascript">
        var APP_BASE = '${base}/';
        var FRONT_BASE = '${frontServer}/';
        var STORE_ID = '${storeid}';
    </script>
</head>
<body>
<!-- <script type="text/javascript" src="${base}/res/js/common2.2.js" charset="utf-8"></script> -->
<div id="append_parent"></div>
<div id="ajaxwaitid"></div>
<div class="public-top-layout w">
    <div class="topbar wrapper">
        <div class="user-entry" >
            <@shiro.user>
                您好<span>&nbsp;&nbsp;<a href="${base}"><@shiro.principal/></a></span>，欢迎来到<a href="${frontServer}/"  title="首页" alt="首页">美享电子商务系统</a>
                <span>[<a href="${base}/logout">退出</a>]</span>
                <span class="seller-login">
				<a href="${base}" title="商家中心" >
					<i class="icon-signin"></i>商家管理中心
				</a>
			</span>
            </@shiro.user>
            <@shiro.guest>
                您好，欢迎来到<a href="${base}/" title="首页" alt="首页">美享电子商务系统</a>
                <span>[<a href="${base}/login">登录</a>]</span>
                <span>[<a href="${base}/signUp">注册</a>]</span>
            </@shiro.guest>
        </div>

        <div class="quick-menu">
            <dl>
                <dt><a href="#?act=member&op=order">我的订单</a><i></i></dt>
                <dd>
                    <ul>
                        <li><a href="#?act=member&op=order&state_type=order_pay">待付款订单</a></li>
                        <li><a href="#?act=member&op=order&state_type=order_shipping">待确认收货</a></li>
                        <li><a href="#?act=member&op=order&state_type=noeval">待评价交易</a></li>
                    </ul>
                </dd>
            </dl>
            <dl>
                <dt><a href="#?act=member_favorites&op=fglist" title="我的收藏" target="_top" >我的收藏</a><i></i></dt>
                <dd>
                    <ul>
                        <li><a href="#?act=member_favorites&op=fglist" target="_top" title="收藏的商品" >收藏的商品</a></li>
                        <li><a href="#?act=member_favorites&op=fslist" target="_top" title="收藏的店铺" >收藏的店铺</a></li>
                    </ul>
                </dd>
            </dl>
            <dl>
                <dt>客户服务<i></i></dt>
                <dd>
                    <ul>
                        <li><a href="#?act=article&ac_id=2">帮助中心</a></li>
                        <li><a href="#?act=article&ac_id=5">售后服务</a></li>
                        <li><a href="#?act=article&ac_id=6">客服中心</a></li>
                    </ul>
                </dd>
            </dl>

            <dl>
                <dt>站点导航<i></i></dt>
                <dd>
                    <ul>
                        <li><a target="_blank" href="${frontServer }">商城首页</a></li>
                    </ul>
                </dd>
            </dl>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        $(".quick-menu dl").hover(function() {
                    $(this).addClass("hover");
                },
                function() {
                    $(this).removeClass("hover");
                });

    });
</script>
<!-- PublicHeadLayout Begin --><div id="header">
    <h1 title="美享电子商务系统">
    	<a href="${frontServer }">
    		<img src="${base}/res/images/common/690ea902fe2708381da2cabff4ee46c8.png" alt="美享电子商务系统" class="pngFix" style="max-height: 60px; max-width: 300px;">
    	</a>
   		<i>商家中心</i>
    </h1>
    <div id="search" class="search">
        <div class="details" id="details">
            <ul class="tab">
                <li searchModel="goodsSearch" class="current" act="keywordSearch"><span>商品</span></li>
                <li  searchModel="storeSearch" act="storeSearch"><span>店铺</span></li>
            </ul>
            <div id="a1" class="form">
                <form method="get" action="${frontServer}/search/goodsSearch" id="searchForm" target="_blank">
                    <input name="searchType" id="search_act" value="keywordSearch" type="hidden">
                    <div class="formstyle">
                        <input name="keyword" id="keyword" type="text" class="textinput" value=" 搜索其实很容易！" onFocus="searchFocus(this)" onBlur="searchBlur(this)" maxlength="200"/>
                        <input name="" type="submit" class="search-button" value="">
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
	//商品搜索以及店铺搜索
	$(function(){
		$("[searchModel]").click(function(){
			var url = $(this).attr("searchModel");
			$("#searchForm").attr("action",'${frontServer}/search/'+url);
			$("[searchModel]").each(function(){
				$(this).attr("class","");
			});
			$(this).attr("class","current");
			return false;
		});
	});
</script>
</#macro>
<!-- 卖家头结束 -->

<#macro footer>
<div id="footer" >
    <div class="wrapper">
        <p>
        <a href="#">首页</a>
             | <a  href="#?act=article&article_id=24">招聘英才</a>
             | <a  href="#?act=article&article_id=25">广告合作</a>
             | <a  href="#?act=article&article_id=23">联系我们</a>
             | <a  href="#?act=article&amp;article_id=22">关于我们</a>
	         |&nbsp;<a href="${frontServer}" >商城首页</a>
	         <!--|&nbsp;<a href="${base}/m/index/index" >微商城</a> -->
	         |&nbsp;<a href="${frontServer}/login" >会员管理中心</a>
	         |&nbsp;<a href="${adminServer}/login" >后台管理中心</a>
	        </p>
	        Copyright 2011-2015 上海英科信息金融服务有限公司 Inc.All rights reserved.&nbsp;&nbsp;
        <div class="footer-logo">
            <ul>
                <li class="caifutong"></li>
                <li class="caifubao"></li>
                <li class="beifen"></li>
                <li class="kexin"></li>
                <li class="shiming"></li>
                <li class="wangzhan360"></li>
                <li class="anquanlianmeng"></li>
                <div class="clear"></div>
            </ul>
        </div>
    </div>
</div>
</div>
<script type="text/javascript" src="${base}/res/js/jquery.cookie.js" ></script>
<script type="text/javascript" src="${base}/res/js/perfect-scrollbar.min.js" ></script>
<script type="text/javascript" src="${base}/res/js/jquery.mousewheel.js" ></script>
<script type="text/javascript" src="${base}/res/js/jquery.masonry.js" ></script>
<script type="text/javascript" src="${base}/res/js/jquery.scrollLoading-min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        //实现图片慢慢浮现出来的效果
        $("img").load(function () {
            //图片默认隐藏
            $(this).hide();
            //使用fadeIn特效
            $(this).fadeIn("5000");
        });
        // 异步加载图片，实现逐屏加载图片
        $(".scrollLoading").scrollLoading();
    });
</script>
<script type="text/javascript">
    var PRICE_FORMAT = '&yen;%s';
    $(function(){
        //首页左侧分类菜单
        $(".category ul.menu").find("li").each(
                function() {
                    $(this).hover(
                            function() {
                                var cat_id = $(this).attr("cat_id");
                                var menu = $(this).find("div[cat_menu_id='"+cat_id+"']");
                                menu.show();
                                $(this).addClass("hover");
                                if(menu.attr("hover")>0) return;
                                menu.masonry({itemSelector: 'dl'});
                                var menu_height = menu.height();
                                if (menu_height < 60) menu.height(80);
                                menu_height = menu.height();
                                var li_top = $(this).position().top;
                                if ((li_top > 60) && (menu_height >= li_top)) $(menu).css("top",-li_top+50);
                                if ((li_top > 150) && (menu_height >= li_top)) $(menu).css("top",-li_top+90);
                                if ((li_top > 240) && (li_top > menu_height)) $(menu).css("top",menu_height-li_top+90);
                                if (li_top > 300 && (li_top > menu_height)) $(menu).css("top",60-menu_height);
                                if ((li_top > 40) && (menu_height <= 120)) $(menu).css("top",-5);
                                menu.attr("hover",1);
                            },
                            function() {
                                $(this).removeClass("hover");
                                var cat_id = $(this).attr("cat_id");
                                $(this).find("div[cat_menu_id='"+cat_id+"']").hide();
                            }
                    );
                }
        );
        $(".head-user-menu dl").hover(function() {
                    $(this).addClass("hover");
                },
                function() {
                    $(this).removeClass("hover");
                });
        $('.head-user-menu .my-mall').mouseover(function(){// 最近浏览的商品
            load_history_information();
            $(this).unbind('mouseover');
        });
        $('.head-user-menu .my-cart').mouseover(function(){// 运行加载购物车
            load_cart_information();
            $(this).unbind('mouseover');
        });
    });

</script>
<script language="javascript">
    var searchTxt = ' 搜索其实很容易！';
    function searchFocus(e){
        if(e.value == searchTxt){
            e.value='';
            $('#keyword').css("color","");
        }
    }
    function searchBlur(e){
        if(e.value == ''){
            e.value=searchTxt;
            $('#keyword').css("color","#999999");
        }
    }
    function searchInput() {
        if($('#keyword').val()==searchTxt);
            $('#keyword').attr("value","");
        return true;
    }
    $('#keyword').css("color","#999999");
</script>

</body>
</html>
</#macro>