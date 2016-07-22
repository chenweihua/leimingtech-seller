<@p.header title="商家中心-订单管理"/>
<script type="text/javascript" src="${base}/res/js/common_select.js"charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/ajaxfileupload/ajaxfileupload.js"></script>
<script type="text/javascript" src="${base}/res/js/layer/layer.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/My97DatePicker/WdatePicker.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/area_array.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/common.js" charset="utf-8"></script>
<link href="${base}/res/css/home_cart.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
    $(function () {
        // 选择分类搜索后回显搜索的分类
        <#if gcidpath!''>
            var firstLevel = '${firstLevel}';
            var secondLevel = '${secondLevel}';
            var threeLevel = '${threeLevel}';
            var newOption = "";
            <#list classList as gc>
                newOption += "<option value='${gc.gcId}'' <#if firstLevel == gc.gcId> selected='selected' </#if> >${gc.gcName}</option>";
            </#list>
            $(".querySelect").prepend(newOption);
            loadSelectCategory(secondLevel, threeLevel, $(".querySelect"));
            loadSelectCategory(firstLevel, secondLevel, $(".querySelect"));
        </#if>
        gcategoryInit("gcategory");
    });

</script>
<div class="layout">
	<div class="sidebar"></div>
  	<div class="right-content">
        <div class="path">
	        <div>
	        	<a href="${base}">商家中心</a> <span>></span>
	            <a href="#?act=store&op=store_order"/>
	            	采购
	            </a>
	            <span></span>
	        </div>
        </div>
        
        <div class="main">
			<div class="wrap">
				<form method="post" action="${base}/trade/purchaseList" target="_self" id="queryForm">
				  <table class="search-form">
				    <!--<input type="hidden" name="pageNo" value="${pager.pageNo}">-->
				    <tr>
				      <th>商品名称：</th>
				      <td class="w100"><input type="text" class="text" value="${goods.goodsName}" name="goodsName" id="search_goods_name"  /></td>
				      <th>商品货号：</span></th>
				      <td class="w100"><input type="text" class="text" value="${goods.goodsSerial}" name="goodsSerial" id="search_commonid" /></td>
				      <th><label>分类：</label></th>
		                <td id="gcategory" colspan="8"><input type="hidden" id="cate_id" name="gcId" value="" class="mls_id"/>
		                    <input type="hidden" id="cate_id" name="gcId" value="" class="mls_id"/>
		                    <input type="hidden" id="cate_name" name="gcName" value="" class="mls_names"/>
		                    <select class="querySelect">
		                        <#if gcidpath!''>
		                        <#else>
		                            <option value="0">请选择...</option>
		                            <#list classList as gc>
		                                <option value="${gc.gcId}" <#if goodsGcId == gc.gcId>
		                                        selected="selected" </#if> >${gc.gcName}</option>
		                            </#list>
		                        </#if>
		                    </select>
		                    <!--  <select class="class="querySelect"">
		                    <option value="0">请选择...</option>
		                    <#list classList as gc>
		                        <option value="${gc.gcId}">${gc.gcName}</option>
		                    </#list>
		                    </select>-->
		                </td>
				      <td class="w90 tc"><input type="submit"  class="submit"value="搜索" /></td>
				    </tr>
				    <tr>
                <th><label>品牌：</label></th>
                <td>
                    <select name="brandId">
                        <option value="">请选择...</option>
                        <#list brandList as brand>
                            <option value="${brand.brandId}"
                                    <#if goods.brandId == brand.brandId>selected="selected" </#if>>${brand.brandName}</option>
                        </#list>
                    </select>
                </td>
                <td><a href="javascript:void(0);" id="ncsubmit" class="btn-search " title="查询">&nbsp;</a></td>
                <td class="w120">&nbsp;</td>
            </tr>
				  </table>
				</form>
			  	<table class="ncu-table-style order">
				  	<thead>
				  		<tr>
				    		<th class="w10"></th>
				    		<th colspan="2">商品详情</th>
				    		<th class="w70">单价(元)</th>
				    		<th class="w50">数量</th>
				    		<th class="w110">操作</th>
				  		</tr>
				   	</thead>
			   		
			    	<tbody>
			    	<#if pager.result??>
			  		<#list pager.result as goods>
			      		<tr>
			       	 		<td colspan="20" class="sep-row"></td>
			      		</tr>
					    <tr id="cart_item_${goods.goodsId}">
					        <td class="bdl"></td>
					        <td class="w70">
					        	<div class="goods-pic-small">
						        	<span class="thumb size60"><i></i>
							        	<a href="${frontServer}/product/detail?id=${goods.goodsId}" target="_blank">
							        		<img src="${imgServer}${goods.goodsImage}" onload="javascript:DrawImage(this,60,60);"/>
							        	</a>
						        	</span>
					        	</div>
					        </td>
					        <td class="w70"><!--<td class="t1">-->
					        	<dl class="goods-name">
						            <dt><a target="_blank" href="${frontServer}/product/detail?id=${goods.goodsId}">${goods.goodsName}</a></dt>
						            <dd>品牌&分类：${goods.brandName}｜${goods.gcName}</dd>
					            </dl>
					        </td>
						    <td>
						    	<script type="text/javascript">
				              					var price = number_format(${goods.goodsStorePrice},2);
				              					document.write("&yen;" + price);
				              	</script>
						    </td>
						    <td>
						    <a href="JavaScript:void(0);" onclick="decrease_quantity('${goods.goodsId}');" title="减少" class="subtract">&nbsp;</a>
				            <input id="input_item_${goods.goodsId}" name="goodsNum" value="1" orig="1" changed="1" onkeyup="change_quantity('${cart.goodsPrice}','${cartVo.storeId}','${cart.cartId}','${cart.specId}', this);" class="text1  vm" type="text"  style="width:30px; *float: left;text-align: center;"/>
				            <a href="JavaScript:void(0);" onclick="add_quantity('${goods.goodsId}');" title="增加" class="adding" >&nbsp;</a>
						    </td>
						    <td>
						    	<p><a href="javascript:buy('${goods.goodsId}','${goods.specId}');">加入购物车</a></p>
						    </td>
					    </tr>
					</#list> 
					</#if> 
					</tbody>	
				    <tfoot>
				    	<tr>
					        <td colspan="20">
					        	<#import "/trade/page.ftl" as q><!--引入分页-->
				                <#if recordCount??>
				                    <@q.pager pageNo=pageNo pageSize=pageSize recordCount=recordCount toURL="${toUrl}"/>
				                </#if>
					        </td>
				    	</tr>
					</tfoot>
			  </table>
			  <iframe name="seller_order" style="display:none;"></iframe>
			</div>
    	</div>
    </div>
    <div class="clear"></div>
