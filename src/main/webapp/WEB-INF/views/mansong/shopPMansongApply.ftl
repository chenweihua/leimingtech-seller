<@p.header title="商家中心-满即送"/>
<script type="text/javascript" src="${base}/res/js/layer/layer.js"></script>
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
						<li class="active"><a
							href="">活动列表</a></li>
					</ul>
					<a href="${base}/shopPMansong/toApply" class="ncu-btn3" title="套餐申请"> 套餐申请</a>
				</div>
				
				<table class="table tb-type2" id="prompt">
			        <tbody>
			        <tr>
			            <td>
			            <strong>当前没有可用套餐，请先购买套餐 </strong>
						<font size="2">
			            <ul>
			                <li>1、已参加限时折扣、抢购的商品，可同时参加满即送活动</li>
				    		<li>2、<strong style="color: #F00;">相关费用会在店铺的账期结算中扣除</strong>。</li>
			            </ul>
						</font>
			            </td>
			        </tr>
			        </tbody>
			    </table>
				
				<!-- 搜索栏 -->
		        <table class="search-form" align="right">
		            <tbody>
		            <tr>
		            	<td>&nbsp;</td>
			      <th>活动状态</th>
			      <td class="w100">
			      	<select style="width:100px">
		                <option value="" <#if state == null>selected</#if>>全部</option>
		                <option value="1" <#if state == 1>selected</#if>>未发布</option>
		                <option value="2" <#if state == 2>selected</#if>>正常</option>
		                <option value="3" <#if state == 3>selected</#if>>取消</option>
		                <option value="4" <#if state == 4>selected</#if>>失效</option>
		                <option value="5" <#if state == 5>selected</#if>>结束</option>
			        </select></td>
			      <td style="width:10px">&nbsp;</td>
			      <th class="w110">活动名称</th>
			      <td class="w160"><input type="text" class="text w150"></td>
			      <td style="width:10px">&nbsp;</td>
			      <td class="w90 tc">
					  <input class="submit" value="搜索" type="submit">
				  </td>
		            </tr>
		            </tbody>
		        </table>
				
				
		        <table class="ncu-table-style">
		            <tbody>
		            	<h3 style="color:blue" align="center">暂无符合条件的数据记录</h3>
		            </tbody>
		        </table>
			</div>
		</div>
	</div>
</div>
	<div class="clear"></div>
<@p.footer/>