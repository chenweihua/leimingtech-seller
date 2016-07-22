package com.leimingtech.seller.module.mansong.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.leimingtech.core.base.BaseController;
import com.leimingtech.core.common.Constants;
import com.leimingtech.core.common.DateUtils;
import com.leimingtech.core.common.ParamsUtils;
import com.leimingtech.core.common.StringUtils;
import com.leimingtech.core.entity.base.Member;
import com.leimingtech.core.entity.base.ShopPMansong;
import com.leimingtech.core.entity.base.ShopPMansongQuota;
import com.leimingtech.core.entity.base.ShopPMansongRule;
import com.leimingtech.core.entity.base.Store;
import com.leimingtech.core.state.mansong.ManSongState;
import com.leimingtech.seller.utils.sessionKey.CacheUser;
import com.leimingtech.seller.utils.sessionKey.CacheUtils;
import com.leimingtech.service.module.mansong.service.ShopPMansongService;
import com.leimingtech.service.module.mansongapply.service.ShopPMansongApplyService;
import com.leimingtech.service.module.mansongquota.service.ShopPMansongQuotaService;
import com.leimingtech.service.module.mansongrule.service.ShopPMansongRuleService;
import com.leimingtech.service.utils.page.Pager;

/**
 * 满就送controller，卖家端
 * 
 * @author yangxp 2015年11月25日 下午3:27:46
 */
@Slf4j
@Controller
@RequestMapping("/shopPMansong")
public class MansongAction extends BaseController {

	/** 满就送Service接口 */
	@Resource
	private ShopPMansongService shopPMansongService;
	// 满就送规则Service接口
	@Resource
	private ShopPMansongRuleService shopPMansongRuleService;
	// 满就送套餐service接口
	@Resource
	private ShopPMansongQuotaService shopPMansongQuotaService;

	/**
	 * 满就送列表
	 * 
	 * @param pageNo
	 * @return
	 */
	@RequestMapping("/list")
	public String list(
			Model model,
			@ModelAttribute ShopPMansong shopPMansong,
			@RequestParam(required = false, value = "pageNo", defaultValue = "1") Integer pageNo
			) {

		Pager pager = new Pager();
		Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
		
		pager.setPageNo(pageNo);
//		pager.setPageSize(20);
		
		//通过店铺名，查看是否有满就送套餐，如果有，就跳转到详情页面，如果没有，就跳转到申请页面
//		ShopPMansongQuota shopPMansongQuota = shopPMansongQuotaService.findShopPMansongQuotaByStoreId(storeId);
//		if(shopPMansongQuota == null){
//			return "/mansong/shopPMansongApply";
//		}
		
		//如果storeid为空，则未登录，跳转到登录页面
		if (storeId == null) {
			return "/index/login";
		}
		shopPMansong.setStoreId(storeId);
		pager.setCondition(shopPMansong);
		List<ShopPMansong> list = shopPMansongService
				.findShopPMansongPagerList(pager);
		pager.setResult(list);

		model.addAttribute("pager", pager);
		model.addAttribute("mansongName", shopPMansong.getMansongName());
//		model.addAttribute("shopPMansongQuota", shopPMansongQuota);
		model.addAttribute("pageNo", pager.getPageNo());// 当前页
		model.addAttribute("pageSize", pager.getPageSize());// 每页显示条数
		model.addAttribute("recordCount", pager.getTotalRows());// 总数
		model.addAttribute("state", shopPMansong.getState());
		model.addAttribute("toUrl", "/shopPMansong/list");
		return "/mansong/shopPMansongList";
	}

	/**
	 * 跳转到套餐申请页面
	 */
	@RequestMapping("/toApply")
	public String toApply(){
		return "/mansong/shopPMansongQuotaApply";
	}
	
	/**
	 * 通过id获取活动的详情
	 */
	@RequestMapping("/findById")
	public String findMansongDetailById(Model model,
			@RequestParam(required = true, value = "id") int mansongId) {
		ShopPMansong shopPMansong = shopPMansongService
				.findShopPMansongById(mansongId);
		List<ShopPMansongRule> shopPMansongRules = shopPMansongRuleService
				.findShopPMansongRuleByMansongid(mansongId);
		model.addAttribute("shopPMansong", shopPMansong);
		model.addAttribute("shopPMansongRuleList", shopPMansongRules);
		return "/mansong/shopPMansongDetail";
	}

