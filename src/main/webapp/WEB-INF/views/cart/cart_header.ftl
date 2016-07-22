<!-- shop首页头部开始-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<#assign siteSettingTag = newTag("siteSettingTag") />
	<#assign siteSet = siteSettingTag("") />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${siteSet.siteTitle}</title>
    <meta name="keywords" content='${siteSet.siteKey}'/>
    <meta name="description" content='${siteSet.siteDiscription}'/>
    <meta name="author" content="${siteSet.siteDiscription}">
    <meta name="copyright" content="${siteSet.siteDiscription}">
    <link rel="shortcut icon" href="${base}/res/css/favicon.ico"/>
    <style type="text/css">
        body {
            _behavior: url("${base}/res/css/new-csshover.htc");
        }
    </style>
    <script src="${base}/res/js/html5shiv.min.js"></script>
    <link href="${base}/res/css/base.css" rel="stylesheet" type="text/css">
    <link href="${base}/res/css/home_header.css" rel="stylesheet" type="text/css">
    <link href="${base}/res/css/home_login.css" rel="stylesheet" type="text/css">
    <link href="${base}/res/css/font-icons/style.css" rel="stylesheet"/>
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="${base}/res/js/html5shiv.js"></script>
    <script src="${base}/res/js/respond.min.js"></script>
    <![endif]-->
    <script>
        COOKIE_PRE = '5C83_';
        _CHARSET = 'utf-8';
        SITEURL = '${frontServer}/';
    </script>
    <script src="${base}/res/js/jquery.js"></script>
	<!-- jqueryAutoComplete加载 -->
	<link href="${base}/res/js/jquery-ui-1.9.2.custom/css/custom-theme/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css">
	<script src="${base}/res/js/jquery-ui-1.9.2.custom/js/jquery-ui-1.9.2.custom.js"></script>
	<!-- autocomplete 加载OVER -->
    <script src="${base}/res/js/jquery.SuperSlide.2.1.1.js"></script>
    <script src="${base}/res/js/common.js" charset="utf-8"></script>
    <!-- <script src="${base}/res/js/jquery-ui/jquery.ui.js" type="text/javascript"></script> -->
    <script src="${base}/res/js/jquery.validation.min.js"></script>
    <script src="${base}/res/js/jquery.masonry.js"></script>
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
        <script type="text/javascript" src="${base}/res/js/IE6_MAXMIX.js"></script>
    <![endif]-->
   <!--  <script type="text/javascript">
        var PRICE_FORMAT = '&yen;%s';
        $(function () {
            //search
            $("#search").children('ul').children('li').click(function () {
                $(this).parent().children('li').removeClass("current");
                $(this).addClass("current");
                $('#search_act').attr("value", $(this).attr("act"));
                $('#keyword').attr("value", $(this).attr("title"));
            });
            var search_act = $("#search").find("li[class='current']").attr("act");
            $('#search_act').attr("value", search_act);
            $("#keyword").blur();
        });
    </script> -->
