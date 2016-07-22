<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>商家中心-登录</title>
    <meta name="keywords" content="商城系统演示站"/>
    <meta name="description" content="商城系统演示站"/>
    <meta name="author" content="商城系统演示站">
    <meta name="copyright" content="商城系统演示站">
    <link rel="shortcut icon" href="res/css/favicon.ico"/>

    <link href="res/css/base.css" rel="stylesheet" type="text/css">
    <link href="res/css/home_header.css" rel="stylesheet" type="text/css">
    <link href="res/css/home_login.css" rel="stylesheet" type="text/css">
    <script src="res/js/jquery.js" ></script>
    <script src="res/js/jquery-ui/jquery.ui.js" ></script>
    <script src="res/js/jquery.validation.min.js" ></script>
    <script type="text/javascript" src="${base}/res/js/layer/layer.js"></script>
</head>
<body>
<!--头部-->
<!-- PublicHeadLayout Begin -->
<div class="header-wrap">
    <header class="public-head-layout wrapper">
        <!--LOGO-->
        <h1 class="site-logo"><a href="${base}"><img src="res/images/common/690ea902fe2708381da2cabff4ee46c8.png" class="pngFix"></a></h1>
        <!--搜索-->
    </header>
</div>
<!-- PublicHeadLayout End -->
<div class="clear"></div>
<script type="text/javascript">
    $(function () {
        $("#username").focus();
    });
    function changeCaptcha() {
        var captchaImg = '${base}/generateImage?t=' + Math.random();
        $("#captcha_img").attr("src", captchaImg);
    }
</script>
<style type="text/css">
    .wrapper {
        width: 1000px;
    }#footer-top ul li{margin-right:60px;}body,.header-wrap{background-color:#f2f2f2;}
</style>
<div class="nc-login-layout">
    <div class="nc-login-main">
        <div class="left-pic">
        	<img src="res/images/login/3.jpg"  border="0" style="max-height: 350px; max-width: 450px;">
        </div>
        <div class="nc-login">
            <div class="nc-login-title">
                <h3>商家中心登录</h3>
            </div>
            <div class="nc-login-content" id="demo-form-site">
                <form id="login_form" action="" class="bg" method="post">
                <#--<input type='hidden' name='formhash' value='3fa6c4ee' />-->
                <#--<input type="hidden" name="form_submit" value="ok" />-->
                <#--<input name="nchash" type="hidden" value="2089d710" />-->
                    <dl>
                        <dt>商家用户名</dt>
                        <dd style="min-height:54px;">
                            <input type="text" class="text" autocomplete="off"  name="username" id="username"zz>
                            <label></label>
                        </dd>
                    </dl>
                    <dl>
                        <dt>商家密码 </dt>
                        <dd style="min-height:54px;">
                            <input type="password" class="text" name="password" autocomplete="off"  id="password">
                            <label></label>
                        </dd>
                    </dl>
                    <dl>
                        <dt>验证码</dt>
                        <dd style="min-height:54px;">
                            <input class="text w50 fl" type="text" name="captcha" maxlength="4" size="10"/>
                            <img src="generateImage" title="看不清？点击换一张" onclick="changeCaptcha()" border="0" id="captcha_img" class="fl ml5"/>
                            <a href="javascript:void(0)" class="ml5" onclick="changeCaptcha()">看不清，换一张</a>
                            <label style="color: red;" id="errors">
                            </label>
                        </dd>
                    </dl>
                    <dl>
                        <dt>&nbsp;</dt>
                        <dd>
                            <a href="JavaScript:void(0);" class="submit" id="submitBtn"><span>登&nbsp;&nbsp;&nbsp;录</span></a>
                           <!--  <input type="submit" class="submit" value="登&nbsp;&nbsp;&nbsp;录" name="Submit"> -->
                            <a class="forget" href="${frontServer}/forget/index">忘记密码？</a><input type="hidden" value="index" name="ref_url"></dd>
                    </dl>

                </form>
                <dl class="mt10 mb10">
                    <dt>&nbsp;</dt>
                    <dd>还不是本站会员？立即<a title="注册" href="${frontServer}/signUp" class="register btn">注册</a></dd>
                </dl>
            </div>
        </div>
        <div class="clear"></div>
    </div>
</div>
<script>
    $(document).ready(function(){
        $("#login_form ").validate({
            errorPlacement: function(error, element){
                var error_td = element.parent('dd');
                error_td.find('label').hide();
                error_td.append(error);
            },
            rules: {
                username: "required",
                password: "required"
//                captcha : {
//                    required : true,
//                    remote   : {
//                        url : 'index.php?act=seccode&op=check&nchash=2089d710',
//                        type: 'get',
//                        data:{
//                            captcha : function(){
//                                return $('#captcha').val();
//                            }
//                        }
//                    }
//                }
            },
            messages: {
                username: "用户名不能为空",
                password: "密码不能为空"
//                ,
//                captcha : {
//                    required : '验证码不能为空',
//                    remote	 : '验证码错误'
//                }
            }
        });
        
         $('#submitBtn').click(function(){
		     if($("#login_form").valid()){
		         //加载进度条
	            layer.load(2, {
		               shade: [0.2,'#999999'] //0.1透明度的白色背景
	            });
		       // $("#submitBtn").attr("disabled",true);
				$.ajax({
		            type: "post",
		            url: 'loginCheck',
		            data: $("#login_form").serialize(),
		            dataType: "json",
		            async:false,
		            success:function(data) {
		                if(data.success){
		                    //alert(data.message);
		                    //layer.msg(data.message, {icon: 1});
		                    setTimeout("window.location='${base}'" ,200);
		                }else{
		                    $("#errors").html(data.message);
		                    //$("#submitBtn").removeAttr("disabled");
		                    layer.closeAll('loading');
		                    //alert(data.message);
		                }
		            }
		        }); 
		      }  
        });   
        /* $("#submitBtn").click(function(){
	        if($("#login_form").valid()){
	            $("#login_form").submit();
	        }
        }); */
           //回车登陆事件
           document.onkeydown = function(e){
		    var ev = document.all ? window.event : e;
		    if(ev.keyCode==13) {
               if($("#login_form").valid()){
                //加载进度条
	            layer.load(2, {
		               shade: [0.2,'#999999'] //0.1透明度的白色背景
	            });
		       // $("#submitBtn").attr("disabled",true);
				$.ajax({
		            type: "post",
		            url: 'loginCheck',
		            data: $("#login_form").serialize(),
		            dataType: "json",
		            async:false,
		            success:function(data) {
		                if(data.success){
		                    //alert(data.message);
		                    //layer.msg(data.message, {icon: 1});
		                    setTimeout("window.location='${base}'" , 200);
		                }else{
		                    $("#errors").html(data.message);
		                   // $("#submitBtn").removeAttr("disabled");
		                    layer.closeAll('loading');
		                    //alert(data.message);
		                }
		            }
		        }); 
		      }
             }
        }
    });
</script>
<div class="clear"></div>
<!-----footer------>
<@p.footer/>
</body>
</html>