	/**
	 * 跳转至满就送新增或修改页面
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping("/forward")
	public String add(Model model) {

		// 获取套餐
//		Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
//		ShopPMansongQuota shopPMansongQuota = shopPMansongQuotaService
//				.findShopPMansongQuotaByStoreId(storeId);

		// 通过套餐编号，获取满就送活动信息，如果没有活动就new
//		List<ShopPMansong> shopPMansongList = shopPMansongService
//				.findShopPMansongByQuotaId(shopPMansongQuota.getQuotaId());
//		if (shopPMansongList == null) {
//			shopPMansongList = new ArrayList<ShopPMansong>();
//		}

//		model.addAttribute("shopPMansongList", shopPMansongList);
//		model.addAttribute("shopPMansongQuota", shopPMansongQuota);
		return "/mansong/shopPMansongEdit";
	}

	/**
	 * 满就送保存
	 * 
	 * @param goodsClass
	 * @param id
	 * @return
	 */
	@RequestMapping("/save")
	public ModelAndView save(
			@RequestParam(value = "mansongName", defaultValue = "") String mansongName,
			@RequestParam(value = "remark", defaultValue = "") String remark,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(required=false, value = "mansong_rule[]") String[] mansong_rule) {

		ShopPMansong shopPMansong = new ShopPMansong();
//		Map<String,Object> map = new HashMap<String, Object>();
		try{
			CacheUser cacheUser = CacheUtils.getCacheUser();
			Store store = cacheUser.getStore();
			Member member = cacheUser.getMember();
			
			//如果用户未登录，跳转到登录页面
			if(store == null || member == null){
				return new ModelAndView("redirect:/login");
			}
			
			shopPMansong.setMansongName(mansongName);
			shopPMansong.setQuotaId(store.getStoreId());
			
			shopPMansong.setStoreId(store.getStoreId());
			shopPMansong.setStoreName(store.getStoreName());
			shopPMansong.setMemberId(member.getMemberId());
			shopPMansong.setMemberName(member.getMemberName());
			shopPMansong.setRemark(remark);
			shopPMansong.setStartTime(DateUtils.strToLong(startTime + ":00"));
			shopPMansong.setEndTime(DateUtils.strToLong(endTime + ":00"));
			shopPMansong.setState(ManSongState.MS_APPLY);//状态(1-新申请/2-审核通过/3-已取消/4-审核失败)
			shopPMansongService.saveShopPMansong(shopPMansong);
			Integer mansongId = shopPMansong.getMansongId();
			
			//遍历添加的规则
			int i = 1;
			for (String rules : mansong_rule) {
				ShopPMansongRule shopPMansongRule = new ShopPMansongRule();
				String[] rule = rules.split(";");
				shopPMansongRule.setPrice(BigDecimal.valueOf(ParamsUtils.getDouble(rule[0])));
				shopPMansongRule.setDiscount(BigDecimal.valueOf(ParamsUtils.getDouble(rule[1])));
				shopPMansongRule.setLevel(i);  //按添加的顺序设置的
				shopPMansongRule.setMansongId(mansongId);
				i++;
				shopPMansongRuleService.saveShopPMansongRule(shopPMansongRule);
			}
			return new ModelAndView("redirect:/shopPMansong/list");
		} catch (Exception e) {
			log.error("满就送保存出错", e);
			return new ModelAndView("redirect:/shopPMansong/list");
		}
	}

	/**
	 * 满就送删除
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping("delete")
	@ResponseBody
	public Map<String,Object> delete(
			Model model,
			@RequestParam int id
			){
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			shopPMansongService.deleteShopPMansongById(id);
			// 同时还要删除满就送的规则
			shopPMansongRuleService.deleteShopPMansongRuleByMansongid(id);
			map.put("success", true);
			map.put("msg", "删除成功");
		} catch (Exception e) {
			log.error("满就送删除出错", e);
			map.put("success", false);
			map.put("msg", "删除失败");
		}
		return map;
	}
}