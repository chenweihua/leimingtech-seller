<@p.header title="商家中心-满即送"/>
<script type="text/javascript" src="${base}/res/js/jquery.js"></script>
<script type="text/javascript" src="${base}/res/js/layer/layer.js"></script>
<script type="text/javascript" src="${base}/res/js/jquery.validation.min.js"></script>
<script type="text/javascript" src="${base}/res/js/My97DatePicker/WdatePicker.js" charset="utf-8"></script>
<style type="text/css">
.mansong-rule span { *line-height: normal !important; *height: auto !important; *margin-top: 0 !important; *zoom:0 !important;}
.mansong-rule .gift { clear: both;}
.mansong-rule-list {}
.mansong-rule-list li { color: #3A87AD; filter:progid:DXImageTransform.Microsoft.gradient(enabled='true',startColorstr='#3FD9EDF7', endColorstr='#3FD9EDF7');background:rgba(217,237,247,0.25); border: dashed 1px #BCE8F1; padding: 4px 9px;margin-bottom: 10px;}

.mansong-rule-list li strong { color: #F30; font-weight: 600;}
.mansong-rule-list li .goods-thumb { vertical-align: middle; display: inline-block; width: 32px; height: 32px; border: solid 1px #BCE8F1; margin-left: 2px;}
.mansong-rule-list li .goods-thumb img { max-width: 32px; max-height: 32px;}
.mansong-rule-list li .sc-btn-mini { float: right; display: inline-block;}
</style>
<div class="layout">
	<div class="sidebar"></div>
	<div class="right-content">
		<div class="path">
			<div>
				<a href="${base}">商家中心</a> 
				<span>&gt;</span> 
				<a href="#?act=store&amp;op=store_mansong"> 满即送管理 </a>
				<span>&gt;</span>活动内容
			</div>
		</div>
		<div class="main">
			<link rel="stylesheet" type="text/css"
				href="${base}/res/js/jquery-ui/themes/ui-lightness/jquery.ui.css">
			<div class="wrap">
				<div class="tabmenu">
					<ul class="tab pngFix">
						<li class="normal"><a href="${sellerServer}/shopPMansong/list">活动列表</a></li>
						<li class="active"><a href="">活动内容</a></li>
					</ul>
				</div>
				
		    <div class="fixed-empty"></div>
		    
		    <table class="ncu-table-style">
		        <thead>
		        <tr class="thead">
		            <th class="align-center"><font size="3">活动名称</font></th>
		            <th class="align-center"><font size="3">开始时间</font></th>
		            <th class="align-center"><font size="3">结束时间</font></th>
		            <th class="align-center"><font size="3">活动内容</font></th>
		            <th class="align-center"><font size="3">状态</font></th>
		        </tr>
		        </thead>
		        <tbody>
				<td class="align-center" width="180">
					${shopPMansong.mansongName}
				</td>
				<td class="align-center" width="250">
					<#if shopPMansong.startTimeStr??>
		            	${shopPMansong.startTimeStr?string("yyyy-MM-dd hh:mm")}
		           	</#if>
				            </td>
				            <td class="align-center" width="250">  
					<#if shopPMansong.endTimeStr??>
		            	${shopPMansong.endTimeStr?string("yyyy-MM-dd hh:mm")}
		           	</#if>
				</td>
				<!-- 送礼品这个还要分情况显示 -->
				<td class="align-left" width="400">
				<ul class="mansong-rule-list">
					<#list shopPMansongRuleList as shopPMansongRule>
						<li>单笔订单满<strong>${shopPMansongRule.price }</strong>元，&nbsp;立减现金<strong>${shopPMansongRule.discount }</strong>元，&nbsp;</li>
					</#list>
				</ul>
				</td>
				<td class="align-center" width="120">
					<!-- 状态(1-新申请/2-审核通过/3-已取消/4-审核失败) -->
					<#if shopPMansong.state == 1>新申请</#if>
					<#if shopPMansong.state == 2>审核通过</#if>
					<#if shopPMansong.state == 3>审核通过</#if>
					<#if shopPMansong.state == 4>审核失败</#if>
				</td>
		        </tbody>
		    </table>
			</div>
		</div>
	</div>
</div>
<div class="clear"></div>
<@p.footer/>