</head>
<body>
<script type="text/javascript" src="${base}/res/js/common2.2.js" charset="utf-8"></script>
<div id="append_parent"></div>
<div id="ajaxwaitid"></div>
<div class="public-top-layout w">
    <div class="topbar wrapper">
        <div class="user-entry">
        <@shiro.user>
        <script type="text/javascript">
        	isLogin = true;
        </script>
            您好
            <span>&nbsp;
            	<a href="${base}/user/index"><@shiro.principal/></a>
            </span>，欢迎来到
           <a href="${base}/"  title="首页" alt="首页">
	            <#if siteSet?? && siteSet!='null'>
	            	${siteSet.siteName}
	            <#else>
	            </#if>
            </a>
            <span>[<a href="${base}/logout">退出</a>]</span>
        </@shiro.user>
        <@shiro.guest>
        	<script type="text/javascript">
	        	isLogin = false;
	        </script>
            您好，欢迎来到
            <a href="${base}/" title="首页" alt="首页">
             	<#if siteSet?? && siteSet!='null'>
	            	${siteSet.siteName}
	            <#else>
	            </#if>
            </a>
            <span>[<a href="${base}/login">登录</a>]</span>
            <span>[<a href="${base}/signUp">注册</a>]</span>
        </@shiro.guest>
		  	<span class="seller-login">
				<a href="${sellerServer}/" title="商家中心" target="_blank">
					<i class="icon-signin"></i>商家管理中心
				</a>
			</span>
        </div>

        <div class="quick-menu">
            <dl>
                <dt><a href="${base}/user/list">我的订单</a><i></i></dt>
                <dd>
                    <ul>
                        <li><a href="${base}/user/list?orderState=10">待付款订单</a>
                        </li>
                        <li>
                            <a href="${base}/user/list?orderState=30">待确认收货</a>
                        </li>
                        <li><a href="${base}/user/list?evaluationStatus=0">待评价交易</a>
                        </li>
                    </ul>
                </dd>
            </dl>
            <dl>
                <dt><a href="${base}/myuser/goodsFavIndex" title="我的收藏" target="_top">我的收藏</a><i></i>
                </dt>
                <dd>
                    <ul>
                        <li><a href="${base}/myuser/goodsFavIndex" target="_top" title="收藏的商品">收藏的商品</a></li>
                        <li><a href="${base}/myuser/storeindex" target="_top" title="/">收藏的店铺</a></li>
                    </ul>
                </dd>
            </dl>
            <dl>
                <dt><a href="#" title="客户服务" target="_top" >客户服务</a><i></i></dt>
                <dd>
                    <ul>
                        <li><a href="${base}/help/index?acId=5">售后服务</a></li>
                        <li><a href="${base}/help/content?acId=7&articleId=38">客服中心</a></li>
                    </ul>
                </dd>
            </dl>

            <dl>
                <dt><a href="${base}/" title="站点导航" target="_top">站点导航</a><i></i></dt>
                <dd>
                    <ul>
                        <li><a target="_blank" href="${base}/">商城首页</a></li>
                    </ul>
                </dd>
            </dl>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        $(".quick-menu dl").hover(function () {
                    $(this).addClass("hover");
                },
                function () {
                    $(this).removeClass("hover");
                });

    });
