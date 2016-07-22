<@p.userHeader title="买家首页"/>
<script type="text/javascript" src="${base}/res/js/dialog/dialog.js" id="dialog_js" charset="utf-8"></script> 
<script type="text/javascript" src="${base}/res/js/nc-sideMenu.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/utils.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/layer/layer.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/My97DatePicker/WdatePicker.js" charset="utf-8"></script>
<link href="${base}/res/css/font-icons/style.css"  rel="stylesheet" />
<div id="container" class="wrapper">
	<div class="layout">
    	<@u.left  title="我的"/>
    	<div class="right-content">
      		<div class="path">
        		<div>
        			<a href="${base}">我的商城</a><span>&raquo;</span>
                    <a href="#"/>我的订单</a><span>&raquo;</span>
                   	退货申请
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
  							<li class="normal"><a  href="${base}/user/list">订单列表</a></li>
  							<#-- <li class="normal"><a  href="${base}/user/refundList">退款申请</a></li> -->
  							<li class="active"><a  href="#">退货记录</a></li>
  						</ul>
  					</div>
  					<form method="post" action="${base}/user/returnList">
    					<table class="search-form">
      						<input type="hidden" name="act" value="member_return" />
       						<input type="hidden" name="op" value="index" />
      						<tr>
        						<td>&nbsp;</td>
        						<th style="width:115px">
        							<select name="type">
            							<option value="orderSn" <#if type=="orderSn">selected="selected"</#if>>订单编号</option>
            							<option value="returnSn" <#if type=="returnSn">selected="selected"</#if>>退货编号</option>
            							<option value="storeName" <#if type=="storeName">selected="selected"</#if>>店铺名</option>
          							</select>：
          						</th>
        						<td class="w160"><input type="text" class="text" name="key" value="${key}" /></td>
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
        						<th class="w150">订单编号</th>
       							<th class="w150">退货编号</th>
        						<th>店铺</th>
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
		        						<td><span style="color: blue">${refundReturn.storeName}</span></td>
		        						<td><strong>${refundReturn.goodsNum}</strong></td>
		        						<td class="goods-time">${refundReturn.createTimeStr?string('yyyy-MM-dd')}</td>
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
		        						<td><a href="${base}/user/refundReturnDetail?refundId=${refundReturn.refundId}" target="_blank"> 查看 </a>
		        							<#if refundReturn.sellerState==2&&refundReturn.goodsState==1>
		        								<a href="${base}/user/refundReturnDeliveryIndex?refundId=${refundReturn.refundId}">发货</a>
		        							</#if>
		        							<#if refundReturn.sellerState==5>
		        								<a href="javascript:void(0)" onclick="finishReturn('${refundReturn.refundId}')" >确认收款</a>
		        							</#if>
		        						</td>
		      						</tr>
	      						</#list>
      						</#if>
                		</tbody>
    					<tfoot>
            				<tr>
        						<td colspan="20">
        							<#import "/commons/usertagpage.ftl" as q> <#--引入分页-->
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
	</div>
</div>
<script>
	/**确认收款**/
	function finishReturn(id) {
	   	layer.open({
		    type: 2,
		    area: ['500px', '240px'],
		    skin: 'layui-layer-rim',
		    title: '确认收款',
		    //content: APP_BASE + '/cart/addresslist'
		    content :  ['${base}/user/finishReturnIndex?returnId=' + id, 'no'],
		    success: function(layero, index){
		    	layer.getChildFrame('#confirm_button',index).on('click', function(){
					var returnId=layer.getChildFrame("#returnId",index).val();
					var fmUrl = '${base}/user/finishReturn';
					$.ajax({
			             type: "post",
			             url: fmUrl,
			             data: {returnId:returnId},
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
<@p.userfooter/>