<@p.header title="商家中心-订单结算"/>
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
                                                订单结算
            </div>
    	</div>
        <div class="main">
			<div class="wrap">
  				<div class="tabmenu">
    				<ul class="tab pngFix">
  						<li class="active"><a href="#">订单结算</a></li>
  					</ul>
  				</div>
  				<form method="get" action="${base}/bill/orderBillList" id="queryForm">
    				<table class="search-form">
      					<tr>
      						<th>结算单号：</th>
				      		<td class="w100"><input type="text" class="text" name="obNo" style="width: 130px" value="${orderBill.obNo}" /></td>	
	      					<th>订单状态：</th>
	    					<td class="w100">
	    						<select name="obState">
					         	   	<option value="99" <#if orderBill.obState==99>selected</#if>>所有状态</option>
			                        <option value="10" <#if orderBill.obState==10>selected</#if>>已出账</option>
			                        <option value="20" <#if orderBill.obState==20>selected</#if>>商家已确认</option>
			                        <option value="30" <#if orderBill.obState==30>selected</#if>>平台已审核</option>
			                        <option value="40" <#if orderBill.obState==40>selected</#if>>结算完成</option>
	      						</select>
	      					</td>
	      					<th>按年份搜索：</th>
        					<td class="w100">
       							<select name="osYear">
       								<option value="">请选择</option>
       								<#list 2010..2020 as t>
										<#if t==osYear>
											<option value="${t}" selected="selected">${t}</option>
											continue;
										</#if>
										<option value="${t}">${t}</option>
									</#list>
       							</select>
         					</td>
         					<th>按月份搜索：</th>
        					<td class="w100">
       							<select name="osMonth">
       								<option value="">请选择</option>
       								<#list 1..12 as t>
										<#if t==osMonth>
											<option value="${t}" selected="selected">${t}</option>
											continue;
										</#if>
										<option value="${t}">${t}</option>
									</#list>
       							</select>
         					</td>
	      					<td class="w90 tc">
  								<input type="submit" class="submit" value="搜索" />
  							</td>
      					</tr>
    				</table>
  				</form>
  				<table class="ncu-table-style">
    				<thead>
				      <tr>
				        <th class="w180">结算单号</th>
				        <th class="w180">起止时间</th>
				        <th class="w80">订单金额</th>
				        <th class="w80">收取佣金</th>
				        <th class="w80">退单金额</th>
				        <th class="w80">退还佣金</th>
				        <th class="w80">本期应收</th>
				        <th class="w80">结算状态</th>
				        <th class="w90">操作</th>
				      </tr>
    				</thead>
			        <tbody>
			        	<#if obList??>
       						<#list obList as orderBill>
	            				<tr class="bd-line" >
	            					<td><span style="color: blue">${orderBill.obNo}</span></td>
	      							<td>${orderBill.obStartTimeStr?string('yyyy-MM-dd')}—${orderBill.obEndTimeStr?string('yyyy-MM-dd')}</td>
	      							<td class="align-center">
						            	<script type="text/javascript">
						   					var obOrderTotals = number_format(${orderBill.obOrderTotals},2);
						   					document.write(obOrderTotals);
						   				</script>
						            </td>
						            <td class="align-center">
						            	<script type="text/javascript">
						   					var obCommisTotals = number_format(${orderBill.obCommisTotals},2);
						   					document.write(obCommisTotals);
						   				</script>
						            </td>
						            <td class="align-center">
						            	<script type="text/javascript">
						   					var obOrderReturnTotals = number_format(${orderBill.obOrderReturnTotals},2);
						   					document.write(obOrderReturnTotals);
						   				</script>
						   			</td>
						            <td class="align-center">
						            	<script type="text/javascript">
						   					var obCommisReturnTotals = number_format(${orderBill.obCommisReturnTotals},2);
						   					document.write(obCommisReturnTotals);
						   				</script>
						            </td>
	      							<td>
	      								<script type="text/javascript">
			              					var result = number_format(${orderBill.obResultTotals},2);
			              					document.write(result);
			              				</script>
	      							</td>
	      							<td>
	      								<#if orderBill.obState == 10>
	      									已出账
	      								<#elseif orderBill.obState == 20>
	      									卖家已确认
	      								<#elseif orderBill.obState == 30>
	      									平台已审核
	      								<#elseif orderBill.obState == 40>
	      									结算完成
	      								</#if>
	      							</td>
	      							<td>
	      								<a href="${base}/bill/orderBillDetail?obId=${orderBill.obId}" target="_blank">查看</a>
	      								<#if orderBill.obState==10>
	      									 | 	<a href="javascript:void(0)" onclick="submitBill('${orderBill.obId}');">确认结算</a>
	      								</#if>
	      								<#if orderBill.obState==30>
	      									 |  <a href="javascript:void(0)" onclick="confirmReceipt('${orderBill.obId}',this)">确认收款</a>
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
	//确认结算
	function submitBill(id){
		layer.open({
		    type: 2,
		    area: ['500px', '380px'],
		    skin: 'layui-layer-rim',
		    title: '确认结算',
		    content :  ['${base}/bill/submitBillIndex?obId='+ id, 'no'],
		    success: function(layero, index){
		    	layer.getChildFrame('#confirm_button',index).on('click', function(){
		    		layer.getChildFrame('#confirm_button').attr("disabled","disabled");
		    		var obId = layer.getChildFrame('input[name="obId"]').val();
		    		var fmUrl = '${base}/bill/submitBill';
		    		$.ajax({
			             type: "post",
			             url: fmUrl,
			             data: {obId:obId},
			             dataType: "json",
						 success:function(data) {
						 	if(data.result==1){
						 		layer.msg("确认成功!",{icon:1,time:1000},function(){
						 			location.reload();
						 		});
						 	}else{
						 		layer.msg(data.message,{icon:2,time:1000},function(){
						 			layer.getChildFrame('#confirm_button').attr("disabled",false);
						 		});
						 	}
						 }
					});
		    	});
		    }
		});
	}
	
	function confirmReceipt(id,obj){
		layer.confirm("您确定进行确认收款操作?",{icon:3},function(index){
			$(obj).attr("onclick","");
			var fmUrl = '${base}/bill/confirmReceipt';
			$.ajax({
	             type: "post",
	             url: fmUrl,
	             data: {obId:id},
	             dataType: "json",
				 success:function(data) {
				 	if(data.result==1){
				 		layer.msg("确认成功!",{icon:1,time:1000},function(){
				 			location.reload();
				 		});
				 	}else{
				 		layer.msg(data.message,{icon:2,time:1000},function(){
				 			layer.close(index);
							$(obj).attr("onclick","confirmReceipt('"+id+"')");
				 		});
				 	}
				 }
			});
		});
	}	
</script>
<@p.footer/>	