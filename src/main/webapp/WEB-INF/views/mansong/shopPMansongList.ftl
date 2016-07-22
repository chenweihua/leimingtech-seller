<@p.header title="商家中心-满即送"/>
<script type="text/javascript" src="${base}/res/js/jquery.js"></script>
<script type="text/javascript" src="${base}/res/js/layer/layer.js"></script>
<script type="text/javascript" src="${base}/res/js/jquery.validation.min.js"></script>
<div class="layout">
	<div class="sidebar"></div>
	<div class="right-content">
		<div class="path">
			<div>
				<a href="${base}">商家中心</a> 
				<span>&gt;</span> 
				<a href="#"> 满即送管理 </a>
				<span>&gt;</span>活动列表
			</div>
		</div>
		<div class="main">
			<link rel="stylesheet" type="text/css"
				href="${base}/res/js/jquery-ui/themes/ui-lightness/jquery.ui.css">
			<div class="wrap">
				<div class="tabmenu">
					<ul class="tab pngFix">
						<li class="active"><a href="">活动列表</a></li>
					</ul>
					<a href="${base}/shopPMansong/forward" class="ncu-btn3" title="添加活动">添加活动</a>
				</div>
				
				<table class="table tb-type2" id="prompt">
			        <tbody>
			        <tr>
			            <td>
						<font size="2">
			            <ul>
			                <li>1、已参加其它活动，也可同时参加满即送活动。</li>
				    		<li>2、<strong style="color: #F00;">该活动提交后需管理员审核通过才正式使用</strong>。</li>
			            </ul>
						</font>
			            </td>
			        </tr>
			        </tbody>
			    </table>
				
				<!-- 搜索栏 -->
			    <form method="post" name="queryListForm" id="queryListForm" action="${base}/shopPMansong/list">
			        <input type="hidden" value="${shopPMansong.storeId }" name="${shopPMansong.storeId }"/>
			        <table class="search-form" align="right">
			            <tbody>
			            <tr>
			            	<td>&nbsp;</td>
				      <th>活动状态</th>
				      <td class="w100">
				      	<select name="state" style="width:100px">
			                <option value="" <#if state == null>selected</#if>>全部</option>
			                <option value="1" <#if state == 1>selected</#if>>新申请</option>
			                <option value="2" <#if state == 2>selected</#if>>审核通过</option>
			                <option value="3" <#if state == 3>selected</#if>>取消</option>
			                <option value="4" <#if state == 4>selected</#if>>审核失败</option>
				        </select></td>
				      <td style="width:10px">&nbsp;</td>
				      <th class="w110">活动名称</th>
				      <td class="w160"><input type="text" class="text w150" name="mansongName" value="${mansongName}"></td>
				      <td style="width:10px">&nbsp;</td>
				      <td class="w90 tc">
						  <input class="submit" value="搜索" type="submit">
					  </td>
			            </tr>
			            </tbody>
			        </table>
			    </form>
				
		        <table class="ncu-table-style">
		            <thead>
		            <tr align="center">
		                <th class="w100">活动名称</th>
		                <th class="w250">开始时间</th>
		                <th class="w250">结束时间</th>
		                <th class="w180">状态</th>
		                <th class="w100">操作</th>
		            </tr>
		            </thead>
		            <tbody>
		            <#list pager.result as shopPMansong>
			            <tr>
						<td class="w100">
							${shopPMansong.mansongName}
						</td>
						<td class="w250">
							<#if shopPMansong.startTimeStr??>
			                	${shopPMansong.startTimeStr?string("yyyy-MM-dd hh:mm:ss")}</td>
		                	</#if>
						</td>
						<td class="w250">
							<#if shopPMansong.endTimeStr??>
			                	${shopPMansong.endTimeStr?string("yyyy-MM-dd hh:mm:ss")}</td>
		                	</#if>
						</td>
						<td class="w180">
							<!-- 状态(1-新申请/2-审核通过/3-已取消/4-审核失败) -->
							<#if shopPMansong.state == 1>新申请</#if>
							<#if shopPMansong.state == 2>审核通过</#if>
							<#if shopPMansong.state == 3>审核通过</#if>
							<#if shopPMansong.state == 4>审核失败</#if>
						</td>
			                
		                <td class="w100">
		                    <a href="${base}/shopPMansong/findById?id=${shopPMansong.mansongId}">详细</a>
		                    &nbsp;|&nbsp;
		                    <a href="javascript:void(0)" onclick="deleteMansong(${shopPMansong.mansongId})" class="ncu-btn2 mt5">删&nbsp;除</a>
		                </td>
		            </tr>
			        </#list>
		            </tbody>
		            <tfoot>
				    	<tr>
					        <td colspan="20">
				                <#if recordCount??>
							       <#import "/trade/page.ftl" as q>
							       <@q.pager pageNo=pageNo pageSize=pageSize recordCount=recordCount toURL="${toUrl}"/>
							    </#if>
					        </td>
				    	</tr>
					</tfoot>
		        </table>
			</div>
		</div>
		<script type="text/javascript">
		function deleteMansong(id) {
			layer.confirm('确定删除?', function(){
				$.ajax({
					type: "post",
					url: "${base}/shopPMansong/delete?id=" + id,
					dataType: "json",
					async:false,
					success:function(data) {
						if(data.success){
						 	parent.layer.alert(data.msg,{icon:1},function(){
								location.reload();
							});
						}else{
							parent.layer.alert(data.msg,{icon:2},function(){
								location.reload();
							});
						}
					}
				});
			});
		}
		</script>
	</div>
</div>
<div class="clear"></div>
<@p.footer/>