</div>
<link rel="stylesheet" type="text/css" href="${base}/res/js/jquery-ui/themes/ui-lightness/jquery.ui.css"  />
<script type="text/javascript">
$(function(){
    $('.checkall_s').click(function(){
        var if_check = $(this).attr('checked');
        $('.checkitem').each(function(){
            if(!this.disabled)
            {
                $(this).attr('checked', if_check);
            }
        });
        $('.checkall_s').attr('checked', if_check);
    });
});

function change_quantity(goods_price, store_id, cart_id, spec_id, input){
		//$(input).parents("tr").find("input[name='secondpro']").attr("checked",true);
		//selectBox();
		
	    var subtotal_span = $('#item' + cart_id + '_subtotal');
	    var amount_span = $('#cart_amount');
	    //暂存为局部变量，否则如果用户输入过快有可能造成前后值不一致的问题
	    var count = input.value;
	    if(!isPositiveNum(count)){
	    	layer.msg("请填写正确的数字",{icon:2});
	    	$(input).val(1);
	    	return false;
	    }
	    //if(count<0 || count>100){
	    	//layer.msg("商品最大购买量在0-100之间",{icon:2});
	    	//$(input).val(100);
	    	//return false;
	    //}
	    //省略异步获取库存
}
function decrease_quantity(cart_id){
	    var item = $('#input_item_' + cart_id);
	    
	    var orig = Number(item.val());
	    if(orig > 1){
	        item.val(orig - 1);
	        item.keyup();
	    }
	}
	function add_quantity(cart_id){
	    var item = $('#input_item_' + cart_id);
	    
	    var orig = Number(item.val());
	    if(orig < 100){
	    	item.val(orig + 1);
	    	item.keyup();
	    }
	}
	
function isPositiveNum(s){//是否为正整数  
	   var re = /^[0-9]*[1-9][0-9]*$/ ;  
	   return re.test(s)  
} 

