package com.leimingtech.seller.module.trade.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.common.collect.Maps;
import com.leimingtech.core.base.BaseController;
import com.leimingtech.core.common.Constants;
import com.leimingtech.core.common.DateUtils;
import com.leimingtech.core.common.excel.ImportExcelsellerUtils;
import com.leimingtech.core.entity.Area;
import com.leimingtech.core.entity.EvaluateGoodsExcel;
import com.leimingtech.core.entity.GoodsClass;
import com.leimingtech.core.entity.Order;
import com.leimingtech.core.entity.base.EvaluateGoods;
import com.leimingtech.core.entity.base.EvaluateStore;
import com.leimingtech.core.entity.base.Goods;
import com.leimingtech.core.entity.base.OrderAddress;
import com.leimingtech.core.entity.base.RefundLog;
import com.leimingtech.core.entity.base.RefundReturn;
import com.leimingtech.core.entity.base.Store;
import com.leimingtech.core.jackson.JsonUtils;
import com.leimingtech.core.platform.info.PlatformInfo;
import com.leimingtech.core.state.goods.GoodsState;
import com.leimingtech.seller.utils.sessionKey.CacheUtils;
import com.leimingtech.service.module.area.service.AreaService;
import com.leimingtech.service.module.goods.service.BrandService;
import com.leimingtech.service.module.goods.service.GoodsClassService;
import com.leimingtech.service.module.goods.service.GoodsService;
import com.leimingtech.service.module.store.service.EvaluateStoreService;
import com.leimingtech.service.module.store.service.StoreService;
import com.leimingtech.service.module.trade.service.EvaluateGoodsService;
import com.leimingtech.service.module.trade.service.OrderAddressService;
import com.leimingtech.service.module.trade.service.OrderService;
import com.leimingtech.service.module.trade.service.RefundLogService;
import com.leimingtech.service.module.trade.service.RefundReturnService;
import com.leimingtech.service.utils.page.Pager;

/**
 * 交易管理首页
 *      
 * 项目名称：leimingtech-seller   
 * 类名称：TradeAction   
 * 类描述：   
 * 创建人：liuhao   
 * 创建时间：2014年11月25日 下午9:15:07   
 * 修改人：liuhao   
 * 修改时间：2014年11月25日 下午9:15:07   
 * 修改备注：   
 * @version    
 *
 */
@Controller
@RequestMapping("/trade")
@Slf4j
public class TradeAction extends BaseController{
	
	String message = "success";
	@Resource
	private OrderService orderService;
	@Resource
	private EvaluateGoodsService evaluateGoodsService;
	@Resource 
	private RefundLogService refundLogService;
	@Resource
	private RefundReturnService refundReturnService;
	@Resource
    private EvaluateStoreService evaluateStoreService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private StoreService storeService;
	@Resource
	private AreaService areaService;
	@Resource
	private OrderAddressService orderAddressService;
	@Autowired
	private GoodsClassService goodsClassService;
	@Resource
	private BrandService brandService;
	
