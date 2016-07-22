<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<link href="${base}/res/css/seller_center.css" rel="stylesheet" type="text/css"/>
<style type="text/css">
body { background: #FFF none;
}
</style>
<script type="text/javascript" src="${base}/res/js/jquery.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/common.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/jquery.poshytip.min.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/jquery.printarea.js" charset="utf-8"></script>
<title>打印发货单</title>
</head>

<body>
<div class="print-layout">
  <div class="print-btn" id="printbtn" title="选择喷墨或激光打印机<br/>根据下列纸张描述进行<br/>设置并打印发货单据">
  	<i></i><a href="javascript:void(0);">打印</a>
  </div>
  <div class="a5-size"></div>
  <dl class="a5-tip">
    <dt>
      <h1>A5</h1>
      <em>Size: 210mm x 148mm</em></dt>
    <dd>当打印设置选择A5纸张、横向打印、无边距时每张A5打印纸可输出1页订单。</dd>
  </dl>
  <div class="a4-size"></div>
  <dl class="a4-tip">
    <dt>
      <h1>A4</h1>
      <em>Size: 210mm x 297mm</em></dt>
    <dd>当打印设置选择A4纸张、竖向打印、无边距时每张A4打印纸可输出2页订单。</dd>
  </dl>
  <div class="print-page">
    <div id="printarea">
	    <div class="orderprint">
		    <div class="top">
		    	<div class="full-title">
		    		<#if order??>${order.storeName} 发货单</#if>
		    	</div>
		    </div>
		    <#if order??>
			    <table class="buyer-info">
		          <tr>
		            <td class="w200">收货人：${order.address.trueName }</td>
		            <td>电话：${order.address.mobPhone }</td>
		            <td></td>
		          </tr>
		          <tr>
		            <td colspan="3">地址：${order.address.address }</td>
		          </tr>
		          <tr>
		            <td>订单号：${order.orderSn}</td>
		            <td>下单时间：${order.createTimeStr}</td>
		            <td></td>
		          </tr>
	        	</table>
		        <table class="order-info">
		          <thead>
		            <tr>
		              <th class="w40">序号</th>
		              <th class="tl">商品名称</th>
		              <th class="w70 tl">单价(元)</th>
		              <th class="w50">数量</th>
		              <th class="w70 tl">小计(元)</th>
		            </tr>
		          </thead>
		          <tbody>
		          <#assign totalNum =0 >
		          	<#if order.orderGoodsList?size gt 0>
						<#list order.orderGoodsList as orderGoods>
				         	 <tr>
				              <td>${orderGoods_index+1}</td>
				              <td class="tl">${orderGoods.goodsName}</td>
				              <td class="tl">&yen;
					              <script type="text/javascript">
		              					var price = number_format(${orderGoods.goodsPrice},2);
		              					document.write(price);
	              				  </script>
              				  </td>
				              <td>
				              ${orderGoods.goodsNum}	
				              </td>
				              <td class="tl">&yen;
				               	  <script type="text/javascript">
						               	var goodsAmount = number_format(${orderGoods.goodsPrice}*${orderGoods.goodsNum},2);
		              					document.write(goodsAmount);
	              				  </script>		
				              </td>
				             </tr>
				             <#assign totalNum = totalNum + orderGoods.goodsNum >
			            </#list>
					</#if>
		             <tr>
		              <th></th>
		              <th colspan="2" class="tl">合计</th>
		              <th>${totalNum}</th>
		              <th class="tl">&yen;
		              	<script type="text/javascript">
	          					var goodsamount = number_format(${order.goodsAmount},2);
	          					document.write(goodsamount);
	            		  </script>
		              </th>
		             </tr>
		          </tbody>
		          <tfoot>
		            <tr>
		              <th colspan="10">
		              <span>商品总计：&yen;
			              <script type="text/javascript">
	          					var goodsamount = number_format(${order.goodsAmount},2);
	          					document.write(goodsamount);
	            		  </script>
            		  </span>
		              <span>运费：&yen;
	              			<script type="text/javascript">
             					var shippingFee = number_format(${order.shippingFee},2);
             					document.write(shippingFee);
             				</script>
		              </span>
		              <!-- <span>优惠：&yen;0</span> -->
		              <span>订单总额：&yen;
		              		<script type="text/javascript">
             					var orderTotalPrice = number_format(${order.orderTotalPrice},2);
             					document.write(orderTotalPrice);
             				</script>
		              </span>
		              <span>应付金额：&yen;
			              <script type="text/javascript">
	             					var orderAmount = number_format(${order.orderAmount},2);
	             					document.write(orderAmount);
	             		  </script>
		              </span>
		              <span>店铺：${order.storeName}</span>
		              </th>
		            </tr>
		          </tfoot>
		        </table>
		        <div class="explain"> </div>
		        <div class="tc page">第1页/共1页</div>
	        </#if>
	    </div>
  	</div>
  </div>
</div>
</body>
<script>
$(function(){
	$("#printbtn").click(function(){
	$("#printarea").printArea();
	});
});

//打印提示
$('#printbtn').poshytip({
	className: 'tip-yellowsimple',
	showTimeout: 1,
	alignTo: 'target',
	alignX: 'center',
	alignY: 'bottom',
	offsetY: 5,
	allowTipHover: false
});
</script>
</html>