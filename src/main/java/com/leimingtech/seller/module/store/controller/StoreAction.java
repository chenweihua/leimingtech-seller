package com.leimingtech.seller.module.store.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.common.collect.Maps;
import com.leimingtech.core.common.CommonConstants;
import com.leimingtech.core.common.Constants;
import com.leimingtech.core.entity.base.Goods;
import com.leimingtech.core.entity.base.Store;
import com.leimingtech.core.entity.base.Upload;
import com.leimingtech.core.jackson.JsonUtils;
import com.leimingtech.seller.utils.sessionKey.CacheUser;
import com.leimingtech.seller.utils.sessionKey.CacheUtils;
import com.leimingtech.seller.utils.twodimencode.TwoDimensionCode;
import com.leimingtech.service.module.goods.service.GoodsService;
import com.leimingtech.service.module.store.service.EvaluateStoreService;
import com.leimingtech.service.module.store.service.StoreGoodsClassService;
import com.leimingtech.service.module.store.service.StoreService;
import com.leimingtech.service.module.store.service.UploadService;
import com.leimingtech.service.utils.page.Pager;

/**
 * 
 * 
 * @项目名称：leimingtech-seller
 * @类名称：StoreAction
 * @类描述： 店铺模块
 * @修改备注：
 * @version
 * 
 */
@Controller
@RequestMapping("/store")
@Slf4j
public class StoreAction {

	String message = "success";

	@Resource
	private StoreService storeService;

	// @Resource
	// private StoreJoininService storeJoininService;

	@Resource
	private StoreGoodsClassService storeGoodsClassService;

	@Resource
	private EvaluateStoreService evaluateStoreService;

	@Resource
	private GoodsService goodsService;

	@Resource
	private UploadService uploadService;

	/**
	 * 
	 * @Title: info
	 * @Description: TODO(店铺信息)
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws
	 */
	@RequestMapping(value = "/info")
	public ModelAndView info() {
		ModelAndView model = new ModelAndView("/store/shop-info");

		Integer id = CacheUtils.getCacheUser().getMember().getMemberId();
		// Store store = storeService.findById(id);
		// StoreJoinin storeJoinin = storeJoininService.findById((long)id);
		// model.addObject("storeJoinin", storeJoinin);
		return model;
	}

	/**
	 * 我的店铺 TODO 此功能应该在前台，而不是卖家中心
	 * 
	 * @return
	 */
	/*
	 * @Deprecated
	 * 
	 * @RequestMapping(value = "/shop") public ModelAndView shop() {
	 * ModelAndView model = new ModelAndView("/store/shop-my"); int storeId =
	 * CacheUtils.getCacheUser().getStore().getStoreId(); StoreVo storeVo =
	 * storeService.findVoById(storeId); List<ImageVo> imageVoList =
	 * Util.getImageList(storeVo); StoreGoodsClassVo storeGoodsClassVo = new
	 * StoreGoodsClassVo(); storeGoodsClassVo.setStoreId(storeId);
	 * storeGoodsClassVo.setParentState(true);
	 * storeGoodsClassVo.setChildState(true); List<StoreGoodsClassVo>
	 * goodClassList =
	 * storeGoodsClassService.queryClasssList(storeGoodsClassVo);
	 * ShopEvaluateStore evaluateStore =
	 * evaluateStoreService.findEvaluateStore(storeId);
	 * model.addObject("storeVo", storeVo); model.addObject("imageDatas",
	 * imageVoList); model.addObject("evaluateStore", evaluateStore);
	 * model.addObject("catagoryDatas", goodClassList);
	 * 
	 * return model; }
	 */

