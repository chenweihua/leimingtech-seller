<@p.header title="商家中心－店铺商品成交量" />
<div class="layout">
	<div class="sidebar">

	</div>
    <script type="text/javascript" src="${base}/res/js/My97DatePicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${base}/res/js/highchart/highcharts.js"></script>
	<div class="right-content">
		<div class="path">
			<div>
				<a href="${base}/">商家中心</a> <span>></span> <a href="clickIndex" />成交量统计</a><span>></span>成交量
			</div>
		</div>
		<div class="main">
			<div class="wrap">
				<div class="tabmenu">
					<ul class="tab pngFix">
						<li id="goodsTable" class="active"><a href="javascript:void(0);" onClick="changeReportTable('storeSellCount')">商品流量</a></li>
					</ul>
				</div>
				<div>
				    <ul>
				       <li>1、统计图展示了在搜索时间段内成交量多的店铺商品前30名</li>
				    </ul>
				</div>
				<form method="post"  name ="queryListForm" id="acct-form">
				   <table class="search-form">
						<tbody>
							<tr>
							    <th>时间：</th>
								<td class="w100">
									<select class="querySelect" name="timebutton" onchange="changetime(this.options[this.options.selectedIndex].value)">
										<option value="%Y-%m-%d">按周统计</option>
										<option value="%Y-%m %u">按月统计</option>
									</select>
								</td>
								<th>查询时间：</th>
								<td style="width:230px">
									<input name="startTime" id="start" type="text" style="width: 130px" class="txt Wdate" value="${startTime}" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'});" />&#8211;
									<input name="endTime" id="end" type="text" style="width: 130px" class="txt Wdate" value="${endTime}" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'});" />
								</td>
								<td class="w90 tc">
								    <input type="hidden" name="condition" value="%Y-%m-%d">
									<input type="button"  class="submit"  onclick="searchRangeTime();" value="搜索" />
								</td>
							</tr>
					    </tbody>
					   </table>
				</form>
				
				<div id="container"></div>
			</div>
			<script type="text/javascript">
				$(function() {
					getData();
				});
				
				function changetime(str){
			       $("[name=condition]").val(str);
			       getData();
			   }
			   function searchRangeTime(){
					getData();
			   }
				//hightchart报表
				function getData(){
					var xset = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30];//X轴数据集  
			        var yset = [];//Y轴数据集  
			        var condition=$("[name=condition]").val();//时间条件
			        var startime = $("[name=startTime]").val();//开始时间
					var endtime = $("[name=endTime]").val();//结束时间
				    $.ajax({
			             type: "post",
			             url: '${base}/report/goodssalcount',
			             data: {"condition":condition,"startime":startime,"endtime":endtime},
			             dataType: "json",
						 async:false,
						 success:function(data) {
							getstatcount(xset,data);
						}	
			         });
				}
				//初始化
				function getstatcount(xset,data) {
					$('#container').highcharts({
						"xAxis": {
						    "categories":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
						},
						"series": [{
							"data":  data,
							"name": "成交量"
						}],
						"legend": {
							"enabled": false
						},
						"title": {
							"text": "商品成交量TOP30",
							"x": -20
						},
						"chart": {
							"type": "column"
						},
						"credits": {
							"enabled": false
						},
						"exporting": {
							"enabled": false
						},
						"yAxis": {
							"title": {
								"text": "成交量"
							}
						}
					});
				}
			</script>

			<script type="text/javascript" src="${base }/res/js/jquery-ui/i18n/zh-CN.js" charset="utf-8"></script>

		</div>
	</div>
	<div class="clear"></div>
</div>
<@p.footer />