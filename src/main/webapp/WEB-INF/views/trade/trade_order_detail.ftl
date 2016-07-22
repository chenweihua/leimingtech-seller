<@p.header title="订单管理"/>
<script type="text/javascript" src="${base}/res/js/layer/layer.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/jquery.validation.min.js"></script>
<script src="${base}/res/js/area.js" charset="utf-8"></script>
<div id="container" class="wrapper">
	<div class="layout">

		<div class="wrap-shadow">
			<div class="wrap-all ncu-order-view">
				<h2>订单详情</h2>
				<#if order??>
				 <dl class="box"> 
					<dt>订单状态：</dt>
					<dd>
						<#if order.orderState==0>
		                    <strong><span style="color:#999">订单已取消</span><br/></strong>
		                <#elseif order.orderState==10>
	                    	<strong><span style="color:#36C">待买家付款</span></strong>
		                <#elseif order.orderState==20>
		                    <strong><span style="color:#F30">买家已付款</span></strong>
		                <#elseif order.orderState==30>
		                	<strong><span style="color:#F30">卖家已发货</span></strong>
		                <#elseif order.orderState==40>
		                	<strong><span style="color:#060">交易完成</span></strong>
		                <#elseif order.orderState==50>
		                	<strong>已提交，待确认</strong>
		                <#elseif order.orderState==60>
		                	<strong>已确认，待发货</strong>
		                </#if>
					</dd>
					<dt>订单编号：</dt>
					<dd>${order.orderSn}</dd>
					<dt>下单时间：</dt>
					<dd>${order.createTimeStr}</dd>
				</dl>
				<h3>订单信息</h3>
				<table class="ncu-table-style">
					<thead>
						<tr>
							<th class="w10"></th>
							<th class="w70"></th>
							<th>商品名称</th>
							<th>单价</th>
							<th>数量</th>
							<th>商品总价</th>
						</tr>
					</thead>
					<tbody>
					<#if order.orderGoodsList?size gt 0>
						<#list order.orderGoodsList as orderGoods>
						<tr class="bd-line">
							<td></td>
							<td>
								<div class="goods-pic-small">
									<span class="thumb size60">
										<i></i>
										<a target="_blank" href="${frontServer}/product/detail?id=${orderGoods.goodsId}">
											<img style="display: inline;" src="${imgServer}${orderGoods.goodsImage}" onload="javascript:DrawImage(this,60,60);">
										</a>
									</span>
								</div>
							</td>
							<td>
								<dl class="goods-name">
									<dt>
										<a href="${frontServer}/product/detail?id=${orderGoods.goodsId}" target="_blank">${orderGoods.goodsName}</a>
									</dt>
									<dd>${orderGoods.specInfo}</dd>
								</dl>
							</td>
							<td>
								<script type="text/javascript">
	              					var price = number_format(${orderGoods.goodsPrice},2);
	              					document.write(price);
	              				</script>
							</td>
							<td>${orderGoods.goodsNum}</td>
							<td>
								<script type="text/javascript">
	              					var goodsAmount = number_format(${orderGoods.goodsPrice}*${orderGoods.goodsNum},2);
	              					document.write(goodsAmount);
	              				</script>
							</td>
						</tr>
						</#list>
					</#if>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="20" class="transportation">支付金额：
								<b>¥
									<script type="text/javascript">
		              					var amount = number_format(${order.orderAmount},2);
		              					document.write(amount);
		              				</script>
								</b>
							</td>
						</tr>
						<tr>
						<td colspan="20" >
							<dt>商品总价：</dt>
							<dd>¥
							<script type="text/javascript">
              					var goodsamount = number_format(${order.goodsAmount},2);
              					document.write(goodsamount);
              				</script>
              				</dd>
              				<dt>余额支付金额：</dt>
							<dd>¥
							<script type="text/javascript">
              					var predepositAmount = number_format(${order.predepositAmount},2);
              					document.write(predepositAmount);
              				</script>
              				</dd>
              				<dt>运费价格：</dt>
							<dd>¥
							<script type="text/javascript">
              					var shippingFee = number_format(${order.shippingFee},2);
              					document.write(shippingFee);
              				</script>
              				</dd>
						</td>
						</tr>
					</tfoot>
				</table>
				<ul class="order_detail_list">
					<li>支付方式：${order.paymentName}</li>
					<li>下单时间：${order.createTimeStr?string('yyyy-MM-dd HH:mm:ss')}</li>
					<#if order.paymentTime??>
						<li>付款时间：${order.paymentTimeStr?string('yyyy-MM-dd HH:mm:ss')}</li>
					</#if>
					<#if order.orderMessage != null && order.orderMessage != ''>
	                    <li>买家附言：${order.orderMessage}</li>
	                </#if>
				</ul>
				
				<h3>物流信息</h3>
				<#if order.address??>
				<form action="#" id="addressForm">
					<input name="addressId" value="${order.address.addressId}" type="hidden"/>
					<dl class="logistics">
						<dt>收 货 人：</dt>
						<dd>
							<span id="trueNameSp">${order.address.trueName}</span>&nbsp;
							<input name="trueName" value="${order.address.trueName}" style="display: none;"/>
						</dd>
						<dt>手机号码：</dt>
						<dd>
							<span id="mobPhoneSp">${order.address.mobPhone}</span>&nbsp;
							<input name="mobPhone" value="${order.address.mobPhone}" style="display: none;"/>
						</dd>
						<dt class="cb">收货地址：</dt>
						<dd style="width: 90%;">
							<div id="region" style="display: none;">
	                        	<input id="city_id" type="hidden" name="cityId" value="">
								<input id="area_id" class="area_ids" type="hidden" name="areaId" value="">
								<input id="area_info" class="area_names" type="hidden" name="areaInfo" value="">
	                            <span id="spanarea">
							       	<select name="provinceId" id="area">
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
							<span id="areaInfoSp">${order.address.areaInfo}</span>&nbsp;&nbsp;
							<span id="addressSp">${order.address.address}</span>
							<input name="address" value="${order.address.address}" style="width: 200px;display: none;"/>
						</dd>
						<dt>邮编：</dt>
						<dd>
							<span id="zipCodeSp">${order.address.zipCode}</span>&nbsp;
							<input name="zipCode" value="${order.address.zipCode}" style="display: none; width: 100px;" />
							<a href="javascript:void(0)" id="update_address" class="ncu-btn2" onclick="updateAddress();">修改收货地址</a>
							<a href="javascript:void(0)" id="save_address" class="ncu-btn2" onclick="saveAddress();" style="display: none;">保存</a>
               				<a href="javascript:void(0)" id="cancel" class="ncu-btn2" onclick="cancel();" style="display: none;">取消</a>	
						</dd>
						<#if order.shippingCode??&&order.shippingCode!=''>
							<dt>物流单号：</dt>
							<dd>
								${order.shippingCode} 
								<a href="javascript:void(0)" onclick="kuaidi('${order.shippingCode}','${order.shippingExpressCode}')">查询物流</a>
							</dd>
						</#if>
					</dl>
				</form>
				</#if>
				<h3>发票信息</h3>
				<dl class="logistics">
					<dd>${order.invoice}</dd>
				</dl>
				<h3>操作历史</h3>
				<ul class="log-list">
				<#if order.orderLogList?size gt 0>
					<#list order.orderLogList as orderlog>
					<li><span class="operator"> ${orderlog.operator} </span> 于<span
						class="log-time">${orderlog.createTimeStr?string('yyyy-MM-dd HH:mm:ss')}</span> 订单当前状态：<span
						class="order-status">${orderlog.stateInfo}</span> 下一状态：
						<span class="order-status">
							<#if orderlog.changeState==0>
				            	订单已取消
			                <#elseif orderlog.changeState==10>
			                   	等待买家付款
			                <#elseif orderlog.changeState==20>
			                	等待卖家发货
			                <#elseif orderlog.changeState==30>
			                	卖家已发货
			                <#elseif orderlog.changeState==40>
			                	交易已完成
			                <#elseif orderlog.changeState==50>
			                	订单已提交
			                <#elseif orderlog.changeState==60>
			                	订单已确认
			                </#if>
						</span>
					</li>
					</#list>
				</#if>
				</ul>
				<#else>
					<dl>
						<b style="font-size: 2em;">请查看自己店铺下的订单</b>
					</dl>
				</#if>
			</div>
		</div>
	</div>
