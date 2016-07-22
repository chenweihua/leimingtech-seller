package com.leimingtech.seller.module.tag;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.leimingtech.core.common.ParamsUtils;
import com.leimingtech.core.entity.base.ShopPMansong;
import com.leimingtech.core.entity.base.ShopPMansongRule;
import com.leimingtech.core.freemarker.BaseFreeMarkerTag;
import com.leimingtech.service.module.mansong.service.ShopPMansongService;
import com.leimingtech.service.module.mansongrule.service.ShopPMansongRuleService;

import freemarker.template.TemplateModelException;

@Component
public class PromoteTag extends BaseFreeMarkerTag{
	
	/** 满就送Service接口 */
	@Resource
	private ShopPMansongService shopPMansongService;
	
	//满就送规则Service接口
	@Resource
	private ShopPMansongRuleService shopPMansongRuleService;
	
	@Override
	protected Object exec(Map params) throws TemplateModelException {
		int storeId = ParamsUtils.parseStoreId(params.get("storeId"));
		double price = ParamsUtils.getDouble(params.get("totalPrice"));
		ShopPMansong mansong = shopPMansongService.findStoreCurrentMansong(storeId, System.currentTimeMillis());
		String ms="";
		if(mansong ==null){
			return ms;
		};
		List<ShopPMansongRule> mansongRuleList = null;
		if(storeId != -1){
			mansongRuleList = shopPMansongRuleService.findShopPMansongRuleByMansongid(mansong.getMansongId());
				for(int i=0 ; i<mansongRuleList.size(); i++){
					ShopPMansongRule mansongRule = mansongRuleList.get(i);
					if(mansongRuleList.size()>i+1){
						ms += "满"+mansongRule.getPrice()+"减"+mansongRule.getDiscount()+"，";
					}else{
						ms += "满"+mansongRule.getPrice()+"减"+mansongRule.getDiscount();
					}
				}
		}
		if(mansongRuleList.size() > 0 && price!=0){
			BigDecimal p = BigDecimal.valueOf(price);
			ShopPMansongRule mansongRule = null;
			for(int i=0 ; i< mansongRuleList.size(); i++){
				ShopPMansongRule msRule = mansongRuleList.get(i);
				if(p.compareTo(msRule.getPrice()) == -1){
					break;
				}
				mansongRule = mansongRuleList.get(i);
			}
			if(mansongRule!=null)
			ms = "满"+mansongRule.getPrice()+"减"+mansongRule.getDiscount();
		}
		return ms;
	}

}
