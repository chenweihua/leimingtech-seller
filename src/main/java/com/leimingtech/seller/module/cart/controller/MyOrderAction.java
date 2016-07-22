package com.leimingtech.seller.module.cart.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.joda.time.DateTime;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.common.collect.Maps;
import com.leimingtech.core.common.CommonConstants;
import com.leimingtech.core.common.Constants;
import com.leimingtech.core.common.DateUtils;
import com.leimingtech.core.entity.Order;
import com.leimingtech.core.entity.base.Member;
import com.leimingtech.core.entity.base.OrderGoods;
import com.leimingtech.core.entity.base.RefundLog;
import com.leimingtech.core.entity.base.RefundReturn;
import com.leimingtech.core.entity.vo.ReturnDetailVo;
import com.leimingtech.core.jackson.JsonUtils;
import com.leimingtech.seller.utils.sessionKey.CacheUtils;
import com.leimingtech.service.module.member.service.MemberService;
import com.leimingtech.service.module.trade.common.OrderState;
import com.leimingtech.service.module.trade.service.OrderGoodsService;
import com.leimingtech.service.module.trade.service.OrderService;
import com.leimingtech.service.module.trade.service.RefundLogService;
import com.leimingtech.service.module.trade.service.RefundReturnService;
import com.leimingtech.service.utils.page.Pager;

/**
 * 
 * 项目名称：leimingtech-front 类名称：MyOrderAction 类描述： 创建人：weiyue 创建时间：2014年12月25日
 * 下午9:34:55 修改人：liuhao 修改时间：2014年12月25日 下午9:34:55 修改备注：
 * @version
 */
@Controller
@RequestMapping("/user")
@Slf4j
public class MyOrderAction {

	@Resource
	private OrderService orderService;
	
    @Resource
    private MemberService memberService;
    
    @Resource
    private RefundLogService refundLogService;
    
    @Resource
    private OrderGoodsService orderGoodsService;
    
    @Resource
    private RefundReturnService refundReturnService; 
	
