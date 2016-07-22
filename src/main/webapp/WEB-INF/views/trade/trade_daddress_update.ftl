<link href="${base}/res/css/base.css" rel="stylesheet" type="text/css">
<link href="${base}/res/css/member.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${base}/res/js/jquery.js"></script>
<script src="${base}/res/js/area.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/jquery.validation.min.js"></script>
<script type="text/javascript">
	var APP_BASE = '${base}';
</script>
<div id="fwin_my_address_add" class="dialog_wrapper ui-draggable" style="z-index: 1100; position: absolute; width: 550px; top: 38px;">
    <div class="dialog_body" style="position: relative;">
        <div class="dialog_content" style="margin: 0px; padding: 0px;">
            <div class="eject_con">
                <div class="adds">
                    <form method="post" action="" id="daddress_form" target="_parent">
                        <input type="hidden" name="storeId" value="${storeId}" />
                        <input type="hidden" name="addressId" value="${daddress.addressId}" />
                        <dl>
                            <dt class="required"><em class="pngFix"></em>联系人：</dt>
                            <dd>
                                <p>
                                    <input type="text" class="text" id="sellerName" name="sellerName" value="${daddress.sellerName}">
                                </p>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="required"><em class="pngFix"></em>所在地区：</dt>
                            <dd>
                                <div id="region">
                                	<input id="city_id" type="hidden" name="cityId" value="">
									<input id="area_id" class="area_ids" type="hidden" name="areaId" value="">
									<input id="area_info" class="area_names" type="hidden" name="areaInfo" value="">
                                    <span id="spanarea">
							        	<select name="provinceId" class="select" id="area">
							        		<option selected="selected" value="0">请选择</option>
							           		<#if areas??>
							  					<#list areas as str>
							  						<option value="${str.areaId}" >${str.areaName}</option>
							  					</#list>
											</#if>
						         		</select> 	
								    </span>
								    <span id="spancity"></span>
								    <span id="spanqu"></span>
								    <span class="areaMsg" style="color: red"></span>
                                </div>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="required"><em class="pngFix"></em>街道地址：</dt>
                            <dd>
                                <p>
                                    <input class="text w300" type="text" name="address" id="address" value="${daddress.address}">
                                </p>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="required"><em class="pngFix"></em>邮编：</dt>
                            <dd>
                                <input type="text" class="text valid" name="zipCode" id="zipCode" maxlength="6" value="${daddress.zipCode}">
                            </dd>
                        </dl>
                        <dl>
                            <dt>电话号码：</dt>
                            <dd>
                                <p>
                                    <input type="text" class="text" name="telPhone" id="telPhone" value="${daddress.telPhone}">
                                </p>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="required"><em class="pngFix"></em>手机号码：</dt>
                            <dd>
                                <input type="text" class="text" name="mobPhone" id="mobPhone" maxlength="11" value="${daddress.mobPhone}">
                            </dd>
                        </dl>
                        <dl>
                            <dt class="required"><em class="pngFix"></em>公司：</dt>
                            <dd>
                                <input type="text" class="text" name="company" id="company" value="${daddress.company}">
                            </dd>
                        </dl>
                        <dl>
                            <dt class="required"><em class="pngFix"></em>备注：</dt>
                            <dd>
                                <input type="text" class="text" name="content" id="content" value="${daddress.content}">
                            </dd>
                        </dl>
                        <dl>
                        	<dd>
                        		<a href="#none" class="ncu-btn2 mt5" onclick="save_address()">保存</a>
								<a href="#none" class="ncu-btn2 mt5" onclick="quxiao()">取消</a>
                            </dd>
                        </dl>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
	$(function(){
		init_area('${daddress.provinceId}','${daddress.cityId}','${daddress.areaId}');
		daddressValidate();
	});
	
	jQuery.validator.addMethod("isZipCode",function(value,element){
		var pattern = /^[0-9]{6}$/; //邮编格式
		return this.optional(element) || (pattern.test(value));  
	},"请填写正确的邮编");
	
	jQuery.validator.addMethod("isMobPhone",function(value,element){
		var pattern = /^1\d{10}$/; //手机号格式
		return this.optional(element) || (pattern.test(value));  
	},"请填写正确的手机号");
	
	//电话号码格式验证
	jQuery.validator.addMethod("isRegPhone",function(value,element){
		var tel = /^(\d{2,5}-)?\d{6,9}(-\d{2,4})?$/; //电话号码格式010-12345678 
		return this.optional(element) || (tel.test(value));       
	},"请填写正确的电话号码格式");
	
	var daddressValidate = function(){
		$('#daddress_form').validate({
		    errorPlacement: function(error, element){
		        $(element).next('.field_notice').hide();
		        $(element).after(error);
		    },
		    rules : {
		    	sellerName : {
		    		required   : true
		    	},
		        mobPhone : {	
					required   : true,
					isMobPhone : true
		        },
		        address : {
		        	required   : true
		        },
		        zipCode : {
		        	required   : true,
		        	isZipCode  : true
		        },
		        telPhone : {
		        	isRegPhone : true
		        },
		        company	: {
		        	required   : true
		        },
		        content	: {
		        	required   : true
		        }
		    },
		    messages : {
		    	sellerName : {
		    		required   : '请填写联系人姓名'
		    	},
		        mobPhone : {
					required : '请填写手机号码',
					isMobPhone : '请填写正确的手机号'
		        },
		        address : {
		        	required   : '请填写地址'
		        },
		        zipCode : {
		        	required   : '请填写邮编',
		        	isZipCode  : '请填写正确的邮编'
		        },
		        telPhone : {	
		        	isRegPhone : '请填写正确的电话号码格式'
		        },
		        company	: {
		        	required   : '请填写公司名称'
		        },
		        content	: {
		        	required   : '请填写备注'
		        }
		    }
		});
	}
	
	function quxiao(){
		parent.layer.closeAll();
	}
	
	function save_address(){
		if($('#daddress_form').valid()){
			var provinceId = $('#area').val(); //省的id
            var cityId = $('#city').val(); //城市id
            var areaId = $('#qu').val(); //区的id
			if(provinceId==''||provinceId=='0'){
                $(".areaMsg").html('请选择省份');
                return false;
            }else{
                $(".areaMsg").html('');
            }
            if(cityId==''||cityId=='0'){
                $(".areaMsg").html('请选择城市');
                return false;
            }
            if(areaId==''||areaId=='0'){
                $(".areaMsg").html('请选择区');
                return false;
            }else{
                $(".areaMsg").html('');
            }

            var provinceval = $('#area').find("option:selected").html(); //省的值
            var cityval = $('#city').find("option:selected").html(); //城市的值
            var quval = $('#qu').find("option:selected").html(); 	 //区的值
            var areaInfo=provinceval+","+cityval+","+quval;//保存到常用地址表
            $('#area_info').val(areaInfo);
            var daddress = $('#daddress_form').serialize();
            $.ajax({
                url:'${base}/transport/updateAdd',
                type:'post',
                data : daddress,
                dataType:'json',
                success:function(data){
                    if(data.success){
                         parent.layer.msg('修改成功', {icon: 1,time:1000},function(){parent.location.reload();parent.layer.closeAll();});
                    }else{
                        parent.layer.msg('修改失败', {icon: 2});
                    }
                },error:function(data){
                     parent.layer.msg('通信失败', {icon: 2});
                }
            });
		}
	}
</script>