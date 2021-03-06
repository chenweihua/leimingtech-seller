<@p.header title="店铺申请－填写店主和店铺信息"/>
<meta charset="utf-8" />
<div class="layout">
    <script type="text/javascript" src="${base}/res/js/common_select.js" charset="utf-8"></script>
    <script type="text/javascript" src="${base}/res/js/ajaxfileupload/ajaxfileupload.js"></script>
    <script type="text/javascript" charset="utf-8" src="${base}/res/js/area.js"></script>
    <div class="wrap-shadow">
        <div class="wrap-all">
            <div class="chart">
                <div class="pos_x1 bg_a1" title="请选择店铺分类"></div>
                <div class="pos_x2 bg_b2" title="填写店主和店铺信息"></div>
                <div class="pos_x3 bg_c" title="完成"></div>
            </div>
            <div class="ncu-form-style grade-shop">
                <form method="post" enctype="multipart/form-data" id="apply_form" action="">
                    <input type="hidden" name="form_submit" value="ok" />
                    <input type="hidden" name="grade_id" value="1" />
                    <dl>
                        <dt class="required"><em class="pngFix"></em>店铺名称：</dt>
                        <dd>
                            <p>
                                <input class="w400 text" type="text" name="storeName" id="store_name" maxlength="20"/>
                                <span></span></p>
                            <p class="hint">请控制在20个字符以内</p>
                        </dd>
                    </dl>
                    <dl>
                        <dt class="required"><em class="pngFix"></em>店铺分类：</dt>
                        <dd>
                                <p>
							    	<span id="scError" style="color:red;"></span>
							    </p>
                                <select id="sc_id"  name="scId" onchange="storeClassCheck(this.options[this.selectedIndex].value);">
                                    <option value="">-请选择-</option>
							          <#list classList1 as sc>
							              <option value="${sc.id}">${sc.name}</option>
								              <#list sc.classList as sc2>
								                 <option value="${sc2.id}">&nbsp;&nbsp;&nbsp;&nbsp;${sc2.name}</option>
								              </#list>
							          </#list>
                                </select>
                        </dd>
                    </dl>
                    <dl>
                        <dt class="required">主营商品：</dt>
                        <dd>
                            <p>
                                <textarea name="storeZy" rows="2" class="textarea w400" maxlength="50" ></textarea>
                                <span></span> </p>
                            <p class="hint">主营商品关键字（Tag）有助于搜索店铺时找到您的店铺<br/>关键字最多可输入50字，请用","进行分隔，例如”男装,女装,童装”</p>
                        </dd>
                    </dl>
			        <dl>
			          <dt class="required"><em class="pngFix"></em>所在地区：</dt>
			          	<dd>
			          	    <p>
							   <input id="city_id" type="hidden" name="cityId"  value="">
							   <span></span>
							</p>
						    <span id="spanarea">
							<select name="provinceId" class="select" id="area" check="needCheck"> 
								<option value="">请选择</option>
								<#if areas??> 
									<#list areas as str>
										<option value="${str.areaId}">${str.areaName}</option>
									</#list> 
								</#if>
							</select> 
							<span id="spancity"></span>
							<span class="form-tips" style="color: red" name="check" id="checkedarea"></span> 
							<input id="area_id" class="area_ids" type="hidden" name="areaId" value="">
							<input id="area_info" class="area_names" type="hidden" name="areaInfo" value="">
						</dd>
			        </dl>
                    <dl>
                        <dt class="required"><em class="pngFix"></em>详细地址：</dt>
                        <dd>
                            <p>
                                <input class="w400 text" type="text" name="storeAddress"/>
                                <span></span>
                            </p>
                        </dd>
                    </dl>
                    <dl>
                        <dt><em class="pngFix"></em>邮政编码：</dt>
                        <dd>
                             <p>
	                            <input type="text" class="text w200" name="storeZip"/>
	                            <span></span>
	                         </p>
                        </dd>
                    </dl>
                    <dl>
                        <dt class="required"><em class="pngFix"></em>联系电话：</dt>
                        <dd>
                            <p>
                                <input type="text" class="text w200" name="storeTel" maxlength="20" />
                                <span></span></p>
                        </dd>
                    </dl>
                    <dl>
                        <dt class="required"><em class="pngFix"></em>身份证号：</dt>
                        <dd>
                            <p>
                                <input type="text" class="text w200" name="storeOwnerCard"/>
                                <span></span></p>
                        </dd>
                    </dl>
                    <dl>
                        <dt><em class="pngFix"></em>上传身份证：</dt>
                        <dd>
                             <p>
	                              <div class="banner">
	                                    <img alt="" id="IdcarduploadImage" src="" style="width:150px;height: 160px;">
	                                    <a href="javascript:void(0);" class="btn-upload btng-s">
	                                        <div id="result_banner"></div>
	                                        <input type="file" id="IdcardImage" name="files" class="file"
	                                               onChange="ajaxFileUploads('IdcardImage','IdcarduploadImage','storeImage');"/></a>
	                                     <input type="hidden" class="text w200" name="storeImage" id="storeImage"/>
	                                    <p class="hint">支持格式jpg,jpeg,png,gif，请保证图片清晰且文件大小不超过400KB</p>
	                              </div>
                             </p> 
                        </dd>
                        </dd>
                    </dl>
                    <dl>
                        <dt class="required"><em class="pngFix"></em>上传执照：</dt>
                        <dd>
                            <p>
                                 <input type="hidden" class="text w200" name="storeImage1" id="storeImage1"/>
	                               <span></span>
	                             <div class="banner">
	                                    <img alt="" id="uploadBannerImage" src="" style="width:150px;height: 160px;">
	                                    <a href="javascript:void(0);" class="btn-upload btng-s">
	                                        <div id="result_banner"></div>
	                                        <input type="file" id="bannerImage" name="files" class="file"  name="image1"
	                                               onChange="ajaxFileUploads('bannerImage','uploadBannerImage','storeImage1');"/></a>
	                                     <p class="hint">支持格式jpg,jpeg,png,gif，请保证图片清晰且文件大小不超过400KB </p>
	                              </div>
                             </p> 
                        </dd>
                    </dl>
                    <dl class="bottom">
                        <dt>&nbsp;</dt>
                        <dd>
                            <p class="mb10">
                                <input name="notice" type="checkbox" id="notice" value="1" checked="checked" />
                                <label for="notice">我已认真阅读并同意<a href="#?act=document&code=open_store" target="_blank">开店协议</a>中的所有条款</label>
                                <span></span> </p>
                            <p class="mb10">
                               <#-- <input type="submit" class="submit" value="立即开店" />-->
                                <input  class="btnb-l" type="button" id="submitBtn" value="提交注册"/>
                            </p>
                        </dd>
                    </dl>
                </form>
            </div>
        </div>
    </div>
    <script type="text/javascript">
       // var SITE_URL = "http://192.168.1.220";
        $(function(){
            $("#apply_form").validate({
                errorPlacement: function(error, element){
                    var error_td = element.parent('p').children('span');
                    error_td.find('.field_notice').hide();
                    error_td.append(error);
                },
                submitHandler:function(form){
                    ajaxpost('apply_form', '', '', 'onerror');
                },
                rules: {
                    storeOwnerCard: {
                        required: true,
                        minlength: 18,
                        maxlength: 18
                    },
                    storeName: {
                        required: true,
                        maxlength: 20,
                        remote   : {
                        url : '${base}/store/checkStorename',
                        type: 'get',
                        data:{
                            storename : function(){
                                return $('#store_name').val();
                            }
                        }
                    } 
                    },
                    storeAddress: {
                        required: true,
                    },
                    storeTel: {
                        required: true,
                        isTel:true
                    },
                  /*   scId: {
                        required: true
                    },  */
                    cityId: {
                        required: true
                    },
                     storeZip: {
                        number: true,
                        minlength: 6,
                        maxlength: 6
                    },
                    storeImage: {
                        accept: "jpg|jpeg|png|gif"
                    },
                    storeImage1: {
                        required: true,
                        accept: "jpg|jpeg|png|gif"
                    },
                    notice: {
                        required : true
                    }
                },
                messages: {
                    storeOwnerCard: {
                        required: '请输入真实身份证号',
                        minlength: '身份证格式不正确',
                        maxlength: '身份证格式不正确'
                    },
                    storeAddress: {
                        required: '请输入详细的商家地址，以便顾客能够上门提货及服务',
                    },
                    storeName: {
                        required: '请输入店铺名称',
                        maxlength:'请控制在20个字符以内',
                        remote: '该店铺名称已经存在，请您更换一个店面名称'
                    },
                    storeTel: {
                        required: '请输入联系电话',
                        isTel:'请输入正确的联系方式'
                    },
                  /*  scId: {
                        required: '请选择店铺分类'
                    }, */
                    cityId: {
                        required: '请选择地区'
                    },
                    storeZip: {
                        number: '邮编必须为数字',
                        minlength: '邮编格式不正确',
                        maxlength: '邮编格式不正确'
                    },
                    storeImage: {
                        accept: '请上传格式为 jpg,jpeg,png,gif 的文件'
                    },
                    storeImage1: {
                        required: '请上传营业执照，以便审核通过',
                        accept: '请上传格式为 jpg,jpeg,png,gif 的文件'
                    },
                    notice: {
                        required: '请阅读并同意开店协议'
                    }
                }
            });
            
             //校验电话格式
	       jQuery.validator.addMethod("isTel", function(value, element) { 
			  var tel =/(^(\d{2,5}-)?\d{6,9}(-\d{2,4})?$)|(^1\d{10}?$)/; //电话号码格式010-12345678 
			  return this.optional(element) || (tel.test(value)); 
			}, "phone"); 
                  //表单提交
        $("#submitBtn").click(function(){
	        if($("#apply_form").valid()){
	        		//店铺分类的校验
	        	   var scId = $('#sc_id').find("option:selected").val(); //店铺分类id的值
	        	   if(scId==''){
	        		  $("#scError").empty();
	         		  $("#scError").append("请选择店铺分类");
	 				  return false;
	 			   } 
	               $("#submitBtn").attr("disabled",true);
			        $.ajax({
					         type: "post",
					         url: '${base}/store/save',
					         data: $("#apply_form").serialize(),
					         dataType: "json",
					         contentType : "application/x-www-form-urlencoded; charset=utf-8",
							 async:false,
							 success:function(data) {
							 	if(data.success){
									 alert(data.message);
			                         window.location.href="${base}/joinIn/JoinInSuccess";
			                         return true;
								}else{
			                        $("#submitBtn").removeAttr("disabled");
								}
							 }
					 	   });
				  }	  
             });
        });
        function storeClassCheck(classId){
        	$("#scError").empty();
        	if(classId==''){
        		  $("#scError").append("请选择店铺分类");
				  return false;
			}  
			return true; 
        };
        //]]>
    </script></div>
