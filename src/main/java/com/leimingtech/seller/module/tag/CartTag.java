package com.leimingtech.seller.module.tag;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.leimingtech.core.common.ParamsUtils;
import com.leimingtech.core.entity.base.Address;
import com.leimingtech.core.entity.base.Member;
import com.leimingtech.core.entity.vo.CartVo;
import com.leimingtech.core.freemarker.BaseFreeMarkerTag;
import com.leimingtech.seller.utils.sessionKey.CacheUtils;
import com.leimingtech.service.module.cart.service.AddressService;
import com.leimingtech.service.module.cart.service.CartService;
import com.leimingtech.service.module.member.service.MemberService;
import com.leimingtech.service.module.promotion.service.PromotionClassService;

import freemarker.template.TemplateModelException;

/**
 * 购物车列表标签
 * @author liuk
 *
 */
@Component
public class CartTag extends BaseFreeMarkerTag{
	
	@Resource
	private CartService cartService;
	
	@Resource
	private AddressService addressService;
	
	@Resource
	private MemberService memberService;
	
	@Resource
	private PromotionClassService promotionClassService;

	@SuppressWarnings("rawtypes")
	protected Object exec(Map params) throws TemplateModelException {
		Map<String, Object> map = new HashMap<String, Object>();
		String cartIds = ParamsUtils.getString(params.get("cartIds"));
		if("".equals(cartIds)){
			List<CartVo> cartVoList = cartService.queryCartByMemberID(CacheUtils.getCacheUser().getMember().getMemberId());
			map.put("cartVoList",cartVoList);
            map.put("map", cartService.getTotalPrice(cartVoList));
		}else{
			//根据多个cartId查询购物车集合,分单
            List<CartVo> cartVoList = cartService.queryVOListByCartIds(cartIds);
            //获取买家收货地址
            List<Address> addressList = addressService.queryAddreassMemberId(CacheUtils.getCacheUser().getMember().getMemberId());
            //根据当前登录用户id,查询用户信息
            Member member = memberService.findById(CacheUtils.getCacheUser().getMember().getMemberId());
            //查询促销信息
            String promotionMessage = promotionClassService.findMessage();
            map.put("map", cartService.getTotalPrice(cartVoList));
            map.put("addressList", addressList);
            map.put("member", member);
            map.put("cartVoList", cartVoList);
            map.put("promotionMessage", promotionMessage);
		}
		return map;
	}

}