	/**
	 * 订单管理
	 * @Title: list 
	 * @Description: TODO(这里用一句话描述这个方法的作用) 
	 * @param @return    设定文件 
	 * @return ModelAndView    返回类型 
	 */
	@RequestMapping(value = "/orderList")
	public String orderlist(
			Model model,
			@RequestParam(required=false, value="pageNo",defaultValue="")String pageNoStr,
			@RequestParam(required=false, value="buyerName",defaultValue="")String buyerName,
			@RequestParam(required=false, value="orderSn",defaultValue="")String orderSn,
			@RequestParam(required=false, value="startTime",defaultValue="")String startTime,
			@RequestParam(required=false, value="endTime",defaultValue="")String endTime,
			@RequestParam(required=false, value="orderState",defaultValue="99")String orderState){
		try {
			Pager pager = new Pager();
			Order order = new Order();
			/**查询条件，放入实体中，**/
            
			if(StringUtils.isNotBlank(startTime)){
				order.setStartTime(DateUtils.strToLong(startTime));
				model.addAttribute("startTime", startTime);
			}
			
			if(StringUtils.isNotBlank(endTime)){
				order.setEndTime(DateUtils.strToLong(endTime));
				model.addAttribute("endTime", endTime);
			}
			
			if(StringUtils.isNotBlank(buyerName)){
				order.setBuyerName(buyerName);
				model.addAttribute("buyerName", buyerName);
			}
			
			if(StringUtils.isNotBlank(orderSn)){
				order.setOrderSn(orderSn.trim());
				model.addAttribute("orderSn", orderSn.trim());
			}
			
			if(StringUtils.isNotBlank(orderState)&&!"99".equals(orderState)){
				order.setOrderState(Integer.valueOf(orderState));
			}
			
			if(StringUtils.isNotBlank(pageNoStr)){
				pager.setPageNo(Integer.parseInt(pageNoStr));
			}

            order.setStoreId(CacheUtils.getCacheUser().getStore().getStoreId());
			pager.setCondition(order);//实体加载在pager中
			pager.setPageSize(20);//每页默认显示20条

			List<Order> results = orderService.findOrderList(pager);// 结果集
			
			//List<Express> epresslist = orderService.findExpressList();
			
			model.addAttribute("orderLists", results);// 结果集
			model.addAttribute("pageNo", pager.getPageNo());// 当前页
			model.addAttribute("pageSize", pager.getPageSize());// 每页显示条数
			model.addAttribute("recordCount", pager.getTotalRows());// 总数
            model.addAttribute("toUrl","/trade/orderList");
            model.addAttribute("orderState",orderState);
            //model.addAttribute("epresslist", epresslist);// 快递公司
			//log.error(JsonUtils.toJsonStr(results));
			return "/trade/trade_order";
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 采购
	 * @Title: list 
	 * @Description: TODO(这里用一句话描述这个方法的作用) 
	 * @param @return    设定文件 
	 * @return ModelAndView    返回类型 
	 */
	@RequestMapping(value = "/purchaseList")
	public String purchaseList(
			@ModelAttribute Goods goods,Model model,
            @RequestParam(required=false, value="pageNo",defaultValue="")String pageNo,
            @RequestParam(required=false, value="brandId",defaultValue="")String brandId){
		try {
			Pager pager = new Pager();
			if (StringUtils.isNotBlank(pageNo)) {
				pager.setPageNo(Integer.parseInt(pageNo));
			}
    		goods.setStoreId(PlatformInfo.PLATFORM_STORE_ID);
    		goods.setGoodsShow(GoodsState.GOODS_ON_SHOW);//上架
    		goods.setGoodsState(GoodsState.GOODS_OPEN_STATE);//审核通过
    		if(StringUtils.isNotEmpty(brandId)){
    			goods.setBrandId(Integer.valueOf(brandId));
    		}
    		
			pager.setCondition(goods);// 实体加载在pager中
			List<Goods> results = goodsService.findGoodPagerList(pager);// 结果集
			GoodsClass goodsClass = goodsClassService.findById(goods.getGcId());
			String gcIdPath = "";
			String firstLevel = "";
			String secondLevel = "";
			String threeLevel = "";
			if(null != goodsClass){
				gcIdPath = goodsClass.getGcIdpath();
				String[] path = gcIdPath.split(",");
				firstLevel = path[0];
				if(path.length>1) 
				secondLevel = path[1];
				if(path.length>2)
				threeLevel = path[2];
			}
			// 页面查询条件品牌列表
            pager.setResult(results);
            model.addAttribute("pager", pager);//总数
			model.addAttribute("pageNo", pager.getPageNo());// 当前页
			model.addAttribute("pageSize", pager.getPageSize());// 每页显示条数
			model.addAttribute("recordCount", pager.getTotalRows());// 总数
	        model.addAttribute("toUrl", "/trade/purchaseList");//跳转页面
            model.addAttribute("goods",goods);
            model.addAttribute("brandList",brandService.findList());
            model.addAttribute("classList",goodsClassService.findList(0));
            model.addAttribute("gcidpath", gcIdPath);
            model.addAttribute("firstLevel", firstLevel);
            model.addAttribute("secondLevel", secondLevel);
            model.addAttribute("threeLevel", threeLevel);
            //图片路径
            model.addAttribute("imgSrc",Constants.SPECIMAGE_PATH);
            
			return "/trade/trade_purchase_list";
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 订单详情
	 * @param model
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/orderDetail")
	public String orderDetail(
			Model model,
			@RequestParam(required=false, value="orderId",defaultValue="")String orderId){
		try {
			Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
			List<Area> areas = areaService.queryAll();
			Order results = orderService.findOrderDetail(Integer.valueOf(orderId),null,storeId); //结果集
			model.addAttribute("order", results);// 结果集
			model.addAttribute("areas", areas);
			return "/trade/trade_order_detail";
		} catch (Exception e) {
            log.error("订单详情导航失败",e.toString());
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
     * 修改订单发货信息
     * @param orderAddress
     * @return
     */
    @RequestMapping("/updateOrderAddress")
    @ResponseBody
    public String updateOrderAddress(@ModelAttribute OrderAddress orderAddress){
    	try{
    		// 验证提交数据有效性
			if (!beanValidatorForJson(orderAddress)){
				return json;
			}
			orderAddressService.updateAddress(orderAddress);
			//将成功的信号传导前台
			showSuccessJson("发货地址保存成功");
			
    		return json;
		}catch(Exception e){
			e.printStackTrace();
			//将失败的信号传到前台
			showErrorJson("商品数据保存异常");
			return json;
		}
    }
	
	/**
	 * 进入取消订单首页
	 * 
	 * @Title: cancelOrderIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/cancelOrderIndex")
	public ModelAndView cancelOrderIndex(
			@RequestParam(required = false, value = "orderSn", defaultValue = "") String orderSn) {
		try {
			ModelAndView model = new ModelAndView("/trade/trade_cancel");
			model.addObject("orderSn", orderSn);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 取消订单
	 * @param model
	 * @param orderSn 订单编号
	 * @return
	 */
	@RequestMapping("/cancelOrder")
	public @ResponseBody Map<String, Object> cancleOrder(
			Model model,
			@RequestParam(required = false, value = "orderSn", defaultValue = "") String orderSn,
			@RequestParam(required = false, value = "cancelCause", defaultValue = "") String cancelCause) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			orderService.updateCancelOrder(orderSn,cancelCause,2);
			map.put("success", true);
		} catch (Exception e) {
			map.put("success", false);
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
		return map;
	}
	
	/**
	 * 进入调整费用首页
	 * 
	 * @Title: cancelOrderIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/updateAmountIndex")
	public ModelAndView updateAmountIndex(
			@RequestParam(required = false, value = "orderId", defaultValue = "") String orderId) {
		try {
			ModelAndView model = new ModelAndView("/trade/trade_update_amount");
			Order order = orderService.findById(Integer.valueOf(orderId));
			model.addObject("order", order);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 调整订单费用
	 * @param model
	 * @param orderId 订单id
	 * @param orderAmount 调整后的价格,订单总额
	 * @return
	 */
	@RequestMapping("/updateAmount")
	public @ResponseBody Map<String, Object> updateAmount(
			Model model,
			@RequestParam(required = false, value = "orderId", defaultValue = "") String orderId,
			@RequestParam(required = false, value = "orderAmount", defaultValue = "") String orderAmount
			) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			Order order = new Order();
			order.setOrderId(Integer.valueOf(orderId));
			order.setOrderAmount(BigDecimal.valueOf(Double.valueOf(orderAmount)));
			orderService.updateOrder(order);
			map.put("success", true);
		} catch (Exception e) {
			map.put("success", false);
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
		return map;
	}
	
	/**
	 * 进入确认订单首页(货到付款确认)
	 * 
	 * @Title: cancelOrderIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/confirmOrderIndex")
	public ModelAndView confirmOrderIndex(
			@RequestParam(required = false, value = "orderId", defaultValue = "") String orderId) {
		try {
			ModelAndView model = new ModelAndView("/trade/trade_confirm_order");
			Order order = orderService.findById(Integer.valueOf(orderId));
			model.addObject("order", order);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 确认订单(货到付款确认订单)
	 * @param model
	 * @param orderId 订单id
	 * @param orderAmount 调整后的价格,订单总额
	 * @return
	 */
	@RequestMapping("/confirmOrder")
	public @ResponseBody Map<String, Object> confirmOrder(
			Model model,
			@RequestParam(required = false, value = "orderSn", defaultValue = "") String orderSn
			) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			orderService.updateConfirmOrder(orderSn);
			map.put("success", true);
		} catch (Exception e) {
			map.put("success", false);
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
		return map;
	}
	
	
	/**
	 * 进入订单退款页
	 * 
	 * @Title: cancelOrderIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundOrderIndex")
	public ModelAndView refundOrderIndex(
			@RequestParam(required = false, value = "logId", defaultValue = "") String logId) {
		try {
			ModelAndView model = new ModelAndView("/trade/trade_order_refund");
			RefundLog refundLog = refundLogService.findRefundLogByLogId(Integer.valueOf(logId));
			model.addObject("refundLog", refundLog);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 订单退款
	 * @param model
	 * @param orderId 订单id
	 * @param orderAmount 调整后的价格,订单总额
	 * @return
	 */
	@RequestMapping("/refundOrder")
	public @ResponseBody Map<String, Object> refundOrder(
			Model model,
			@RequestParam(required = false, value = "logId", defaultValue = "") String logId,
			@RequestParam(required = false, value = "refundState", defaultValue = "") String refundState,
			@RequestParam(required = false, value = "refundMessage", defaultValue = "") String refundMessage) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			refundLogService.updateRefundLogSeller(Integer.valueOf(logId), Integer.valueOf(refundState), refundMessage, System.currentTimeMillis());
			map.put("success", true);
		} catch (Exception e) {
			map.put("success", false);
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
		return map;
	}
	
	/**
	 * 进入退款记录页
	 * 
	 * @Title: cancelOrderIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundOrderList")
	public ModelAndView refundOrderList(@RequestParam(required = false, value = "type", defaultValue = "") String type,
			   						    @RequestParam(required = false, value = "key", defaultValue = "") String key,
			   						    @RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNo,
			   						    @RequestParam(required = false, value = "startTime", defaultValue = "") String startTime,
			   						    @RequestParam(required = false, value = "endTime", defaultValue = "") String endTime) {
		try {
			ModelAndView model = new ModelAndView("/trade/trade_refund_list");
			RefundLog refundLog = new RefundLog();
			refundLog.setStoreId(CacheUtils.getCacheUser().getStore().getStoreId());
			if(StringUtils.isNotBlank(key)){
				if("orderSn".equals(type)){
					refundLog.setOrderSn(key);
					model.addObject("key", key);
				}else if("refundSn".equals(type)){
					refundLog.setRefundSn(key);
					model.addObject("key", key);
				}else if("buyerName".equals(type)){
					refundLog.setBuyerName(key);
					model.addObject("key", key);
				}
			}
			
			if(StringUtils.isNotBlank(startTime)){
				refundLog.setStartTime(DateUtils.strToLong(startTime+" 00:00:00"));
				model.addObject("startTime", startTime);
			}
			
			if(StringUtils.isNotBlank(endTime)){
				refundLog.setStartTime(DateUtils.strToLong(endTime+" 23:59:59"));
				model.addObject("endTime", endTime);
			}
			
			Pager pager = new Pager();
			if(StringUtils.isNotBlank(pageNo)){
				pager.setPageNo(Integer.valueOf(pageNo));
			}
			pager.setPageSize(5);
			pager.setCondition(refundLog);
			
	        List<RefundLog> refundLogList = refundLogService.findRefundLogList(pager);// 结果集
	        pager.setResult(refundLogList);
	        model.addObject("pager", pager);
	        model.addObject("list", refundLogList); //结果集
	        model.addObject("pageNo", pager.getPageNo());//当前页
			model.addObject("pageSize", 5);//每页显示条数
	        model.addObject("recordCount", pager.getTotalRows());//总数
	        model.addObject("toUrl", "/trade/refundOrderList");//总数
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 退款查询页面
	 * 
	 * @Title: refundIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundLogDetail")
	public ModelAndView refundIndex(@RequestParam(value = "logId") Integer logId) {
		try {
			ModelAndView model = new ModelAndView("/trade/trade_refund_detail");
			RefundLog refundLog = refundLogService.findRefundLogByLogId(logId);
			model.addObject("refundLog", refundLog);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 进入订单退货页
	 * 
	 * @Title: refundReturnIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundReturnIndex")
	public ModelAndView refundReturnIndex(
			@RequestParam(required = false, value = "refundId", defaultValue = "") String refundId) {
		try {
			ModelAndView model = new ModelAndView("/trade/trade_order_return");
			RefundReturn refundReturn = refundReturnService.findRefundReturnDetail(Integer.valueOf(refundId), null, CacheUtils.getCacheUser().getStore().getStoreId());
			model.addObject("refundReturn", refundReturn);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 订单退款
	 * @param model
	 * @param orderId 订单id
	 * @param orderAmount 调整后的价格,订单总额
	 * @return
	 */
	@RequestMapping("/refundReturn")
	public @ResponseBody Map<String, Object> refundReturn(
			Model model,
			@RequestParam(required = false, value = "refundId", defaultValue = "") String refundId,
			@RequestParam(required = false, value = "sellerState", defaultValue = "") String sellerState,
			@RequestParam(required = false, value = "sellerMessage", defaultValue = "") String sellerMessage) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			refundReturnService.updateRefundReturnSeller(Integer.valueOf(refundId), Integer.valueOf(sellerState), sellerMessage, CacheUtils.getCacheUser().getStore().getStoreName());
			map.put("success", true);
		} catch (Exception e) {
			map.put("success", false);
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
		return map;
	}
	
	/**
	 * 进入订单退货确认收货
	 * 
	 * @Title: refundReturnConfirmIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundReturnConfirmIndex")
	public ModelAndView refundReturnConfirmIndex(
			@RequestParam(required = false, value = "refundId", defaultValue = "") String refundId) {
		try {
			ModelAndView model = new ModelAndView("/trade/trade_return_confirm");
			RefundReturn refundReturn = refundReturnService.findRefundReturnDetail(Integer.valueOf(refundId), null, CacheUtils.getCacheUser().getStore().getStoreId());
			model.addObject("refundReturn", refundReturn);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 订单退货确认收货
	 * @param model
	 * @return
	 */
	@RequestMapping("/refundReturnConfirm")
	public @ResponseBody Map<String, Object> refundReturnConfirm(
			Model model,
			@RequestParam(required = false, value = "refundId", defaultValue = "") String refundId,
			@RequestParam(required = false, value = "receiveMessage", defaultValue = "") String receiveMessage) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			refundReturnService.updateRefundReturnConfirm(Integer.valueOf(refundId), receiveMessage, CacheUtils.getCacheUser().getStore().getStoreName());
			map.put("success", true);
		} catch (Exception e) {
			map.put("success", false);
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
		return map;
	}
	
