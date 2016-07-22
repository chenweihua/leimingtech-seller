<link href="${base}/res/css/member.css" rel="stylesheet" type="text/css">
<link href="${base}/res/css/base.css" rel="stylesheet" type="text/css">
<link href="${base}/res/css/member_user.css" rel="stylesheet" type="text/css">
<script src="${base}/res/js/jquery.js" charset="utf-8"></script>
<div class="eject_con" style="width: 500px">
    <input type="hidden" name="returnId" id="returnId" value="${returnOrder.returnId}">
    <h2 style="line-height: 20px;font-weight: 600;background-color: #FEFEDA;color: #630;text-align: left;width: 90%;padding: 8px 16px;margin: 5px auto 5px auto;border: solid 1px #FFE8C2;">
    	您是否提交退款申请</h2>
    <dl >
      <dt style="color: #555;text-align: right;text-overflow: ellipsis;white-space: nowrap;width: 29%;float: left;">退货单号：</dt>
      <dd><span style="font-weight: 600;color: #390;">${returnOrder.returnSn}</span></dd>
    </dl>
    <dl>
    	<dt style="color: #555;text-align: right;text-overflow: ellipsis;white-space: nowrap;width: 29%;float: left;">退款金额：</dt>
      	<dd><span style="font-weight: 600;color: #390;">
				<script type="text/javascript">
   					var amount = number_format(${amount},2);
   					document.write(amount);
   				</script>	
			</span>
		</dd>
    </dl>
    <dl class="bottom">
      <dt>&nbsp;</dt>
       <input type="submit" id="confirm_button" class="submit" value="确定">
    </dl>
</div>