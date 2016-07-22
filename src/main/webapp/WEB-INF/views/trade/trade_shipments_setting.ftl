<@p.header title="商家中心-发货设置"/>
<script type="text/javascript" src="${base}/res/js/common_select.js" charset="utf-8"></script>
<script type="text/javascript" src="${base}/res/js/ajaxfileupload/ajaxfileupload.js"></script>
<script type="text/javascript" src="${base}/res/js/layer/layer.js"></script>

<div class="layout">
    <div class="sidebar"></div>
  	<div class="right-content">
        <div class="path">
      		<div>
      			<a href="${base}">商家中心</a> <span></span>
                <a href="#?act=deliver&op=daddress"/>发货设置</a><span></span>
                	地址库
            </div>
    	</div>
        <div class="main">
			<div class="wrap">
  				<div class="tabmenu">
    				<ul class="tab pngFix">
  						<li class="active">
  							<a  href="#">地址库</a>
  						</li>
  						<li class="normal">
  							<a  href="${base}/transport/tradelogis">默认物流公司</a>
  						</li>
  					</ul>
    				<a href="javascript:void(0)" onclick="addAddress()" class="ncu-btn3" title="新增地址">新增地址</a>
    			</div>
    				<div></div>
  					<table class="ncu-table-style" >
    					<thead>
      						<tr>
        						<th class="w70">发货地址</th>
        						<th class="w90">联系人</th>
        						<th class="w150">所在地区</th>
        						<th class="tl">街道地址</th>
        						<th class="w90">邮编</th>
        						<th class="w150">电话/手机</th>
        						<th class="w90">操作</th>
      						</tr>
    					</thead>
        				<tbody>
        					<#if list??>
        						<#list list as daddress>
		            				<tr class="bd-line">
		        						<td><input type="radio" name="is_default" <#if daddress.isDefault == '1'>checked</#if> value="${daddress.addressId}"> 默认</td>
		        						<td>${daddress.sellerName}</td>
		        						<td>${daddress.areaInfo}</td>
		        						<td class="tl">${daddress.address}</td>
		        						<td>${daddress.zipCode}</td>
		        						<td>
		        							<span class="tel">${daddress.telPhone}</span> <br/>
		          							<span class="mob">${daddress.mobPhone}</span>
		          						</td>
		        						<td>
		        							<p>
		        								<a href="javascript:void(0);" onclick="updateDaddress('${daddress.addressId}')" >编辑地址</a>
		        							</p>
		        							<p>
		        								<a href="javascript:void(0)" onclick="deleteDaddress('${daddress.addressId}')" class="ncu-btn2 mt5">删&nbsp;除</a>
		        							</p>
		        						</td>
		      						</tr>
      							</#list>
      						</#if>
                		</tbody>
    					<tfoot><tr><td colspan="20">&nbsp;</td></tr></tfoot>
  					</table>
				</div>
    		</div>
  		</div>
    	<div class="clear"></div>
	</div>
</body>
</html>
<script>
$(function (){
	$('input[name="is_default"]').bind('click',function(){
		var addressId = $(this).val();
		$.ajax({
			type: "post",
	 		url: '${base}/transport/defaultDaddress',
			data: {addressId:addressId},
			dataType: "json",
			success:function(data) {
				if(data.success){
					$(this).attr(checked);
				}else{
					layer.msg("默认地址设置失败!",{icon:2});
				}
			}
		});  
	});
});

function deleteDaddress(id){
	layer.confirm("您确定要删除吗?",{
	    btn: ['确定','取消'], //按钮
	    shade: false //不显示遮罩
	},function(){
		$.ajax({
			type: "post",
	 		url: '${base}/transport/deleteDaddress',
			data: {addressId:id},
			dataType: "json",
			success:function(data) {
				if(data.success){
					layer.msg("发货地址已删除!",{icon:1,time:1000},function(){location.reload();});
				}else{
					layer.msg("发货地址删除失败!",{icon:2});
				}
			}
		});  
	}, function(){
	});
}

	/*添加地址*/
    function addAddress(){
        layer.open({
            type:2,
            move: false,
            shade: false,
            title: '新增地址',
            content:['${base}/transport/addAddress', 'no'],
            area: ['550px', '420px']
        });
    }
    
    /*修改地址*/
    function updateDaddress(id){
        layer.open({
            type:2,
            move: false,
            shade: false,
            title: '修改地址',
            content:['${base}/transport/updateAddress?id='+id, 'no'],
            area: ['550px', '420px']
        });
    }
</script>
<@p.footer/>