	/**
	 * 退货查询页面
	 * 
	 * @Title: refundReturnDetail
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundReturnDetail")
	public ModelAndView refundReturnDetail(@RequestParam(value = "refundId") Integer refundId) {
		try {
			ModelAndView model = new ModelAndView("/trade/trade_return_detail");
			RefundReturn refundReturn = refundReturnService.findRefundReturnDetail(Integer.valueOf(refundId), null, CacheUtils.getCacheUser().getStore().getStoreId());
			model.addObject("refundReturn", refundReturn);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 进入退货记录页
	 * 
	 * @Title: returnOrderList
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/returnOrderList")
	public ModelAndView refundReturnList(@RequestParam(required = false, value = "type", defaultValue = "") String type,
			   						    @RequestParam(required = false, value = "key", defaultValue = "") String key,
			   						    @RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNo,
			   						    @RequestParam(required = false, value = "startTime", defaultValue = "") String startTime,
			   						    @RequestParam(required = false, value = "endTime", defaultValue = "") String endTime) {
		try {
			ModelAndView model = new ModelAndView("/trade/trade_return_list");
			RefundReturn refundReturn = new RefundReturn();
			refundReturn.setStoreId(CacheUtils.getCacheUser().getStore().getStoreId());
			if(StringUtils.isNotBlank(key)){
				if("orderSn".equals(type)){
					refundReturn.setOrderSn(key);
					model.addObject("key", key);
				}else if("returnSn".equals(type)){
					refundReturn.setRefundSn(key);
					model.addObject("key", key);
				}else if("buyerName".equals(type)){
					refundReturn.setBuyerName(key);
					model.addObject("key", key);
				}
			}
			
			if(StringUtils.isNotBlank(startTime)){
				refundReturn.setStartTime(DateUtils.strToLong(startTime+" 00:00:00"));
				model.addObject("startTime", startTime);
			}
			
			if(StringUtils.isNotBlank(endTime)){
				refundReturn.setEndTime(DateUtils.strToLong(endTime+" 23:59:59"));
				model.addObject("endTime", endTime);
			}
			
			Pager pager = new Pager();
			if(StringUtils.isNotBlank(pageNo)){
				pager.setPageNo(Integer.valueOf(pageNo));
			}
			pager.setPageSize(5);
			pager.setCondition(refundReturn);
			
	        List<RefundReturn> refundReturnList = refundReturnService.findRefundReturnPagerList(pager);// 结果集
	        pager.setResult(refundReturnList);
	        model.addObject("pager", pager);
	        model.addObject("list", refundReturnList); //结果集
	        model.addObject("pageNo", pager.getPageNo());//当前页
			model.addObject("pageSize", 5);//每页显示条数
	        model.addObject("recordCount", pager.getTotalRows());//总数
	        model.addObject("toUrl", "/trade/refundReturnList");//总数
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 评价管理
	 * @Title: main 
	 * @Description: TODO(这里用一句话描述这个方法的作用) 
	 * @param @return    设定文件 
	 * @return ModelAndView    返回类型 
	 */
//	@RequestMapping("/review")
//	public ModelAndView review(){
//		try{
//			ModelAndView model = new ModelAndView("/trade/trade_review");
//			model.addObject("apm", "trade");
//			return model;
//		}catch (Exception e) {
//			e.printStackTrace();
//			log.error("评价管理管理首页加载失败！");
//			throw new RuntimeException("导航失败!");
//			
//		}
//	}
	