	/**
	 * 导航主页面跳转,跳转到个人商家首页页面
	 * 
	 * @Title: index
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/index")
	public ModelAndView index() {
		try {
			ModelAndView model = new ModelAndView("/user/order/my-order");
			Member member =  memberService.findMemberById(CacheUtils.getCacheUser().getMember().getMemberId());
	        model.addObject("member",member);
	        model.addObject("apm", "index");
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！",e.toString());
			throw new RuntimeException("导航失败!");
		}
	}

	/**
	 * 订单购物车列表页面
	 * 
	 * @Title: list
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/list")
	public ModelAndView List(
			@RequestParam(required=false, value="pageNo",defaultValue="")String pageNo,
            @RequestParam(required=false, value="orderSn",defaultValue="")String orderSn,
			@RequestParam(required = false, value = "startTime", defaultValue = "") String startTime,
			@RequestParam(required = false, value = "endTime", defaultValue = "") String endTime,
			@RequestParam(required = false, value = "orderState", defaultValue = "") String orderState,
			@RequestParam(required = false, value = "evaluationStatus", defaultValue = "") String evaluationStatus,
			@RequestParam(required = false, value = "lockState", defaultValue = "") String lockState) {
		try {
			ModelAndView model = new ModelAndView("/cart/order/my-order-list");
			Member member =  memberService.findMemberById(CacheUtils.getCacheUser().getMember().getMemberId());
			Pager page = new Pager();
			if(StringUtils.isNotEmpty(pageNo)){
				page.setPageNo(Integer.parseInt(pageNo));
			}
			if(StringUtils.isNotEmpty(evaluationStatus)){
				orderState = OrderState.ORDER_STATE_FINISH+""; //若查询订单评价状态,就是查询已完成订单
			}
			
			model.addObject("member",member);
	        model.addObject("pageNo", page.getPageNo());//当前页
	        model.addObject("pageSize", 20);//分页条数默认为20条
	        model.addObject("toUrl", "/user/list");//跳转页面
	        model.addObject("orderState", orderState);
	        model.addObject("evaluationStatus", evaluationStatus);
	        model.addObject("orderSn", orderSn);
	        model.addObject("startTime", startTime);
	        model.addObject("endTime", endTime);
	        model.addObject("lockState",lockState);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}

	/**
	 * 订单详情页面
	 * @Title: detail
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/detail")
	public ModelAndView detail(
			@RequestParam(required = false, value = "orderId", defaultValue = "") String orderId) {
		try {
			ModelAndView model = new ModelAndView("/cart/order/my-order-detail");
			model.addObject("orderId", orderId);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
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
			ModelAndView model = new ModelAndView("/cart/order/my-order-cancel");
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
	 * 
	 * @Title: cancelOrder
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return Map<String,Object> 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/cancelOrder")
	@ResponseBody
	public Map<String,Object> cancelOrder(
			@RequestParam(required = false, value = "orderSn", defaultValue = "") String orderSn,
			@RequestParam(required = false, value = "cancelCause", defaultValue = "") String cancelCause
			) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			orderService.updateCancelOrder(orderSn,cancelCause,1);
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
	 * 进入订单完成页
	 * 
	 * @Title: finishOrderIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/finishOrderIndex")
	public ModelAndView finishOrderIndex(
			@RequestParam(required = false, value = "orderSn", defaultValue = "") String orderSn) {
		try {
			ModelAndView model = new ModelAndView("/cart/order/my-order-finish");
			model.addObject("orderSn", orderSn);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 订单完成
	 * 
	 * @Title: finishOrder
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/finishOrder")
	@ResponseBody
	public Map<String,Object> finishOrder(
			@RequestParam(required = false, value = "orderSn", defaultValue = "") String orderSn) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			orderService.updateFinishOrder(orderSn);
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
	 * @Title: refundOrderIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundOrderIndex")
	public ModelAndView refundOrderIndex(
			@RequestParam(required = false, value = "orderId", defaultValue = "") String orderId) {
		try {
			ModelAndView model = new ModelAndView("/cart/order/my-order-refund");
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
	 * 订单退款
	 * 
	 * @Title: refundOrder
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundOrder")
	@ResponseBody
	public Map<String,Object> refundOrder(
			@RequestParam(required = false, value = "orderId", defaultValue = "") String orderId,
			@RequestParam(required = false, value = "orderRefund", defaultValue = "") Double orderRefund,
			@RequestParam(required = false, value = "buyerMessage", defaultValue = "") String buyerMessage) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			BigDecimal.valueOf(orderRefund.doubleValue());
			orderService.addOrderRefund(Integer.valueOf(orderId), BigDecimal.valueOf(orderRefund) , buyerMessage);
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
	 * 退款查询页面
	 * 
	 * @Title: refundLogDetail
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundLogDetail")
	public ModelAndView refundLogDetail(@RequestParam(value = "logId") Integer logId) {
		try {
			ModelAndView model = new ModelAndView("/cart/order/my-order-refund-detail");
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
	 * 退款查询列表
	 * 
	 * @Title: refundList
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundList")
	public ModelAndView refundList(@RequestParam(required = false, value = "type", defaultValue = "") String type,
								   @RequestParam(required = false, value = "key", defaultValue = "") String key,
								   @RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNo,
								   @RequestParam(required = false, value = "startTime", defaultValue = "") String startTime,
								   @RequestParam(required = false, value = "endTime", defaultValue = "") String endTime) {
		try {
			ModelAndView model = new ModelAndView("/cart/order/my-order-refund-list");
			Member member =  memberService.findMemberById(CacheUtils.getCacheUser().getMember().getMemberId());
	        model.addObject("member",member);
			RefundLog refundLog = new RefundLog();
			refundLog.setBuyerId(CacheUtils.getCacheUser().getMember().getMemberId());
			
			if(StringUtils.isNotBlank(key)){
				if("orderSn".equals(type)){
					refundLog.setOrderSn(key.trim());
					model.addObject("key", key);
				}else if("refundSn".equals(type)){
					refundLog.setRefundSn(key.trim());
					model.addObject("key", key);
				}else if("storeName".equals(type)){
					refundLog.setStoreName(key.trim());
					model.addObject("key", key);
				}
			}
			
			if(StringUtils.isNotBlank(startTime)){
				refundLog.setStartTime(DateUtils.strToLong(startTime+" 00:00:00"));
				model.addObject("startTime", startTime);
			}
			
			if(StringUtils.isNotBlank(endTime)){
				refundLog.setEndTime(DateUtils.strToLong(endTime+" 23:59:59"));
				model.addObject("endTime", endTime);
			}
			
			Pager pager = new Pager();
			if(StringUtils.isNotEmpty(pageNo)){
				pager.setPageNo(Integer.parseInt(pageNo));
			}
			pager.setPageSize(5);
			pager.setCondition(refundLog);
			
	        List<RefundLog> refundLogList = refundLogService.findRefundLogList(pager);// 结果集
	        pager.setResult(refundLogList);
	        model.addObject("type",type); 
	        model.addObject("key",key);
	        model.addObject("pager", pager);
	        model.addObject("list", refundLogList); //结果集
	        model.addObject("pageNo", pager.getPageNo());//当前页
			model.addObject("pageSize", 5);//每页显示条数
	        model.addObject("recordCount", pager.getTotalRows());//总数
	        model.addObject("toUrl", "/user/refundList");//总数
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
	public ModelAndView refundReturnIndex(@RequestParam(required = false, value = "orderGoodsId", defaultValue = "") String orderGoodsId) {
		try {
			ModelAndView model = new ModelAndView("/cart/order/my-order-return");
			OrderGoods orderGoods = orderGoodsService.findOrderGoodsDetail(Integer.valueOf(orderGoodsId), CacheUtils.getCacheUser().getMember().getMemberId(), null);	
			//判断订单是否申请退货
			if(orderGoods.getGoodsReturnNum()==0){ //未申请
				model.addObject("orderGoods", orderGoods);
			}else{ //已申请
				model.addObject("orderGoods", null);
			}
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 订单退货
	 * 
	 * @Title: refundReturn
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundReturn")
	@ResponseBody
	public Map<String,Object> refundReturn(
			@RequestParam(required = false, value = "orderId", defaultValue = "") String orderId,
			@RequestParam(required = false, value = "buyerMessage", defaultValue = "") String buyerMessage,
			@RequestParam(required = false, value = "orderGoodsId", defaultValue = "") String orderGoodsId,
			@RequestParam(required = false, value = "goodsNum", defaultValue = "") String goodsNum,
			@RequestParam(required = false, value = "goodsImageMore", defaultValue = "") String goodsImageMore) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			orderService.addOrderReturn(Integer.valueOf(orderId), Integer.valueOf(goodsNum), buyerMessage, Integer.valueOf(orderGoodsId), goodsImageMore);
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
	 * 退货查询列表
	 * 
	 * @Title: returnList
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/returnList")
	public ModelAndView returnList(@RequestParam(required = false, value = "type", defaultValue = "") String type,
								   @RequestParam(required = false, value = "key", defaultValue = "") String key,
								   @RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNo,
								   @RequestParam(required = false, value = "startTime", defaultValue = "") String startTime,
								   @RequestParam(required = false, value = "endTime", defaultValue = "") String endTime) {
		try {
			ModelAndView model = new ModelAndView("/cart/order/my-order-return-goods-list");
			Member member =  memberService.findMemberById(CacheUtils.getCacheUser().getMember().getMemberId());
	        model.addObject("member",member);
			RefundReturn refundReturn = new RefundReturn();
			refundReturn.setBuyerId(CacheUtils.getCacheUser().getMember().getMemberId());
			
			if(StringUtils.isNotBlank(key)){
				if("orderSn".equals(type)){
					refundReturn.setOrderSn(key.trim());
					model.addObject("key", key);
				}else if("returnSn".equals(type)){
					refundReturn.setRefundSn(key.trim());
					model.addObject("key", key);
				}else if("storeName".equals(type)){
					refundReturn.setStoreName(key.trim());
					model.addObject("key", key);
				}
			}
			
			if(StringUtils.isNotBlank(startTime)){
				refundReturn.setStartTime(DateUtils.strToLong(startTime + " 00:00:00"));
				model.addObject("startTime", startTime);
			}
			
			if(StringUtils.isNotBlank(endTime)){
				refundReturn.setEndTime(DateUtils.strToLong(endTime + " 23:59:59"));
				model.addObject("endTime", endTime);
			}
			
			Pager pager = new Pager();
			if(StringUtils.isNotEmpty(pageNo)){
				pager.setPageNo(Integer.parseInt(pageNo));
			}
			pager.setPageSize(5);
			pager.setCondition(refundReturn);
			
	        List<RefundReturn> refundReturnList = refundReturnService.findRefundReturnPagerList(pager);// 结果集
	        pager.setResult(refundReturnList);
	        model.addObject("type",type); 
	        model.addObject("key",key);
	        model.addObject("pager", pager);
	        model.addObject("list", refundReturnList); //结果集
	        model.addObject("pageNo", pager.getPageNo());//当前页
			model.addObject("pageSize", 5);//每页显示条数
	        model.addObject("recordCount", pager.getTotalRows());//总数
	        model.addObject("toUrl", "/user/returnList");//总数
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
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
			ModelAndView model = new ModelAndView("/cart/order/my-order-return-detail");
			ReturnDetailVo returnDetailVo = refundReturnService.findRefundReturnDetail(refundId, CacheUtils.getCacheUser().getMember().getMemberId(), null);
			model.addObject("refundReturn", returnDetailVo);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 买家退货发货
	 * 
	 * @Title: refundReturnDelivery
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundReturnDeliveryIndex")
	public ModelAndView refundReturnDeliveryIndex(@RequestParam(value = "refundId") Integer refundId) {
		try {
			ModelAndView model = new ModelAndView("/cart/order/my-order-return-delivery");
			ReturnDetailVo returnDetailVo = refundReturnService.findRefundReturnDetail(refundId, CacheUtils.getCacheUser().getMember().getMemberId(), null);
			//List<Express> list = expressService.findExpressListByState(1,null);//查询所有物流公司
			model.addObject("refundReturn", returnDetailVo);
			//model.addObject("expressList",list);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 买家退货发货
	 * 
	 * @Title: refundReturnDelivery
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/refundReturnDelivery")
	@ResponseBody
	public Map<String,Object> refundReturnDelivery(
			@RequestParam(value = "refundId") Integer refundId,
			@RequestParam(value = "expressName") String expressName,
			@RequestParam(value = "invoiceNo") String invoiceNo) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			refundReturnService.updaterefundReturnDelivery(refundId, expressName, invoiceNo);
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
	 * 进入退货完成页
	 * 
	 * @Title: finishReturnIndex
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/finishReturnIndex")
	public ModelAndView finishReturnIndex(
			@RequestParam(value = "refundId") Integer refundId) {
		try {
			ModelAndView model = new ModelAndView("/cart/order/my-order-return-finish");
			RefundReturn refundReturn = refundReturnService.findRefundReturnDetail(refundId, CacheUtils.getCacheUser().getMember().getMemberId(), null);
			model.addObject("refundReturn", refundReturn);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("卖家中心首页加载失败！");
			throw new RuntimeException("导航失败!");
		}
	}
	
	/**
	 * 退货完成
	 * 
	 * @Title: finishOrder
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param apm 加载的
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws RuntimeException
	 */
	@RequestMapping("/finishReturn")
	@ResponseBody
	public Map<String,Object> finishReturn(
			@RequestParam(value = "returnId") Integer returnId) {
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			//refundReturnService.updateReturnFinish(returnId);
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
	 * 退货图片上传
	 * @param myfiles
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/returnImageFileUpload")
    public String returnImageFileUpload(@RequestParam MultipartFile[] myfiles, HttpServletRequest request, HttpServletResponse response){
    	response.setContentType("text/plain; charset=UTF-8");
    	response.setContentType("text/html");
    	//可以在上传文件的同时接收其它参数
        Map<String, Object> map = Maps.newHashMap();
        //已上传评论图片数量
        String imgNo = request.getParameter("imgNo");
        //判断评论上传图片不能大于三张
    	if(myfiles.length+Integer.valueOf(imgNo)>3){
    		map.put("success",false);
    		map.put("result", "最多上传三张图片");
    		String json = JsonUtils.toJsonStr(map);
    		try {
				response.getWriter().write(json);
				return null;
			} catch (IOException e) {
				e.printStackTrace();
			}
    	}
		String type = request.getParameter("type");
		
        
        String originalFilename = null;
        
        StringBuffer photoSrc = new StringBuffer();//StringBuffer用来存放上传文件的所有地址
        StringBuffer photoNewName = new StringBuffer();//用来存放图片的新名字
        StringBuffer oldName = new StringBuffer();//原来的名字
        for(MultipartFile myfile : myfiles){
            if(myfile.isEmpty()){
                map.put("result", "请选择文件后上传");
                map.put("success", false);
            }else{
                originalFilename = String.valueOf(new DateTime().getMillis())+ myfile.getOriginalFilename().substring( myfile.getOriginalFilename().indexOf("."));
               try {
					Thread.sleep(100);
				} catch (InterruptedException e1) {
					// TODO Auto-generated catch block
					log.error("",e1);
				}                
                try {
            		String realPath = CommonConstants.FILE_BASEPATH + Constants.RETURN_ORDER_UPLOAD_URL + "/" ;
            		//这里不必处理IO流关闭的问题,因为FileUtils.copyInputStreamToFile()方法内部会自动把用到的IO流关掉
            		//此处也可以使用Spring提供的MultipartFile.transferTo(File dest)方法实现文件的上传
            		FileUtils.copyInputStreamToFile(myfile.getInputStream(), new File(realPath, originalFilename));
            		//上传成功的时候将图片的地址给已经准备好的Stringbuffer
            		photoSrc.append(CommonConstants.FILE_BASEPATH + Constants.RETURN_ORDER_UPLOAD_URL+"/" + originalFilename + ",");
            		//上传成功的时候将图片的新名字给StringBuffer
            		photoNewName.append(originalFilename +  ",");
                } catch (IOException e) {
                	if("attach"==type){
                		log.error("文件[" + myfile.getOriginalFilename() + "]上传失败,堆栈轨迹如下");
                	}else{
                		log.error("文件[" + originalFilename + "]上传失败,堆栈轨迹如下");
                	}
                    map.put("result", "文件上传失败，请重试！！");
                    map.put("success", false);
                    
                }
            }
        }
        if("attach".equals(type)){
        	 map.put("oldName", oldName.toString());
        }
        map.put("imgPath",Constants.RETURN_ORDER_UPLOAD_URL+ "/");
        map.put("photoNewName", photoNewName.toString());
        map.put("photoSrc", photoSrc.toString());
        map.put("filename", originalFilename);
		map.put("success", true);
		map.put("listimgSize", myfiles.length+"");
		String json = JsonUtils.toJsonStr(map);
		try {
			response.getWriter().write(json);
		} catch (IOException e) {
			e.printStackTrace();
		}
        return null;
    }
}
