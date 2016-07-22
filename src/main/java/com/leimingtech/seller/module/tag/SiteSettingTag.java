package com.leimingtech.seller.module.tag;


import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.leimingtech.core.entity.SiteSet;
import com.leimingtech.core.freemarker.BaseFreeMarkerTag;
import com.leimingtech.service.module.setting.service.SettingService;

import freemarker.template.TemplateModelException;

/**
 * 站点设置标签
 * @author zhaorh
 */
@Component
public class SiteSettingTag extends BaseFreeMarkerTag{
	
	@Resource
	private SettingService settingService;

	@SuppressWarnings("rawtypes")
	@Override
	protected Object exec(Map params) throws TemplateModelException {
		//获取买家收货地址
		Map<String,String> map = settingService.findByNameResultMap("site");
		SiteSet site = new SiteSet();
		site.setLogo(map.get("logo"));
		site.setSiteDiscription(map.get("siteDiscription"));
		site.setSiteKey(map.get("siteKey"));
		site.setSiteName(map.get("siteName"));
		site.setSiteTitle(map.get("siteTitle"));
		return site;
	}
}