	/**
	 * 评价管理
	 * @Title: list 
	 * @Description: TODO(这里用一句话描述这个方法的作用) 
	 * @param @return    设定文件 
	 * @return ModelAndView    返回类型 
	 */
	@RequestMapping(value = "/review")
	public String review(
			Model model){
		try {
			Store store = CacheUtils.getCacheUser().getStore();
			EvaluateStore evaluateStore = evaluateStoreService.findEvaluateStore(store.getStoreId());
			model.addAttribute("evaluateStore", evaluateStore);
			model.addAttribute("store", store);
			return "/trade/trade_review";
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 评价管理
	 * @Title: list 
	 * @Description: TODO(这里用一句话描述这个方法的作用) 
	 * @param @return    设定文件 
	 * @return ModelAndView    返回类型 
	 */
	@RequestMapping(value = "/reviewList")
	public String reviewlist(
			Model model,
			@RequestParam(required=false, value="pageNo",defaultValue="")String pageNoStr,
			@RequestParam(required=false, value="startDate",defaultValue="")String startDate,
			@RequestParam(required=false, value="stype",defaultValue="")String stype,
			@RequestParam(required=false, value="svalue",defaultValue="")String svalue,
			@RequestParam(required=false, value="gevalscore",defaultValue="")String gevalscore,
			@RequestParam(required=false, value="havecontent",defaultValue="")String havecontent){
		try {
			Pager pager = new Pager();
			EvaluateGoods evaluateGoods = new EvaluateGoods();
			
			/**时间格式*/
			String sourcePattern = "yyyy-MM-dd HH:mm:ss";
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			/**当前时间*/
			String dateString = format.format(new Date());
			
			/**查询条件，放入实体中，**/
//			if(startDate.equals("1") || StringUtils.isBlank(startDate)){
//				evaluateGoods.setStartTime(DateUtils.strToLong(DateUtils.getMonth(dateString, sourcePattern, sourcePattern, -3)));
//				evaluateGoods.setEndTime(System.currentTimeMillis());
//			}else if(startDate.equals("2")){
//				evaluateGoods.setStartTime(DateUtils.strToLong(DateUtils.getMonth(dateString, sourcePattern, sourcePattern, -12)));
//				evaluateGoods.setEndTime(DateUtils.strToLong(DateUtils.getMonth(dateString, sourcePattern, sourcePattern, -3)));
//			}
			if(StringUtils.isNotBlank(stype)&&StringUtils.isNotBlank(svalue))
				if(stype.equals("1")){
					evaluateGoods.setGevalGoodsName(svalue);
				}else if(stype.equals("2")){
					evaluateGoods.setGevalFrommembername(svalue);
				}
			
			if(StringUtils.isNotBlank(pageNoStr)){
				pager.setPageNo(Integer.parseInt(pageNoStr));
			}
			evaluateGoods.setGevalStoreId(CacheUtils.getCacheUser().getStore().getStoreId());
			//设置评分等级条件
			if(StringUtils.isNotEmpty(gevalscore) && !"0".equals(gevalscore)){
				evaluateGoods.setGevalScore(Integer.parseInt(gevalscore));
			}
			//设置有无评分内容
			
			//有评分内容
			if(StringUtils.isNotEmpty(havecontent) && "1".equals(havecontent)){
				evaluateGoods.setHaveContent(Integer.parseInt(havecontent));
			}
			//无评分内容
			if(StringUtils.isNotEmpty(havecontent) && "2".equals(havecontent)){
				evaluateGoods.setHaveContent(Integer.parseInt(havecontent));
			}
			pager.setCondition(evaluateGoods);//实体加载在pager中
			
			List<EvaluateGoods> results = evaluateGoodsService.findPageList(pager);// 结果集
			
			model.addAttribute("datas", results);// 结果集
			model.addAttribute("pageNo", pager.getPageNo());// 当前页
			model.addAttribute("pageSize", pager.getPageSize());// 每页显示条数
			model.addAttribute("recordCount", pager.getTotalRows());// 总数
			model.addAttribute("pageCount", pager.getTotalRows());// 总数
			model.addAttribute("toUrl","/trade/reviewList");
			log.error(JsonUtils.toJsonStr(results));
			return "/trade/trade_review_list";
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("导航失败!");
		}
	}
	
	@RequestMapping("/reply")
	public @ResponseBody Map<String, String> reply(
			Model model,
			@RequestParam(required = false, value = "gevalId", defaultValue = "") String gevalId,
			@RequestParam(required = false, value = "gevalExplain", defaultValue = "") String gevalExplain) {
		Map<String, String> map = Maps.newHashMap();
		try {
			EvaluateGoods goods = new EvaluateGoods();
			goods.setGevalId(Integer.parseInt(gevalId));
			goods.setGevalExplain(gevalExplain);
			goods.setUpdateTime(System.currentTimeMillis());
			evaluateGoodsService.update(goods);
			map.put(message, "true");
		} catch (Exception e) {
			e.printStackTrace();
			map.put(message, "false");
			map.put("msg", "获取对象为空！");
		}
		return map;
	}
	
	
	
	/**
	 * 支付方式
	 * @Title: main 
	 * @Description: TODO(这里用一句话描述这个方法的作用) 
	 * @param @return    设定文件 
	 * @return ModelAndView    返回类型 
	 */
	@RequestMapping("/payment")
	public ModelAndView payment(){
		try{
			ModelAndView model = new ModelAndView("/trade/trade_payment");
			return model;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("支付方式加载失败！");
			throw new RuntimeException("导航失败!");
			
		}
	}
	
	/**
	 * 订单打印页面跳转
	 * @param model
	 * @param orderId 订单编号
	 * @return
	 */
	@RequestMapping(value = "/printOrder")
	public String printOrder(
			Model model,
			@RequestParam(required=false, value="orderId",defaultValue="")String orderId){
		try {
			Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
			Order results = orderService.findOrderDetail(Integer.valueOf(orderId),null,storeId); //结果集
			model.addAttribute("order", results);// 结果集
			return "/trade/print_order";
		} catch (Exception e) {
            log.error("订单打印页面跳转失败",e.toString());
			throw new RuntimeException("导航失败!");
		}
	}
	/**
	 * 商品评论信息上传
	 * @return
	 */
	 @RequestMapping(value = "/fileexcelUpload")
	    public  @ResponseBody Map<String,Object>  fileexcelUpload(@RequestParam MultipartFile files,HttpServletResponse response) throws IOException {
	    	Map<String,Object> map = Maps.newHashMap();
	    	String message="";
	        EvaluateGoodsExcel excelgoods=new EvaluateGoodsExcel();
	        try {
	        	@SuppressWarnings("unchecked")
				List<EvaluateGoodsExcel> evaluategoodslist=(List<EvaluateGoodsExcel>) ImportExcelsellerUtils.readExcelTitle(files.getInputStream(),excelgoods);
	        	if(evaluategoodslist.size()!=0){
	        		//保存评价
	        		saveevalueategoods(evaluategoodslist);
	        		map.put("success",true);
	        		message="生成成功";
	        	}
	        } catch (IOException e) {
	            log.error("上传文件失败", e.toString());
	            e.printStackTrace();
	            message="生成失败";
	        } catch (Exception e) {
	        	message="生成失败";
				e.printStackTrace();
			}
	        map.put("message",message);
	        String json = JsonUtils.toJsonStr(map);
	        response.setContentType("text/html");
	        response.setCharacterEncoding("utf-8");
	        response.getWriter().write(json);
	        return null;
	    }
	    
	    /**
	     * 保存评论信息
	     * @param list
	     */
		public void saveevalueategoods(List<EvaluateGoodsExcel> list){
	    	//遍历解析到的评价list信息
	    	for(EvaluateGoodsExcel evaluateGoodsExcel:list){
	    		 EvaluateGoods evaluateGoods=new EvaluateGoods();
 			 if(evaluateGoodsExcel!=null){
 				 if(evaluateGoodsExcel.getGevalGoodsId()!=null){
 					 //根据商品id获得商品信息
 					 Goods goods=goodsService.findGoodById(evaluateGoodsExcel.getGevalGoodsId());
 					 //根据店铺id获取店铺信息
 					 if(goods!=null&&goods.getStoreId()!=null){
 						 Store store=storeService.findById(goods.getStoreId());
 						 evaluateGoods.setGevalStoreId(store.getStoreId());//保存店铺id
 						 evaluateGoods.setGevalStorename(store.getStoreName());//保存店铺名称
 					   }
 				     }
 				     //保存商品id
	    				 evaluateGoods.setGevalGoodsId(evaluateGoodsExcel.getGevalGoodsId());
	    				 //评价分数
	    				 evaluateGoods.setGevalScore(evaluateGoodsExcel.getGevalScore());
	    				 //商品名称
	    				 evaluateGoods.setGevalGoodsName(evaluateGoodsExcel.getGevalGoodsName());
	    				 //评价内容
	    				 evaluateGoods.setGevalContent(evaluateGoodsExcel.getGevalContent());
	    				 //评价者名称
	    				 evaluateGoods.setGevalFrommembername(evaluateGoodsExcel.getGevalFrommembername());
	    				 //评价者id
	    				 evaluateGoods.setGevalFrommemberid(18);
	    				 //0表示不是 1表示是匿名评价
	    				 evaluateGoods.setGevalIsAnonymous(evaluateGoodsExcel.getGevalIsAnonymous());
	    				 //评价信息的状态 0为正常 1为禁止显示
	    				 evaluateGoods.setGevalState(evaluateGoodsExcel.getGevalState());
	    				 //订单表自增ID
	    				 evaluateGoods.setGevalOrderId(49);
	    				 //订单编号
	    				 evaluateGoods.setGevalOrderNo(System.currentTimeMillis());
	    				 //订单商品表编号
	    				 evaluateGoods.setGevalOrderGoodsId(99);
	    				 //商品价格
	    				 //evaluateGoods.setGevalGoodsPrice(evaluateGoodsExcel.getGevalGoodsPrice());
	    				 //规格描述
	    				 evaluateGoods.setSpecInfo(evaluateGoodsExcel.getSpecInfo());
	    				 //评价时间
    					 evaluateGoods.setCreateTime(evaluateGoodsExcel.getCreateTime());
	    				 //保存评价信息
	    				 evaluateGoodsService.saveEvaluate(evaluateGoods);
	    				 //释放资源
	    				 evaluateGoods=null;
 			 }
 		 }
	    }
}