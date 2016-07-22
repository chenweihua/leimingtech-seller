<@p.userHeader title="退货详情"/>
<script type="text/javascript" src="${base}/res/js/nc-sideMenu.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/utils.js" charset="utf-8"></script>
<!-- 步骤条js -->
<link href="${base}/res/css/font-icons/style.css"  rel="stylesheet" />
<!-- 步骤条样式 -->
<div id="container" class="wrapper">
	<div class="wrap-shadow">
		<div class="wrap-all ncu-order-view"> 
			<h2>退货详情</h2>
			<dl class="box">
				<dt>审核状态：</dt>
				<dd>
	                <#if refundReturn.sellerState==1>
                    	<strong><span style="color:#F30">待审核</span></strong>
	                <#elseif refundReturn.sellerState==2>
	                    <strong><span style="color:#F30">同意</span></strong>
	                <#elseif refundReturn.sellerState==3>
	                	<strong><span style="color:#F30">不同意</span></strong>
	                </#if>
				</dd>
				<dt>平台确认：</dt>
				<dd>
					<#if refundReturn.refundState??>
						<#if refundReturn.refundState==1>
							<strong><span style="color:#36C">未申请</span></strong>
						<#elseif refundReturn.refundState==2>
							<strong><span style="color:#36C">待处理</span></strong>
						<#elseif refundReturn.refundState==3>
							<strong><span style="color:#36C">已完成</span></strong>
						</#if>
					<#else>
						无
					</#if>
				</dd>
				<dt>退货编号：</dt>
				<dd>${refundReturn.refundSn}</dd>
				<dt>申请时间：</dt>
				<dd>${refundReturn.createTimeStr}</dd>
			</dl>
			<h3>退货信息</h3>
			<table class="ncu-table-style">
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
								<#-- <dd>${refundReturn.specInfo}</dd> -->
							</dl>
						</td>
						<td>
							<script type="text/javascript">
              					var price = number_format(${refundReturn.refundAmount},2);
              					document.write(price);
              				</script>
						</td>
						<td>${refundReturn.goodsNum}</td>
					</tr>
				</tbody>
			</table>
			<ul class="order_detail_list">
				<li>
					退货原因：${refundReturn.buyerMessage}
				</li>
				<li>
					店铺名称：${refundReturn.storeName}
				</li>
				<#if refundReturn.picInfo!=''>
					<li>
						图片信息：
						<#list refundReturn.picInfo?split(',') as img>
				     		<#if img!=''>
				     			<img width="80px" height="80px" src="${imgServer}${img}"/>
				     		</#if>
				     	</#list>
					</li>
				</#if>
				<#if refundReturn.sellerMessage??>
					<li>
						卖家备注：${refundReturn.sellerMessage}
					</li>
				</#if>
				<#if refundReturn.adminMessage??>
					<li>
						管理员备注：${refundReturn.adminMessage}
					</li>
				</#if>
			</ul>
			<h3>发货信息</h3>
			<#if refundReturn.orderDaddress??>
				<dl class="logistics">
					<dt>发&nbsp; 货 &nbsp;人：</dt>
					<dd>${refundReturn.orderDaddress.sellerName}&nbsp;</dd>
					<dt>联系电话：</dt>
					<dd>${refundReturn.orderDaddress.mobPhone}&nbsp;</dd>
					<dt>邮&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;编：</dt>
					<dd>${refundReturn.orderDaddress.zipCode}&nbsp;</dd>
					<dt class="cb">发货地址：</dt>
					<dd style="width: 90%;">${refundReturn.orderDaddress.areaInfo}&nbsp;${refundReturn.orderDaddress.address}</dd>
					<#if refundReturn.expressName??>
						<dt>配送公司：</dt>
						<dd>${refundReturn.expressName}&nbsp;</dd>
					</#if>
					<#if refundReturn.invoiceNo??>
						<dt>物流单号：</dt>
						<dd>${refundReturn.invoiceNo}&nbsp;</dd>
					</#if>
				</dl>
			</#if>
			<h3>操作历史</h3>
			<ul class="log-list">
				<#if refundReturn.returnLogList?size gt 0>
					<#list refundReturn.returnLogList as returnLog>
						<li>
						<span class="operator"> ${returnLog.operator} </span>
						<span class="log-time">${returnLog.createTimeStr}</span>
						<span >${returnLog.stateInfo}</span>
						</li>
					</#list>
				</#if>
			</ul>
		</div>
	</div>
</div>
<@p.userfooter/>
<script type="text/javascript">
</script>