</script>
<div class="header-wrap">
    <header class="public-head-layout wrapper">
        <!--LOGO-->
        <h1 class="site-logo">
	        <a href="${base}/">
	        	<img src="${imgServer}/${siteSet.logo}" style="max-height:60px;max-width:300px"class="pngFix">
	        </a>
        </h1>
        <!--搜索-->
        <div class="head-search-bar" id="search">
            <!--商品和店铺-->
            <ul class="tab">
                <li searchModel="goodsSearch" name="searchTypee" matchAction="goodsKeywordMatch" class="current" act="keywordSearch" title=" 请输入您要搜索的商品关键字">商品</li>
                <li searchModel="storeSearch" name="searchTypee" matchAction="storeKeywordMatch" act="shop_search" title=" 请输入您要搜索的店铺关键字">店铺</li>
            </ul>
            <form action="${base}/search/goodsSearch" method="get" class="search-form">
                <input name="searchType" id="search_act" value="keywordSearch" type="hidden">
                <input name="keyword" id="keyword" type="text" class="input-text" value=" 请输入您要搜索的商品关键字"
                       onFocus="searchFocus(this)" onBlur="searchBlur(this)" maxlength="60" x-webkit-speech lang="zh-CN"
                       onwebkitspeechchange="foo()" x-webkit-grammar="builtin:search"/>
                <input type="submit" id="button" value="搜索" class="input-submit">
            </form>
            <script type="text/javascript">
            //jquery.autocomplete
				jQuery(function($){
					$("#keyword").autocomplete({
						source: function (request, response){
									$.ajax({
										url:"${base}/search/"+$("[name=searchTypee][class=current]").attr("matchAction"),
										dataType: "json",
										data:{
											keyword: request.term
										},
										success: function(data){
											response($.map(data, function(item){
												return {
													 value: item.keyword,
													 label: item.keyword  + " 约" + item.wordsNum + item.unit
												}
											}));
										}
									});
								},
						minLength: 2
					});
               });
			</script>
            <script type="text/javascript">
				//商品搜索以及店铺搜索
				$(function(){
					$("[searchModel]").click(function(){
						var url = $(this).attr("searchModel");
						$(".search-form").attr("action",'${base}/search/'+url);
						$("[searchModel]").each(function(){
							$(this).attr("class","");
						});
						$(this).attr("class","current");
						return false;
					});
				});
			</script>
            <!--搜索关键字-->
            <!-- <div class="keyword">热门搜索：
                <ul>
                    <li><a href="#">李宁</a></li>
                    <li><a href="#">耐克</a></li>
                    <li><a href="#">Kappa</a></li>
                    <li><a href="#">双肩包</a></li>
                    <li><a href="#">手提包</a></li>
                </ul>
            </div> -->
        </div>
        <div class="head-user-menu">
            <dl class="my-mall">
                <!---我的商城--->
                <dt><span class="icon-user"></span>我的商城<i class="arrow"></i></dt>
                <dd>
                    <div class="sub-title">
                        <h4></h4>
                        <!----买家首页---->
                        <a href="${base}/user/setting/index" class="arrow">我的用户中心<i></i></a>
                    </div>
                    <div class="user-centent-menu">
                        <ul>
                            <li>
                            	<a href="${base}/user/list" class="arrow">我的订单<i></i></a>
                            </li>
                            <li>
                            	<a href="${base}/myconsult/index?consultReply=1&cur=reply" class="arrow">咨询回复<i></i></a>
                            </li>
                            <li>
                            	<a href="${base}/myuser/goodsFavIndex" class="arrow">我的收藏<i></i></a>
                            </li>
                            <li>
                            	<a href="${base}/user/shoppoints/mypointslogindex" class="arrow">我的积分<i></i></a>
                            </li>
                        </ul>
                    </div>
                    <!-- <div class="browse-history">
                        <div class="part-title">
                            <h4>最近浏览的商品</h4>
                        </div>
                        <ul>
                        </ul>
                    </div> -->
                </dd>
            </dl>
            <dl class="my-cart">
                <div class="addcart-goods-num">0</div>
                <dt><span class="icon-cart"></span><a href="${base}/cart/index">购物车结算</a><i class="arrow"></i></dt>
                <dd>
                    <div class="sub-title">
                        <h4>最新加入的商品</h4>
                    </div>
                    <div class="incart-goods-box">
                        <img class="loading" src="${base}/res/images/loading.gif"/>

                        <div class="checkout"><a href="${base}/cart/index" class="btn-cart">结算购物车中的商品</a>
                        </div>
                    </div>
                </dd>
            </dl>
            <script type="text/javascript">
				$(function(){
					$.ajax({
	                    url: '${base}/cart/cart',
	                    async: false,
	                    type: 'POST',
	                    dataType: 'json',
	                    success: function (data) {
	                    	var result = data.result;
	                     	if (result.goodsNum > 0){
	                     		$(".addcart-goods-num").html(result.goodsNum);
	                     	}
	                    }
	                });
				});
			</script>
        </div>
    </header>