	/**
	 * 出售中的商品查询
	 * 
	 * @Title: saleList
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws
	 */
	@RequestMapping(value = "/goodList")
	public String goodList(
			@RequestParam(required = false, value = "orderBy", defaultValue = "") String orderBy,
			@RequestParam(required = false, value = "goodName", defaultValue = "") String goodName,
			@RequestParam(required = false, value = "sort", defaultValue = "") String sort,
			@RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNoStr,
			@RequestParam(required = false, value = "div", defaultValue = "") String div,
			Model model) {
		Pager pager = new Pager();
		Goods goods = new Goods();
		List<Goods> goodList = new ArrayList<Goods>();
		goods.setGoodsShow(1);// 上架状态的

		goods.setStoreId(1);

		/*
		 * if (StringUtils.) { goods.setGoodsName(goodName);//商品名称 }
		 * 
		 * if (!sort.equals("")) { goods.setGoodsStcids(sort); }
		 * 
		 * if(!)
		 */

		pager.setPageSize(6);

		if (StringUtils.isNotBlank(pageNoStr)) {
			pager.setPageNo(Integer.parseInt(pageNoStr));
		}

		pager.setCondition(goods);// 实体加载在pager中

		goodList = goodsService.findGoodPagerList(pager);
		model.addAttribute("goodsDatas", goodList);// 结果集合
		model.addAttribute("pageNo", pager.getPageNo());// 当前页
		model.addAttribute("pageSize", pager.getPageSize());// 每页显示条数
		model.addAttribute("recordCount", pager.getTotalRows());// 总数
		model.addAttribute("toUrl", "store/goodsList");// 跳转URL
		model.addAttribute("div", "goodsListDiv");// 显示的DIV数据区域
		return "/store/shop-my-list";
	}

	@RequestMapping("/slide")
	public String slide(Model model) {

		List<Upload> list = uploadService.findByStore(CacheUtils.getCacheUser()
				.getStore().getStoreId());
		if (CollectionUtils.isNotEmpty(list)) {
			Store store = storeService.findById(CacheUtils.getCacheUser()
					.getStore().getStoreId());
			String[] urls = store.getStoreSlideUrl().split(",");
			int index = 0;
			for (Upload upload : list) {
				upload.setImgUrl(urls[index]);
				index++;
			}
		}
		model.addAttribute("list", list);
		return "store/shop-slide";
	}

	@RequestMapping(value = "/fileUpload")
	public String fileUpload(@RequestParam MultipartFile[] myfiles,
			@RequestParam int index, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 可以在上传文件的同时接收其它参数
		Map<String, Object> map = Maps.newHashMap();
		response.setContentType("text/plain; charset=UTF-8");
		String originalFilename = null;
		for (MultipartFile myfile : myfiles) {
			if (myfile.isEmpty()) {

				map.put("result", "请选择文件后上传");
				map.put(message, false);
			} else {
				originalFilename = String.valueOf(new DateTime().getMillis())
						+ myfile.getOriginalFilename().substring(
								myfile.getOriginalFilename().indexOf("."));
				map.put("result", Constants.LOGO_UPLOAD_URL + "/"
						+ originalFilename);
				map.put("data", "filename=" + Constants.LOGO_UPLOAD_URL + "/"
						+ originalFilename + ";filesize=" + myfile.getSize()
						+ ";index=" + index);
				map.put(message, true);
				try {
					// 这里不必处理IO流关闭的问题,因为FileUtils.copyInputStreamToFile()方法内部会自动把用到的IO流关掉
					// 此处也可以使用Spring提供的MultipartFile.transferTo(File
					// dest)方法实现文件的上传
					FileUtils.copyInputStreamToFile(myfile.getInputStream(),
							new File(CommonConstants.FILE_BASEPATH
									+ Constants.LOGO_UPLOAD_URL,
									originalFilename));
				} catch (IOException e) {
					log.error("文件[" + originalFilename + "]上传失败,堆栈轨迹如下");
					map.put("result", "文件上传失败，请重试！！");
					map.put(message, false);

				}
			}
		}
		String json = JsonUtils.toJsonStr(map);
		response.setContentType("text/html");
		response.getWriter().write(json);

		return null;
	}

	@RequestMapping("/saveSlide")
	public String saveSlide(@RequestParam String[] slide,
			@RequestParam String[] imgurls) {

		uploadService.saveUploadSilde(slide, imgurls);
		return "redirect:/store/slide";
	}

