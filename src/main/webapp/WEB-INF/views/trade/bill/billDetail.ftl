<@p.header title="结算详情"/>
<script type="text/javascript" src="${base}/res/js/layer/layer.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/jquery.validation.min.js"></script>
<script src="${base}/res/js/area.js" charset="utf-8"></script>
<div id="container" class="wrapper">
	<div class="layout">

		<div class="wrap-shadow">
			<div class="wrap-all ncu-order-view">
				<h2>结算详情</h2>
				<#if orderBill??>
				 <dl class="box"> 
				 	<dt>结算状态：</dt>
				 	<dd>
				 		<#if orderBill.obState==10>
				 			默认
				 		<#elseif orderBill.obState==20>
				 			商家已确认
				 		<#elseif orderBill.obState==30>
				 			平台已审核
				 		<#elseif orderBill.obState==40>
				 			结算完成
				 		</#if>
				 	</dd>
					<dt>结算编号：</dt>
					<dd>${orderBill.obNo}</dd>
					<dt>出账日期：</dt>
					<dd>${orderBill.createTimeStr?string('yyyy-MM-dd')}</dd>
					<dt>结算单年月份：</dt>
					<dd>${orderBill.osMonth}</dd>
					<#if orderBill.obPayTime??>
						<dt>付款日期：</dt>
						<dd>${orderBill.obPayTime?string('yyyy-MM-dd')}</dd>
					</#if>
					<#if orderBill.obPayContent??&&orderBill.obPayContent!=''>
						<dt>支付备注：</dt>
						<dd>${orderBill.obPayContent}</dd>
					</#if>
				</dl>
				<table class="ncu-table-style">
					<tfoot>
						<tr>
							<td colspan="20" class="transportation">应结金额：
							<b>¥
								<script type="text/javascript">
		           					var obResultTotals = number_format(${orderBill.obResultTotals},2);
		           					document.write(obResultTotals);
		           				</script>
							</b>
							</td>
						</tr>
						<tr>
							<td colspan="20" >
								<dt>订单金额：</dt>
								<dd>
									<script type="text/javascript">
			           					var obOrderTotals = number_format(${orderBill.obOrderTotals},2);
			           					document.write(obOrderTotals);
			           				</script>
		           				</dd>
		           				<dt>运费：</dt>
								<dd>
									<script type="text/javascript">
			           					var obShippingTotals = number_format(${orderBill.obShippingTotals},2);
			           					document.write(obShippingTotals);
			           				</script>
		           				</dd>
		           				<dt>佣金金额：</dt>
								<dd>
									<script type="text/javascript">
			           					var obCommisTotals = number_format(${orderBill.obCommisTotals},2);
			           					document.write(obCommisTotals);
			           				</script>
		           				</dd>
							</td>
						</tr>
						<tr>
							<td colspan="20" >
								<dt>促销活动费用：</dt>
								<dd>
									<script type="text/javascript">
			           					var obStoreCostTotals = number_format(${orderBill.obStoreCostTotals},2);
			           					document.write(obStoreCostTotals);
			           				</script>
		           				</dd>
		           				<#if orderBill.obOrderReturnTotals??>
			           				<dt>退单金额：</dt>
									<dd>
										<script type="text/javascript">
				           					var obOrderReturnTotals = number_format(${orderBill.obOrderReturnTotals},2);
				           					document.write(obOrderReturnTotals);
				           				</script>
			           				</dd>
		           				</#if>
		           				<#if orderBill.obCommisReturnTotals??>
			           				<dt>退还佣金：</dt>
									<dd>
										<script type="text/javascript">
			           					var obCommisReturnTotals = number_format(${orderBill.obCommisReturnTotals},2);
			           					document.write(obCommisReturnTotals);
			           				</script>
			           				</dd>
		           				</#if>
							</td>
						</tr>
					</tfoot>
				</table>
				<#else>
					<dl>
						<b style="font-size: 2em;">请查看自己店铺下的结算信息</b>
					</dl>
				</#if>
			</div>
		</div>
	</div>
</div>
<@p.footer/>