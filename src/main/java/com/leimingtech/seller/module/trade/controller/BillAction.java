package com.leimingtech.seller.module.trade.controller;

import java.util.List;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.leimingtech.core.base.BaseController;
import com.leimingtech.core.common.DateUtils;
import com.leimingtech.core.entity.base.OrderBill;
import com.leimingtech.seller.utils.sessionKey.CacheUtils;
import com.leimingtech.service.module.trade.service.OrderBillService;
import com.leimingtech.service.utils.page.Pager;

/**
 * 结算相关
 * @author liukai
 */
@Controller
@RequestMapping("/bill")
@Slf4j
public class BillAction extends BaseController{
	
	@Resource
	private OrderBillService orderBillService;
	
	/**
	 * 订单结算管理
	 * @return
	 */
	@RequestMapping(value = "/orderBillList")
	public String orderBillList(
			Model model,
			@RequestParam(required=false, value="pageNo",defaultValue="")String pageNoStr,
			@RequestParam(required=false, value="osMonth",defaultValue="")String osMonth,
			@RequestParam(required=false, value="osYear",defaultValue="")String osYear,
			@RequestParam(required=false, value="obState",defaultValue="99")String obState,
			@RequestParam(required=false, value="obNo",defaultValue="")String obNo
			){
		try {
			Pager pager = new Pager();
			OrderBill orderBill = new OrderBill();
			
			if(StringUtils.isNotBlank(pageNoStr)){
				pager.setPageNo(Integer.parseInt(pageNoStr));
			}
			
			//结算状态
			if (StringUtils.isNotBlank(obState) && !"99".equals(obState)) {
				orderBill.setObState(Integer.valueOf(obState));
			}
			
			//账单所在年份
		    if(StringUtils.isNotBlank(osYear)){
		    	orderBill.setOsYear(Integer.valueOf(osYear));
		    }
		    
		    //账单所在年月份
		    if(StringUtils.isNotBlank(osMonth)){
		    	orderBill.setOsMonth(Integer.valueOf(osMonth));
		    }
		    
		    //帐单编号
		    if(StringUtils.isNotBlank(obNo)){
		    	orderBill.setObNo(obNo.trim());
		    }
			
			orderBill.setObStoreId(CacheUtils.getCacheUser().getStore().getStoreId());
			pager.setCondition(orderBill);//实体加载在pager中
			pager.setPageSize(20);//每页默认显示20条
			
			List<OrderBill> results = orderBillService.findOrderBillPagerList(pager);// 结果集
			
			model.addAttribute("obList", results);// 结果集
			model.addAttribute("pageNo", pager.getPageNo());// 当前页
			model.addAttribute("pageSize", pager.getPageSize());// 每页显示条数
			model.addAttribute("recordCount", pager.getTotalRows());// 总数
            model.addAttribute("toUrl","/bill/orderBillList");
            model.addAttribute("orderBill",orderBill);
            model.addAttribute("osMonth", osMonth);
	        model.addAttribute("osYear", osYear);
			return "/trade/bill/billList";
		}catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 订单结算详情
	 * @param model
	 * @param obId 结算id
	 * @return
	 */
	@RequestMapping("orderBillDetail")
	public String orderBillDetail(Model model,@RequestParam(value = "obId") Integer obId){
		try {
			OrderBill orderBill = orderBillService.findOrderBillByStore(obId,CacheUtils.getCacheUser().getStore().getStoreId());
			model.addAttribute("orderBill", orderBill);
			return "/trade/bill/billDetail";
		}catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("加载失败!");
		}
	}
	
	/**
	 * 商家确认并提交订单结算-页面跳转
	 * @param model
	 * @param obId
	 * @return
	 */
	@RequestMapping("submitBillIndex")
	public String submitBillIndex(Model model,@RequestParam(value = "obId") Integer obId){
		try {
			OrderBill orderBill = orderBillService.findOrderBillByStore(obId,CacheUtils.getCacheUser().getStore().getStoreId());
			model.addAttribute("orderBill", orderBill);
			return "/trade/bill/submitBill";
		}catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("加载失败!");
		}
	}
	
	/**
	 * 商家确认并提交订单结算
	 * @param obId
	 * @return
	 */
	@RequestMapping("submitBill")
	@ResponseBody
	public String submitBill(@RequestParam(value = "obId") Integer obId){
		try{
			int result = orderBillService.updateSellerConfirm(obId, CacheUtils.getCacheUser().getStore().getStoreId());
			if(result==1){
				//将成功的信号传导前台
				showSuccessJson("确认成功!");
			}else if(result==2){
				//将失败的信号传到前台
				showErrorJson("请勿操作不属于自己店铺的数据!");
			}else if(result==3){
				//将失败的信号传到前台
				showErrorJson("请勿重复操作!");
			}
    		return json;
		}catch(Exception e){
			e.printStackTrace();
			//将失败的信号传到前台
			showErrorJson("确认失败");
			return json;
		}
	}
	
	/**
	 * 商家确认收款
	 * @param obId
	 * @return
	 */
	@RequestMapping("confirmReceipt")
	@ResponseBody
	public String confirmReceipt(@RequestParam(value = "obId") Integer obId){
		try{
			int result = orderBillService.updateSellerConfirmReceipt(obId, CacheUtils.getCacheUser().getStore().getStoreId());
			if(result==1){
				//将成功的信号传导前台
				showSuccessJson("确认成功!");
			}else if(result==2){
				//将失败的信号传到前台
				showErrorJson("请勿操作不属于自己店铺的数据!");
			}else if(result==3){
				//将失败的信号传到前台
				showErrorJson("请勿重复操作!");
			}
    		return json;
		}catch(Exception e){
			e.printStackTrace();
			//将失败的信号传到前台
			showErrorJson("确认失败");
			return json;
		}
	}
}
