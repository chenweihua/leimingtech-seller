<@p.header title="商家中心-退货记录"/>
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
      			<a href="${base}/">商家中心</a> <span>></span>
                <a href="#"/>退货记录 </a><span>></span>
                	退货记录             
            </div>
    	</div>
        <div class="main">
			<div class="wrap">
  				<div class="tabmenu">
    				<ul class="tab pngFix">
  						<li class="active"><a  href="#">退货记录</a></li>
  					</ul>
  				</div>
  				<form method="get" action="${base}/trade/returnOrderList" id="queryForm">
    				<table class="search-form">
      					<input type="hidden" name="act" value="return" />
      					<tr>
        					<td>&nbsp;</td>
					        <th style="width:115px">
					        	<select name="type">
					            	<option value="orderSn" >订单编号</option>
					            	<option value="returnSn" >退货编号</option>
					            	<option value="buyerName" >买家会员名</option>
					          	</select>：
					        </th>
        					<td class="w160"><input type="text" class="text" name="key" value="" /></td>
        					<th>退货时间：</th>
        					<td class="w260">
        						<input name="startTime"  type="text" class="txt Wdate" value="${startTime}" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'});" />&#8211;
          						<input name="endTime" type="text" class="txt Wdate" value="${endTime}" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'});" />
         					</td>
        					<td class="w90 tc"><input type="submit" class="submit" value="搜索" /></td>
      					</tr>
    				</table>
  				</form>
  				<table class="ncu-table-style">
    				<thead>
				      <tr>
				        <th class="w180">订单编号</th>
				        <th class="w180">退货编号</th>
				        <th class="w80">买家会员名</th>
				        <th class="w80">退货数量</th>
				        <th class="w100"><p class="goods-time">退货时间</p></th>
				        <th class="w60">审核状态</th>
				        <th class="w60">平台确认</th>
				        <th class="w90">操作</th>
				      </tr>
    				</thead>
			        <tbody>
			        	<#if list??>
       						<#list list as refundReturn>
	            				<tr class="bd-line" >
	        						<td><span style="color: blue">${refundReturn.orderSn}</span></td>
	        						<td class="goods-num">${refundReturn.refundSn}</td>
	        						<td><span style="color: blue">${refundReturn.buyerName}</span></td>
	        						<td><strong>${refundReturn.goodsNum}</strong></td>
	        						<td class="goods-time"><#if refundReturn.createTimeStr??>${refundReturn.createTimeStr?string('yyyy-MM-dd')}</#if></td>
	        						<td>
	        							<#if refundReturn.sellerState==1>
	        								待审核
	        							<#elseif refundReturn.sellerState==2>
	        								同意
	        							<#elseif refundReturn.sellerState==3>
	        								不同意
	        							</#if>
	        						</td>
	        						<td>
	        							<#if refundReturn.refundState??>
	        								<#if refundReturn.refundState==1>
	        									未申请
	        								<#elseif refundReturn.refundState==2>
	        									待处理
	        								<#elseif refundReturn.refundState==3>
	        									已完成
	        								</#if>
	        							<#else>
	        								无
	        							</#if>
	        						</td>
	        						<td>
	        							<a href="${base}/trade/refundReturnDetail?refundId=${refundReturn.refundId}" target="_blank"> 查看 </a>
	        							<#if refundReturn.sellerState==1>
	        								<a href="${base}/trade/refundReturnIndex?refundId=${refundReturn.refundId}"> 审核</a>
	        							</#if>
	        							<#if refundReturn.goodsState==2>
	        								<a href="javascript:void(0)" onclick="confirm('${refundReturn.refundId}')">确认收货</a>
	        							</#if>
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
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>
</body>
</html>
<script type="text/javascript">
	function confirm(refundId){
		layer.open({
		    type: 2,
		    area: ['500px', '275px'],
		    skin: 'layui-layer-rim',
		    title: '确认收货',
		    //content: APP_BASE + '/cart/addresslist'
		    content :  ['${base}/trade/refundReturnConfirmIndex?refundId=' + refundId, 'no'],
		    success: function(layero, index){
		    	layer.getChildFrame('#confirm_button',index).on('click', function(){
					var refundId=layer.getChildFrame("#refundId",index).val();
					var receiveMessage = layer.getChildFrame("#receiveMessage",index).val();
					var fmUrl = '${base}/trade/refundReturnConfirm';
					$.ajax({
			             type: "post",
			             url: fmUrl,
			             data: {refundId:refundId,receiveMessage:receiveMessage},
			             dataType: "json",
						 success:function(data) {
							if(data.success){
								parent.layer.alert("确认收货成功",{icon:1},function(){
									location.reload();
								});	
							}else{
								parent.layer.alert("确认收货失败",{icon:2},function(){
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
<@p.footer/>	