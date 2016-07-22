<@p.userHeader title="发货"/>
<script type="text/javascript" src="${base}/res/js/nc-sideMenu.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/utils.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/layer/layer.js" charset="utf-8"></script>
<link href="${base}/res/css/font-icons/style.css"  rel="stylesheet" />
<div id="container" class="wrapper">
	<div class="layout">
    	<@u.left/>
    	<div class="right-content"> 
      		<div class="path">
        		<div>
        			<a href="${base}">我的商城</a><span>&raquo;</span>
                    <a href="${base}/user/returnList"/>退货申请</a><span>&raquo;</span>
                   	发货
                </div>
      		</div>
      		<div class="main">
       			<link rel="stylesheet" type="text/css" href="${base}/res/js/jquery-ui/themes/ui-lightness/jquery.ui.css"  />
				<style type="text/css">
				.store-name {
					width: 130px;
					display: inline-block;
					overflow: hidden;
					white-space: nowrap;
					text-overflow: ellipsis;
				}
				</style>
				<div class="wrap">
  					<div class="tabmenu">
    					<ul class="tab pngFix">
  							<li class="active"><a  href="#">发货</a></li>
  						</ul>
  					</div>
  					<#if refundReturn??>
  					<#if refundReturn.goodsState?? && refundReturn.goodsState==1>
	  					<table class="ncu-table-style">
	  						<input name="refundId" value="${refundReturn.refundId}" type="hidden"/>
							<thead>
								<tr>
									<th class="w10"></th>
									<th class="w70"></th>
									<th>商品名称</th>
									<th>退款金额</th>
									<th>退货数量</th>
								</tr>
							</thead>
							<tbody>
								<input name="goodsId" value="${refundReturn.orderGoodsId}" type="hidden"/>
								<tr class="bd-line">
									<td></td>
									<td>
										<div class="goods-pic-small">
											<span class="thumb size60">
												<i></i>
												<a target="_blank" href="${base}/product/detail?id=${refundReturn.goodsId}">
													<img style="display: inline;" src="${imgServer}${refundReturn.goodsImage}" onload="javascript:DrawImage(this,60,60);">
												</a>
											</span>
										</div>
									</td>
									<td>
										<dl class="goods-name">
											<dt>
												<a href="${base}/product/detail?id=${refundReturn.goodsId}" target="_blank">${refundReturn.goodsName}</a>
											</dt>
											<#-- <dd>${returnGoods.specInfo}</dd> -->
										</dl>
									</td>
									<td>
										<script type="text/javascript">
			              					var price = number_format(${refundReturn.refundAmount},2);
			              					document.write(price);
			              				</script>
									</td>
									<td class="w150 bdl bdr" id="goodsNum">${refundReturn.goodsNum}</td>
								</tr>
							</tbody>
						</table>
						<div class="wrap-shadow">
							<div class="wrap-all ncu-order-view"> 
								<dl>
							    	<dt>图片信息：</dt>
				                	<table>
				                		<tr>
				                			<td><ul class="img_ul" id="return_img"></ul></td>
				                			<td>
				                				<#if refundReturn.picInfo!=''>
											     	<#list refundReturn.picInfo?split(',') as img>
											     		<#if img!=''>
											     			<img width="80px" height="80px" src="${imgServer}${img}"/>
											     		</#if>
											     	</#list>
										     	</#if>
				                			</td>
				                		</tr>
				                	</table>
				                </dl>
				                <dl>
				                	<dt>退货原因：</dt>
		    						<dd>${refundReturn.buyerMessage}</dd>
				                </dl>
								<dl>
							      <dt class="required"><em class="pngFix"></em>审核备注：</dt>
							      <dd>${refundReturn.sellerMessage}</dd>
							    </dl>
							    <h3>完善发货信息</h3>
							    <div class="step-title mt30"><em>卖家收货地址</em></div>
							    <#if refundReturn.orderDaddress??>
									<dl class="logistics">
										<dt>发 货 人：</dt>
										<dd>${refundReturn.orderDaddress.sellerName}&nbsp;</dd>
										<dt>联系电话：</dt>
										<dd>${refundReturn.orderDaddress.mobPhone}&nbsp;</dd>
										<dt>邮编：</dt>
										<dd>${refundReturn.orderDaddress.zipCode}&nbsp;</dd>
										<dt class="cb">发货地址：</dt>
										<dd style="width: 90%;">${refundReturn.orderDaddress.areaInfo}&nbsp;${refundReturn.orderDaddress.address}</dd>
									</dl>
								</#if>
								<div class="ncm-notes">
	    							<i class="lightbulb"></i>
	    							请安以上提供收货地址发货后,填写以下发货信息
								</div>
							    <dl>
							      <dt class="required"><em class="pngFix"></em>配送公司：</dt>
							      <dd>
							      	<#-- <select name="shippingExpressId" style="height: 30px;" class="text w150 tip-r">
								      	<#if expressList??>
								      		<#list expressList as express>
								      			<option value="${express.id}">${express.seName}</option>
								      		</#list>
								      	</#if>
								     </select> -->
								     <input name="shippingExpressName" type="text" style="height: 17px;" class="text w100 tip-r"/>
							      </dd>
							    </dl>
							    <dl>
							      <dt class="required"><em class="pngFix"></em>物流单号：</dt>
							      <dd><input name="shippingCode"  type="text" style="height: 17px;" class="text w200 tip-r"/></dd>
							    </dl>
							    <dl class="bottom">
							      <dt>&nbsp;</dt>
							      <dd>
							        <input type="submit" class="submit" id="confirm_button" name="confirm_button" value="确定">
							      </dd>
							    </dl>
						</div>
						</div>
						<#else>
							<div class="wrap-shadow">
								<div class="wrap-all ncu-order-view"> 
									<p style="font-size: 30px;">您的订单已完成操作</p>
								</div>
							</div>
					</#if>
					<#else>
						<div class="wrap-shadow">
							<div class="wrap-all ncu-order-view"> 
								<p style="font-size: 30px;">请勿查看其它用户信息</p>
							</div>
						</div>
					</#if>
				</div>
  			</div>
  		</div>
  	</div>
</div>
<script type="text/javascript">
	$(function(){
		
		$("#confirm_button").click(function(){
			var reg = /^[-\+]?\d+(\.\d+)?$/; //检验是否为数字的正则表达式
			var refundId = $("input[name='refundId']").val();
			//var expressId = $("[name=shippingExpressId]").val();
			var invoiceNo = $("input[name='shippingCode']").val();
			var expressName = $("input[name='shippingExpressName']").val();
			if(invoiceNo==""){
				layer.msg("请您填写物流单号!",{icon:2});
				return false;
			}
			if(expressName==""){
				layer.msg("请您填写配送公司!",{icon:2});
				return false;
			}
			
			var fmUrl = '${base}/user/refundReturnDelivery';
			$.ajax({
	             type: "post",
	             url: fmUrl,
	             data: {refundId:refundId,expressName:expressName,invoiceNo:invoiceNo},
	             dataType: "json",
				 success:function(data) {
					if(data.success){
						layer.alert("发货成功",{icon:1},function(){
							location.href="${base}/user/returnList";
						});	
					}else{
						layer.alert("发货失败",{icon:2},function(){
							layer.closeAll();
						});		
					}
				}
	         });
		});
	});
</script>
<@p.userfooter/>