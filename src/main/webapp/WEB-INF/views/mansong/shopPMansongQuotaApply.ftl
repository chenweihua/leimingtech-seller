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
				<span>&gt;</span>套餐申请
			</div>
		</div>
		<div class="main">
			<link rel="stylesheet" type="text/css"
				href="${base}/res/js/jquery-ui/themes/ui-lightness/jquery.ui.css">
			<div class="wrap">
				<div class="tabmenu">
					<ul class="tab pngFix">
						<li class="normal"><a href="${sellerServer }/shopPMansong/list">活动列表</a></li>
						<li class="active"><a href="#">活动申请</a></li>
					</ul>
				</div>
				
				<div class="eject_con">
				  <form id="add_form" action="${base}/shopPMansong/apply" method="post">
				    <dl>
				      <dt class="required">
						  <em class="pngFix"></em>套餐购买数量：
					  </dt>
				      <dd>
				          <input name="apply_quantity" class="text w50" id="apply_quantity" type="text"><em class="add-on">月</em>
				          <span></span>
				        <p class="hint">购买单位为月(30天)，一次最多购买12个月，购买后您可以发布满即送活动，但同时只能有一个活动进行</p>
				        <p class="hint">每月您需要支付10元</p>
				        <p class="hint"><strong style="color: red;">相关费用会在店铺的账期结算中扣除</strong></p>
				      </dd>
				    </dl>
					
				    <tfoot>
				      <dl>
				          <dd></dd>
				          <dd colspan="2">
				          	<input id="btn_submit" class="submit" value="提交" type="submit">
				          </dd>
				      </dl>
				     </tfoot>
				  </form>
				</div>
				<script>
				$(document).ready(function(){
				    //页面输入内容验证
				    $("#add_form").validate({
				        errorPlacement: function(error, element){
				            var error_td = element.parent('dd').children('span');
				            error_td.append(error);
				        },
				     	submitHandler:function(form){
				            var unit_price = 10;
				            var quantity = $("#apply_quantity").val();
				            var price = unit_price * quantity;
				             showDialog('确认购买?您总共需要支付'+price+'元', 'confirm', '', function(){ajaxpost('add_form', '', '', 'onerror');});
				    	},
				        rules : {
				            apply_quantity : {
				                required : true,
				                digits : true,
				                min : 1,
				                max : 12
				            }
				        },
				        messages : {
				            apply_quantity : {
				                required : '<i class="icon-exclamation-sign"></i>数量不能为空，且必须为1-12之间的整数',
				                digits : '<i class="icon-exclamation-sign"></i>数量不能为空，且必须为1-12之间的整数',
				                min : '<i class="icon-exclamation-sign"></i>数量不能为空，且必须为1-12之间的整数',
				                max : '<i class="icon-exclamation-sign"></i>数量不能为空，且必须为1-12之间的整数'
				            }
				        }
				    });
				});
				</script>
				
			</div>
		</div>
	</div>
</div>
	<div class="clear"></div>
<@p.footer/>