</div>
<!-- PublicHeadLayout End -->
<!-- publicNavLayout Begin -->
<nav class="public-nav-layout">
    <div class="wrapper">
        <div class="all-category">
            <div class="title">
                <h3><a href="${base}/all/class">所有商品分类</a></h3>
                <i class="arrow"></i>
            </div>
            <!--左侧菜单-->
            <div class="category">
                <ul class="menu">
                	<#assign goodsClassTag =newTag("goodsClassTag")>
					<#assign goodsList =goodsClassTag("")>
					<#if goodsList?exists && goodsList?size gt 0>
						<#list goodsList as class>
						<#if class.gcshow == 1>
							<li cat_id="${class.gcId}" class="<#if class_index%2 == 0>odd<#else>even</#if>">
								<div class="class">
									<span class="ico">
										<img src="${imgServer}/upload/img/brand/6e9379ae20ae185672d256ef3ec83df4.jpg">
									</span>
									<h4>
										<a href="${base}/search/goodsSearch?searchType=gcIdSearch&keyword=${class.gcId}" title="${class.gcName}">${class.gcName}</a>
									</h4>
									<span class="recommend-class" id="recommend-class-${class.gcId}">
										
									</span>
									<span class="arrow"></span>
								</div>
								<#if class.hasChild gt 0>
								<#assign firstchild = class.classList>
								<div class="sub-class" cat_menu_id="${class.gcId}">
									<#list firstchild as firstclass>
									<#if firstclass.gcshow==1>
									<dl>
			                                <dt>
			                                	<h3>
			                                		<a href="${base}/search/goodsSearch?searchType=gcIdSearch&keyword=${firstclass.gcId}" title="${firstclass.gcName}">${firstclass.gcName}</a>
			                                	</h3>
			                                </dt>
		                                <dd class="goods-class">	
		                                <#if firstclass.hasChild gt 0>
		                                	<#assign secondchild = firstclass.classList>
		                                	<#assign secondsize = secondchild?size>
		                                	<#list secondchild as secondclass>
		                                		<#if secondclass_index == 0 && secondclass.gcshow==1>
		                                			<script>
		                                				var h = "<a href='${base}/search/goodsSearch?searchType=gcIdSearch&keyword=${secondclass.gcId}' title='${secondclass.gcName}'>${secondclass.gcName}</a>";
		                                				$("#recommend-class-${class.gcId}").append(h);
		                                			</script>
		                                		</#if>
		                                		<#if secondclass.gcshow==1>
		                                		<a href="${base}/search/goodsSearch?searchType=gcIdSearch&keyword=${secondclass.gcId}" 
		                                			title="${secondclass.gcName}" <#if secondclass_index+1 == secondsize>style="background:none;"</#if>>${secondclass.gcName}</a>
		                                		</#if>
		                                	</#list>
		                                </#if>
                                    	</dd>
                                      </#if>
		                            </dl>
		                            </#list>
								</div>
								</#if>
							</li>
						</#if>
						</#list>
					</#if>
                </ul>
            </div>
        </div>
        <!--分类树结束-->
        <ul class="site-menu">
           <#assign navTag = newTag("navigationTag") />
            <#assign navTagList = navTag("{'navLocation':0,'navType':0,'navItemId':0}") />
            <#if navTagList??>
            	<#list navTagList as navigtion >
            		<li <#if (navigtion_index+1)==1 >class="current"<#else>class="link"</#if>>
	            		<a href="${navigtion.navUrl}" <#if navigtion.navNewOpen==1>target="_blank"</#if>>
	            			${navigtion.navTitle }
	            		</a>
            		</li>
                </#list>
             </#if>
            <!-- <li class="current"><a href="${base}/">首页</a></li>
            <li class="link"><a href="${base}/all/brand">品牌</a></li>
            <li class="link"><a href="${base }/all/coupon">优惠券</a></li>
            <li class="link"><a href="${base}/points/index">积分中心</a></li> -->
            <!--<li class="link"><a href="#" class="pngFix">团购</a></li>
            <li class="link"><a href="#">品牌</a></li>
            <li class="link"><a href="#">优惠券</a></li>
            <li class="link"><a href="#">积分中心</a></li>
            <li class="link"><a href="#">运动专场</a></li>
            <li class="link"><a target="_blank" href="#">微商城</a></li> -->
        </ul>
    </div>
</nav>
<!-- PublicNavLayout End-->