// 商品规格选择js部分
var SITE_URL = "${base}";
function buy(goodsId,specId){
	var ncspec = $(".nc-spec").find("dl").html(); //判断商品是否存在规格
    //var goodsId = $("#goodsId").val(); //商品id
    //var num = $(input);
    var input = $('#input_item_' + goodsId);
    var goodsNum = input.val();//parseInt($("#quantity").val()); //商品数量
    //var specId = $("#goodsSpecId").val(); //商品规格id
    //if (typeof(ncspec) == "undefined"){ //若商品没有规格,则将默认规格值存入
    	//specId = ${goods.specId};
    //}
    if(!isPositiveNum(goodsNum)){
    	layer.msg("请填写正确的购买数量" , {icon:2,time:1000});
        input.val(1);
        return;
    }
    //max = parseInt($('[nctype="goods_stock"]').text());
    //if(goodsNum > max){
    	//layer.msg("库存不足,请您重新选择商品数量" , {icon:2,time:1000});
    	//return;
    //}
    if(specId != ''){
    	$.ajax({
	    	url : "${base}/cart/saveCart",
	        type : 'post',
	        data : {'goodsId' : goodsId,'count' : goodsNum, 'specId' : specId},
	        dataType : 'json',
	        success : function(data){
	        	if(data.success=='true'){
	        		layer.msg("加入购物车成功",{icon:1,time:1000});
	        		//var num = $(".addcart-goods-num").html(); //右侧购物车原有数量
	        		//更新购物车数量
	        		//$(".addcart-goods-num").html(goodsNum*10/10+num*10/10);
	        	}else{
	        		layer.msg(data.msg,{icon:2,time:1000});
	        	}
	        }
	    });
    }else{
    	layer.msg("请选择商品规格",{icon:2,time:1000});
    }
   	
}
/**取消订单**/
function cancelOrder(id) {
   	layer.open({
	    type: 2,
	    area: ['500px', '300px'],
	    skin: 'layui-layer-rim',
	    title: '取消订单',
	    //content: APP_BASE + '/cart/addresslist'
	    content :  ['${base}/trade/cancelOrderIndex?orderSn=' + id, 'no'],
	    success: function(layero, index){
	    	layer.getChildFrame('#confirm_button',index).on('click', function(){
				var orderSn=layer.getChildFrame("#orderSn",index).val();
				var cancelCause=layer.getChildFrame("#other_reason_input",index).val();
				if(cancelCause==''){
					layer.getChildFrame("#error").html("请填写取消原因");
					return false;
				}
				var fmUrl = '${base}/trade/cancelOrder';
				$.ajax({
		             type: "post",
		             url: fmUrl,
		             data: {orderSn:orderSn,cancelCause:cancelCause},
		             dataType: "json",
					 async:false,
					 success:function(data) {
						if(data.success){
							parent.layer.alert("订单取消成功",{icon:1},function(){
								location.reload();
							});	
						}else{
							parent.layer.alert("订单取消失败",{icon:2},function(){
								location.reload();
							});		
						}
					}
		         }); 
			});	
	    }
	});
}

/**调整费用**/
function updateAmount(id) {
   	layer.open({
	    type: 2,
	    area: ['400px', '200px'],
	    skin: 'layui-layer-rim',
	    title: '调整订单费用',
	    //content: APP_BASE + '/cart/addresslist'
	    content :  ['${base}/trade/updateAmountIndex?orderId=' + id, 'no'],
	    success: function(layero, index){
	    	layer.getChildFrame('#confirm_button',index).on('click', function(){
				var orderId=layer.getChildFrame("#orderId",index).val();
				var orderAmount=layer.getChildFrame("#orderAmount",index).val();
				var fmUrl = '${base}/trade/updateAmount';
				$.ajax({
		             type: "post",
		             url: fmUrl,
		             data: {orderId:orderId,orderAmount:orderAmount},
		             dataType: "json",
					 async:false,
					 success:function(data) {
						if(data.success){
							parent.layer.msg("订单修改成功",{icon:1},function(){
								location.reload();
							});	
						}else{
							parent.layer.msg("订单修改失败",{icon:2},function(){
								location.reload();
							});		
						}
					}
		         });  
			});	
	    }
	});
}

/**确认订单**/
function confirmOrder(id) {
   	layer.open({
	    type: 2,
	    area: ['400px', '200px'],
	    skin: 'layui-layer-rim',
	    title: '订单确认',
	    //content: APP_BASE + '/cart/addresslist'
	    content :  ['${base}/trade/confirmOrderIndex?orderId=' + id, 'no'],
	    success: function(layero, index){
	    	layer.getChildFrame('#confirm_button',index).on('click', function(){
				var orderSn=layer.getChildFrame("#orderSn",index).val();
				var fmUrl = '${base}/trade/confirmOrder';
				$.ajax({
		             type: "post",
		             url: fmUrl,
		             data: {orderSn:orderSn},
		             dataType: "json",
					 async:false,
					 success:function(data) {
						if(data.success){
							parent.layer.msg("订单确认成功",{icon:1},function(){
								location.reload();
							});	
						}else{
							parent.layer.msg("订单确认失败",{icon:2},function(){
								location.reload();
							});		
						}
					}
		         });  
			});	
	    }
	});
}

/**退款审核**/
function refund(id) {
   	layer.open({
	    type: 2,
	    area: ['500px', '400px'],
	    skin: 'layui-layer-rim',
	    title: '退款审核',
	    //content: APP_BASE + '/cart/addresslist'
	    content :  ['${base}/trade/refundOrderIndex?logId=' + id, 'no'],
	    success: function(layero, index){
	    	layer.getChildFrame('#confirm_button',index).on('click', function(){
				var logId=layer.getChildFrame("input[name='logId']",index).val();
				var refundState = layer.getChildFrame("input[name='refund_state']:checked",index).val();
				var refundMessage = layer.getChildFrame("textarea[name='refund_message']",index).val();
				alert(refundMessage);
				var fmUrl = '${base}/trade/refundOrder';
				$.ajax({
		             type: "post",
		             url: fmUrl,
		             data: {logId:logId,refundState:refundState,refundMessage:refundMessage},
		             dataType: "json",
					 async:false,
					 success:function(data) {
						if(data.success){
							parent.layer.msg("审核成功!",{icon:1},function(){
								location.reload();
							});	
						}else{
							parent.layer.msg("审核失败!",{icon:2},function(){
								location.reload();
							});		
						}
					}
		         });  
			});	
	    }
	});
}
</script>
</body>
</html>
<@p.footer/>