<div id="footer" >
    <div class="wrapper">
        <p><a href="http://192.168.1.220">首页</a>
            | <a  href="#?act=article&article_id=24">招聘英才</a>
            | <a  href="#?act=article&article_id=25">广告合作</a>
            | <a  href="#?act=article&article_id=23">联系我们</a>
            | <a  href="#?act=article&amp;article_id=22">关于我们</a>
        </p>
        Copyright 2014-2018 北京雷铭信科技有限公司 Inc.All rights reserved.&nbsp;&nbsp;
        ICP证：<br/>
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
        //$(".scrollLoading").scrollLoading();
    });
</script>
<script language="javascript">
    var searchTxt = ' 请输入您要搜索的商品关键字';
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
        if($('#keyword').val()==searchTxt)
            $('#keyword').attr("value","");
        return true;
    }
    $('#keyword').css("color","#999999");
    
     //上传图片
	function ajaxFileUploads(myBlogImage,imgId,img){
	    $.ajaxFileUpload({
	        //处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
	        url: '${base}/storeSetting/fileUpload',
	        secureuri:false,                      //是否启用安全提交,默认为false
	        fileElementId:myBlogImage,           //文件选择框的id属性
	        dataType:'json',                       //服务器返回的格式,可以是json或xml等
	        fileSize:5120000,
	        allowType:'jpg,jpeg,png,JPG,JPEG,PNG',
	        success:function(data, status){        //服务器响应成功时的处理函数
	            if( true == data.success){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
	            	//alert(data.result);
	               $("img[id='"+imgId+"']").attr("src", "${imgServer}"+data.result);
	               $("#"+img).val(data.result);
	            }
	        },
	        error:function(data, status, e){ //服务器响应失败时的处理函数
	        	layer.msg('图片上传失败，请重试！！', 1, 8);
	            //$('#result').html('图片上传失败，请重试！！');
	        }
	    });
	}
</script>
</body>
</html>