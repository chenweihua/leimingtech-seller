<@p.header title="商家中心－订单统计" />
<div class="layout">
	<div class="sidebar">

	</div>
	<script src="${base}/res/js/layer/layer.js"></script>
	<script type="text/javascript" src="${base }/res/js/TimeUtils.js" charset="utf-8"></script>
	<script type="text/javascript" src="${base}/res/js/My97DatePicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${base}/res/js/highchart/highcharts.js"></script>
	<div class="right-content">
		<div class="path">
			<div>
				<a href="#?act=store">商家中心</a> <span></span> <a href="orderIndex" />订单统计</a><span></span>订单数量统计
			</div>
		</div>
		<div class="main">
			<div class="wrap">
				<div class="tabmenu">
					<ul class="tab pngFix">
						<li id="goodsTable" class="normal"><a href="${base}/report/orderIndex">订单统计</a></li>
						<li id="goodsTable" class="active"><a href="javascript:void(0);">成交统计</a></li>
					</ul>
				</div>
				<form method="post"  name ="queryListForm" id="acct-form">
				     <input type="hidden" name="div" id="div" value = "#highchartlist"/>
				     <input type="hidden" id="pageNo" />
				     <input type="hidden" id="orderState" name="orderState" value="${orderState}"/>
					<table class="search-form">
						<tbody>
							<tr>
							    <th>时间：</th>
								<td class="w100">
									<select class="querySelect" name="timebutton" onchange="changetime(this.options[this.options.selectedIndex].value)">
										<option value="%Y-%m-%d %h">按日统计</option>
										<option value="%Y-%m-%d">按周统计</option>
										<option value="%Y-%m %u">按月统计</option>
										<option value="%Y-%m">按年统计</option>
									</select>
								</td>
								<th>查询时间：</th>
								<td style="width:230px">
									<input name="startTime" id="start" type="text" style="width: 125px" class="txt Wdate" value="${startTime}" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'});" />&#8211;
									<input name="endTime" id="end" type="text" style="width: 125px" class="txt Wdate" value="${endTime}" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'});" />
								</td>
								<td class="w90 tc">
									<input type="button" onclick="searchRangeTime();" class="submit" value="搜索" />
								</td>
								<td class="w90 tc">
									<input type="button"  name="export" value="导出"/>
								</td>
							</tr>
						</tbody>
					</table>
					<input type="hidden" name="condition" value="%Y-%m-%d %h">
				</form>
				 <div id="highchartContainer">
				 
 				 </div>
 				 <div id="highchartlist">
 				    
 				 </div>
			</div>
			<script type="text/javascript">
				$(function(){
					getData();
					initDataList();
				});
				
				/*初始化*/
			    function initDataList(){
			        var div = "#highchartlist";//显示的list 数据div id 必须传递
			        var orderState='${orderState}';
			        $.ajax({
			            async:false,
			            url:"${base}/report/kdhighchartorderlist",//默认加载list 页面
			            data:{div:div,orderState:orderState},
			            error:function(){
			                layer.msg("通讯失败!" , 1 , 9 );
			               /* frameControl.lhDgFalInfo("通讯失败!");*/
			            },
			            dataType:'html',
			            type: "POST",
			            contentType:"application/x-www-form-urlencoded; charset=utf-8",
			            success: function(data){
			                $(div).empty();
			                $(div).html(data);
			                $(div).hide();
			                $(div).fadeIn(300);
			            }
			        });
			    }
			</script>
			<script type="text/javascript">
			   function changetime(str){
			       $("[name=condition]").val(str);
			       $("[name=startTime]").val("");
			       $("[name=endTime]").val("");
			       getData();
			   }
				//$(function(){
					//时间的三个按钮
				    /* $("[name=timebutton]").click(function(){
				  		    $("[name=timebutton]").removeClass("active");
				  		    $("[name=timebutton]").addClass("normal");
				  		    $(this).removeClass("normal");
				   		    $(this).addClass("active");
				    	    var timeArg = $(this).attr("timeArg");
				    	    $("[name=condition]").val(timeArg);
				    		//changeReport();
				    		getData();
				    }); */
				//});
				//查询指定日期
				function searchRangeTime(){
					getData();
				}
				//导出
				 $("[name=export]").click(function(){
				        var condition=$("[name=condition]").val();//时间条件
				        var orderState =$("#orderState").val();//店铺状态
				        var startime = $("[name=startTime]").val();//开始时间
						var endtime = $("[name=endTime]").val();//结束时间
						 $.ajax({
				             type: "post",
				             url: '${base}/report/loadordercount',
				             data: {"condition":condition,"orderState":orderState,"startime":startime,"endtime":endtime},
				             dataType: "json",
			 				 async:false,
							 success:function(data) {
						     if(data.success){
				                  layer.msg(data.message , {icon:1});
				                  location.href='${imgServer}'+data.excelurl;
				             }else{
				                  layer.msg(data.message , {icon:2});
				             }
							}	
				       });
				});
				
	//hightchart报表
	function getData(){
		var xset = [];//X轴数据集  
        var yset = [];//Y轴数据集  
        var condition=$("[name=condition]").val();//时间条件
        var orderState =$("#orderState").val(); ;//店铺状态
        var startime = $("[name=startTime]").val();//开始时间
		var endtime = $("[name=endTime]").val();//结束时间
	    $.ajax({
             type: "post",
             url: '${base}/report/ordercountHighChart',
             data: {"condition":condition,"orderState":orderState,"startime":startime,"endtime":endtime},
             dataType: "json",
			 async:false,
			 success:function(data) {
				$.each(data,function(i,item){  
                    $.each(item,function(k,v){ 
                        xset.push(k);  
                        yset.push(v);  
                    });  
                })
                chart(xset,yset);
			}	
         });
	}
	
	function chart(xset,yset){
		$('#highchartContainer').highcharts({
	        title: {
	            text: '订单销量',
	            x: -20 //center
	        },
	        xAxis: {
	            categories: xset,
	            labels: {
	            	//X轴倾斜45度
                    rotation: -45,
                    align: 'right',
                    style: {
                        fontSize: '12px',
                        fontFamily: 'Times New Roman'
                    }
                }
	        },
	        yAxis: {
	            title: {
	                text: '销量'
	            },
	            plotLines: [{
	                value: 0,
	                width: 1,
	                color: '#808080'
	            }]
	        },
	        tooltip: {
	            valueSuffix: '单/元'
	        },
	        legend: {
	            layout: 'vertical',
	            align: 'right',
	            verticalAlign: 'middle',
	            borderWidth: 0
	        },
	        series: [{
	            name: '订单销量统计',
	            data: yset
	        }]
	    });
	}
			</script>
		</div>
	</div>
	<div class="clear"></div>
</div>
<@p.footer />