</div>
<@p.footer/>
<script>
	$(function(){
		formValidate();
		init_area('${order.address.provinceId}','${order.address.cityId}','${order.address.areaId}');
	});
	var timestamp=new Date().getTime();
	function kuaidi(shippingCode,expressCode){
		layer.open({
			type:2,
            move: false,
            shade: false,
            title: '物流查询',
            content:["http://wap.kuaidi100.com/wap_result.jsp?rand="+timestamp+"&id="+expressCode+"&fromWeb=null&&postid="+shippingCode, 'yes'],
            area: ['500px', '500px'],
		});
	} 
	
	jQuery.validator.addMethod("isMobPhone",function(value,element){
		var pattern = /^1\d{10}$/; //手机号格式
		return this.optional(element) || (pattern.test(value));  
	},"请填写正确的手机号");
	
	var formValidate = function(){
		$('#addressForm').validate({
		    errorPlacement: function(error, element){
		        $(element).next('.field_notice').hide();
		        $(element).after(error);
		    },
		    rules : {
		    	trueName : {
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
		        	required   : true
		        }
		    },
		    messages : {
		    	trueName : {
		    		required   : '请填写收货人姓名'
		    	},
		        mobPhone : {
					required : '请填写收货人手机',
					isMobPhone : '请填写正确的手机号'
		        },
		        address : {
		        	required   : '请填写收货地址'
		        },
		        zipCode : {
		        	required   : '请填写邮编'
		        }
		    }
		});
	}
	
	function saveAddress(){
		if($('#addressForm').valid()){
			//保存,取消链接标签设置为显示
			$("#save_address").attr("onclick","");
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
			var address = $("#addressForm").serialize();
			$.ajax({
	        	url:'${base}/trade/updateOrderAddress',
	            type:'post',
	            data : address,
	            dataType:'json',
	            success:function(data){
	            	if(data.result==1){
						layer.msg('保存成功', {icon: 1, time:500}, function(){
							location.reload();
						});
	            	}else{
	            		//保存,取消链接标签设置为显示
						$("#save_address").attr("onclick","saveAddress();");
	            	}
	            },error:function(){
	            	//保存,取消链接标签设置为显示
					$("#save_address").attr("onclick","saveAddress();");
	            	cancel();
	            	layer.msg('通信失败', {icon: 2});
	            }
	        });
		}
	}
	
	//修改收货地址
	function updateAddress(){
		//获取收货地址form表单下的所有input
		var transin = $("#addressForm").find("input");
		//获取收货地址form表单下的所有<em>
		var formems = $("#addressForm").find("em");
		//获取收货地址form表单下的所有<span>
		var formsp = $("#addressForm").find("span");
		//收货地址form表单下的所有input设置为显示
		transin.css("display","inline");
		//收货地址form表单下的所有<em>设置为显示
		formems.css("display","inline");
		//收货地址form表单下的所有<span>设置为隐藏
		formsp.css("display","none");
		//修改收货地址链接标签设置为隐藏
		$("#update_address").css("display","none");
		//保存,取消链接标签设置为显示
		$("#save_address").css("display","inline");
		//取消链接标签设置为显示
		$("#cancel").css("display","inline");
		//收货地区选择显示
		$("#region").css("display","inline");
		$("#region").find("span").css("display","inline");
	}
	
	//取消修改
	function cancel(){
		//获取收货地址form表单下的所有input
		var transin = $("#addressForm").find("input");
		//获取收货地址form表单下的所有<em>
		var formems = $("#addressForm").find("em");
		//获取收货地址form表单下的所有<span>
		var formsp = $("#addressForm").find("span");
		//获取收货地址form表单下的所有<label>
		var formlab = $("#addressForm").find("label");
		//收货地址form表单下的所有input设置为隐藏
		transin.css("display","none");		
		//收货地址form表单下的所有<em>设置为隐藏
		formems.css("display","none");
		//收货地址form表单下的所有<span>设置为显示
		formsp.css("display","inline");
		//修改收货地址链接标签设置为显示
		$("#update_address").css("display","inline");
		//保存,取消链接标签设置为隐藏
		$("#save_address").css("display","none");
		//取消链接标签设置为隐藏
		$("#cancel").css("display","none");
		//收货地区选择隐藏
		$("#region").css("display","none");
		//删除validation的错误label
		formlab.remove();
	}
</script>