	/**
	 * 店铺主题
	 * 
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/storethem")
	public ModelAndView tradetool() {
		try {
			Store store = CacheUtils.getCacheUser().getStore();
			// 因为缓存里的店铺信息不能及时更新所以得查一遍
			Store store2 = storeService.findById(store.getStoreId());
			ModelAndView model = new ModelAndView("/store/storeTheme");
			model.addObject("store", store2);
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("店铺主题加载失败！");
			throw new RuntimeException("店铺主题加载失败!");
		}
	}

	/**
	 * 合作伙伴管理
	 * 
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/storepartner")
	public ModelAndView storepartner() {
		try {
			ModelAndView model = new ModelAndView("/store/store_partner");
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("店铺主题加载失败！");
			throw new RuntimeException("店铺主题加载失败!");
		}
	}

	/**
	 * 导航管理
	 * 
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/storenavigation")
	public ModelAndView storenavigation() {
		try {
			ModelAndView model = new ModelAndView("/store/store_navigation");
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("导航管理加载失败！");
			throw new RuntimeException("导航管理加载失败!");
		}
	}

	/**
	 * 导航管理
	 * 
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/storenavigationadd")
	public ModelAndView storenavigationadd() {
		try {
			ModelAndView model = new ModelAndView("/store/store_navigation_add");
			return model;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("导航管理加载失败！");
			throw new RuntimeException("导航管理加载失败!");
		}
	}

	@RequestMapping("/save")
	public @ResponseBody Map<String, Object> saveJoinIn(
			@ModelAttribute Store store) {
		Map<String, Object> map = Maps.newHashMap();
		Store cheststore = storeService.findByStorename(store.getStoreName());
		CacheUser member = CacheUtils.getCacheUser();
		if (cheststore == null) {
			store.setMemberId(member.getMember().getMemberId());
			store.setMemberName(member.getMember().getMemberName());
			store.setStoreState(2);// 店铺状态，0关闭，1开启，2审核中
			store.setStoreRecommend(0);// 推荐，0为否，1为是，默认为0
			store.setNameAuth(0);
			store.setGradeId(1);// 等级  默认为白金等级
			store.setStoreTheme("default");// 默认主题
			store.setStoreSales(0);// 店铺销量
			store.setStoreCollect(0);// 店铺收藏数量
			store.setStoreClick(0);// 店铺点击量
			store.setStoreCredit(0);// 店铺信用
			store.setPraiseRate(0f);// 店铺好评率

			storeService.save(store);
			map.put("success", true);
			map.put("message", "提交成功");
		} else {
			map.put("success", false);
			map.put("message", "提交失败");
		}
		return map;
	}

	@RequestMapping("/updateStore")
	public @ResponseBody Map<String, Object> updateStore(
			@ModelAttribute Store store,
			@RequestParam(required = false, value = "flag", defaultValue = "") String flag) {
		Map<String, Object> map = Maps.newHashMap();
		try {
			if(flag.equals("recheck")){
				store.setStoreState(2);//如果确认为审核未通过，则初始化为审核中
			}
			storeService.updateStore(store);
			map.put("success", true);
			if(flag.equals("recheck")){
				map.put("message", "修改成功,待平台管理员审核!");
			}else{
				map.put("message", "修改成功");
			}
		} catch (Exception e) {
			log.debug("店铺修改失败", e);
			map.put("success", false);
			map.put("message", "修改失败");
		}
		return map;
	}
    
	/**
	 * 店铺名称是否重复
	 * 
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/checkStorename")
	public @ResponseBody boolean checkStorename(@RequestParam String storename) {
		Store store = storeService.findByStorename(storename);
		if (storeService.findByStorename(storename) != null) {
			return false;
		} else {
			return true;
		}
	}
	
	/**
	 * 生产二维码
	 * 
	 */
	@RequestMapping("/createtwocode")
    public @ResponseBody Map<String,Object> createtwocode() {
    	Map<String,Object> map = Maps.newHashMap();
    	File file=new File(CommonConstants.FILE_BASEPATH+Constants.STORE_TWOCODE_URL);  
    	Long strtime=new DateTime().getMillis();
    	String frontserver=CommonConstants.FRONT_SERVER+"/store/shop?storeId="+CacheUtils.getCacheUser().getStore().getStoreId();
    	//如果文件夹不存在则创建    
    	if  (!file .exists()  && !file .isDirectory())      
    	{       
    	     file .mkdir();    
    	}else{  
    	    String imgPath = CommonConstants.FILE_BASEPATH+Constants.STORE_TWOCODE_URL+"/"+strtime+".png";
            String encoderContent =frontserver;  
            TwoDimensionCode handler = new TwoDimensionCode();  
            handler.encoderQRCode(encoderContent, imgPath, "png");  
            System.out.println("========encoder success");  
            handler.decoderQRCode(imgPath);
            map.put("storetwocodeurl", Constants.STORE_TWOCODE_URL+"/"+strtime+".png");
            map.put("success",true);
            map.put("message","生成成功");
    	}   
    	return map;
    }
}
