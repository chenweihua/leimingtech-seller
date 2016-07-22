package com.leimingtech.seller.module.tag;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.leimingtech.core.common.ParamsUtils;
import com.leimingtech.core.entity.Order;
import com.leimingtech.core.freemarker.BaseFreeMarkerTag;
import com.leimingtech.seller.utils.sessionKey.CacheUtils;
import com.leimingtech.service.module.trade.service.OrderService;

import freemarker.template.TemplateModelException;

/**
 * 订单详细页标签
 * @author kviuff
 * @date 2015-07-17 16:30:00
 */
@Component
public class OrderDetailTag extends BaseFreeMarkerTag {

	@Resource
	private OrderService orderService;
	
	/**
	 * 订单详细标签
	 * @param orderId 订单id
	 */
	@SuppressWarnings("rawtypes")
	protected Object exec(Map params) throws TemplateModelException {
		int orderId = ParamsUtils.getInt(params.get("orderId"));
		Integer buyerId = CacheUtils.getCacheUser().getMember().getMemberId();
		Order order = orderService.findOrderDetail(Integer.valueOf(orderId),buyerId,null);
		return order;
	}

}
