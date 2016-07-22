<@p.header title="商家中心-退货审核"/>
<script type="text/javascript" src="${base}/res/js/common_select.js"
	charset="utf-8"></script>
<script type="text/javascript"
	src="${base}/res/js/ajaxfileupload/ajaxfileupload.js"></script>
<script type="text/javascript" src="${base}/res/js/layer/layer.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/My97DatePicker/WdatePicker.js" charset="utf-8"></script>	 
<div class="layout">
	<div class="sidebar"></div> 
	<div class="right-content">
        <div class="path">
      		<div>
      			<a href="#">商家中心</a> <span></span>
                <a href="#"/>退货记录 </a><span></span>
                	退货审核            
            </div>
    	</div>
        <div class="main">
			<div class="wrap">
  				<div class="tabmenu">
    				<ul class="tab pngFix">
  						<li class="active"><a  href="#">退货审核</a></li>
  					</ul>
  				</div>
  				<#if refundReturn??>
  				<input name="refundId" value="${refundReturn.refundId}" type="hidden"/>
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
										<a href="${frontServer}/product/detail?id=${refundReturn.goodsId}" target="_blank">${refundReturn.goodsName}</a>
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
					      <dd style="width:320px">
					        <textarea name="return_message" class="textarea w300" rows="5"></textarea>
					      </dd>
					    </dl>
					    <dl class="bottom">
					      <dt>&nbsp;</dt>
					      <dd>
					        <input type="submit" class="submit" onclick="returnOrder(2)" value="同意">
					      </dd>
					      <dd>
					      	<input type="submit" class="submit" onclick="returnOrder(3)" value="拒绝">
					      </dd>
					    </dl>
					</div>
				</div>
				<#else>
					<div class="wrap-shadow">
						<div class="wrap-all ncu-order-view"> 
							<p style="font-size: 30px;">您的订单已申请退货</p>
						</div>
					</div>
				</#if>
  			</div>
  		</div>
  	</div>
</div>
<script type="text/javascript">
	function returnOrder(sellerState){
		var refundId=$("input[name='refundId']").val();
		var sellerMessage = $("textarea[name='return_message']").val();
		var fmUrl = '${base}/trade/refundReturn';
		$.ajax({
             type: "post",
             url: fmUrl,
             data: {refundId:refundId,sellerState:sellerState,sellerMessage:sellerMessage},
             dataType: "json",
			 async:false,
			 success:function(data) {
				if(data.success){
					layer.msg("审核成功!",{icon:1},function(){
						location.href="${base}/trade/returnOrderList";
					});	
				}else{
					layer.msg("审核失败!",{icon:2},function(){
						layer.closeAll();
					});		
				}
			}
         });   
	}
			
</script>