package com.leimingtech.seller.module.product.controller;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.leimingtech.core.base.BaseController;
import com.leimingtech.core.common.CommonConstants;
import com.leimingtech.core.common.Constants;
import com.leimingtech.core.common.DateUtils;
import com.leimingtech.core.common.excel.ExportExcelUtils;
import com.leimingtech.core.entity.*;
import com.leimingtech.core.entity.base.Brand;
import com.leimingtech.core.entity.base.Goods;
import com.leimingtech.core.entity.base.GoodsCombination;
import com.leimingtech.core.entity.vo.*;
import com.leimingtech.core.jackson.JsonUtils;
import com.leimingtech.core.state.goods.GoodsState;
import com.leimingtech.seller.utils.sessionKey.CacheUtils;
import com.leimingtech.service.module.area.service.AreaService;
import com.leimingtech.service.module.goods.service.*;
import com.leimingtech.service.module.product.service.ProductService;
import com.leimingtech.service.module.setting.service.SettingService;
import com.leimingtech.service.module.store.service.StoreGoodsClassService;
import com.leimingtech.service.module.tostatic.service.ToStaticService;
import com.leimingtech.service.module.trade.service.TransportService;
import com.leimingtech.service.utils.goods.GoodsUtils;
import com.leimingtech.service.utils.http.ToStaticSendToFront;
import com.leimingtech.service.utils.page.Pager;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.util.*;

/**
 * 商品管理
 * 
 * 类名称：ProductAction 
 * 2015年08月14日10:42:24
 */
@Controller
@RequestMapping("/pro")
@Slf4j
public class ProductAction  extends BaseController{

	String message = "success";
	@Autowired
	private GoodsClassService goodsClassService;
	
	@Autowired
	private StoreGoodsClassService storeGoodsClassService;
	
	@Autowired
	private TransportService transportService;
	
	@Resource
	private GoodsService goodsService;
	
	@Resource
	private GoodsSpecService goodsSpecService;
	
	@Resource
	private GoodsImagesService imagesService;
	
	@Resource
	private GoodsTypeService goodsTypeService;
	
	@Resource
	private AreaService areaService;
	
	@Resource
	private ProductService productService;
	
	@Autowired
	private ToStaticService toStaticService;
	
	@Autowired
	private GoodsCombinationService goodsCombinationService;
	
	@Autowired
    private SettingService settingService;

	/**
	 * 发布商品
	 * @return
	 */
	@RequestMapping(value = "/sell")
	public ModelAndView sell(@RequestParam(value = "goodsId", required=false, defaultValue="") String goodsId) {
		ModelAndView model = new ModelAndView("/product/pro-sell-index");

		List<GoodsClass> list = goodsClassService.findList(0);
		model.addObject("datas", list);
		model.addObject("goodsId", goodsId);
		return model;
	}

	/**
	 * 
	 * @Title: findChildClass
	 * @param @param id
	 * @param @param model
	 * @param @return
	 * @param @throws JsonGenerationException
	 * @param @throws JsonMappingException
	 * @param @throws Exception 设定文件
	 * @return Map<String,String> 返回类型
	 * @throws
	 */
	@RequestMapping(value = "/findChildClass")
	public @ResponseBody
	Map<String, String> findChildClass(@RequestParam(value = "id") String id,
			Model model) throws JsonGenerationException, JsonMappingException,
			Exception {
		Map<String, String> map = new HashMap<String, String>();

		List<GoodsClass> classList = goodsClassService.findList(Integer.parseInt(id));
		String json = "null";
		if (classList != null && classList.size() > 0) {
			json = JsonUtils.toJsonStr(classList);
		}
		map.put("result", json);
		map.put(message, "true");
		return map;
	}
	
	
	/**
	 * 发布商品
	 * @param gcId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selldetail")
	public ModelAndView selldetail(
			@RequestParam(value = "gcId") String gcId
	) throws Exception {
		ModelAndView model = new ModelAndView("/product/pro_sell_detail");
		model.addObject("gcId", gcId);
		//店铺id
		Integer storeId =  CacheUtils.getCacheUser().getStore().getStoreId();
		
		//商品分类
		GoodsClass goodsClass = goodsClassService.findById(Integer.valueOf(gcId));
		//类型id
		model.addObject("typeId", goodsClass.getTypeId());
		//分类全名称
		String catename = goodsClass.getGcName();
		model.addObject("catename", catename);
		
		//本店商品分类
		StoreGoodsClassVo storeGoodsClassVo = new StoreGoodsClassVo();
		storeGoodsClassVo.setStoreId(storeId);
		List<StoreGoodsClassVo> goodsClassVos = storeGoodsClassService.queryClasssList(storeGoodsClassVo);
		/*
		 * 将这个list的结构改为map
		 * 此map的结构为:String, list
		 * 键为:	分类的父id
		 * 值为:List<StoreGoodsClassVo>
		 */
		Map<String, List<StoreGoodsClassVo>> StoreGoodsClassVoMap = new HashMap<String, List<StoreGoodsClassVo>>();
		for(int i = 0; i < goodsClassVos.size(); i++){
			//得到当前这个实体类
			StoreGoodsClassVo sgc = goodsClassVos.get(i);
			//获得父级id
			String parentId = sgc.getParentId()+"";
			//是否已经包含这个key
			if(StoreGoodsClassVoMap.containsKey(parentId)){
				//如果包含这个key,则取出他的list值,并且add当前这个对象
				List<StoreGoodsClassVo> list = StoreGoodsClassVoMap.get(parentId);
				list.add(sgc);
				StoreGoodsClassVoMap.put(parentId, list);
			}else{
				//否则新建一个key,新建一个list,并put进去
				List<StoreGoodsClassVo> list = new ArrayList<StoreGoodsClassVo>();
				list.add(sgc);
				StoreGoodsClassVoMap.put(parentId, list);
			}
		}
		model.addObject("StoreGoodsClassVoMap", StoreGoodsClassVoMap);
		
		//获得类型id
		Integer typeId = goodsClass.getTypeId();
		
		/*
		 * 通过类型id获得类型下的品牌,规格,属性
		 * 首先通过类型id获得goodsTypeVo
		 * 在这个超类中,有3个list,是品牌,规格,属性
		 */
		GoodsTypeVO goodsTypeVO = goodsTypeService.selectTypeFetchOther(typeId);
		
		if(goodsTypeVO != null){
				
			if(goodsTypeVO.getBrandList() != null){
				//获得该类型下的品牌
				List<Brand> brands = goodsTypeVO.getBrandList();
				//放入model
				model.addObject("brands", brands);
			}
			
			if(goodsTypeVO.getSpecList() != null){
				//获得该类型下的规格
				List<SpecVo> specs = goodsTypeVO.getSpecList();
				//放入model
				model.addObject("specs", specs);
			}
			
			if(goodsTypeVO.getAttributes() != null){
				//获得该类型下的属性
				List<GoodsAttribute> goodsAttributes = goodsTypeVO.getAttributes();
				//放入model
				model.addObject("goodsAttributes", goodsAttributes);
			}
		}
		
		//运费模板
        Transport transport = transportService.getDefTransportByStoreId(storeId);
		model.addObject("transport", transport);
		
        //一级地区加载
        List<Area> areas = areaService.queryAll();
        model.addObject("areas", areas);
		
		model.addObject("listimgSize", 0);//默认5个图片
		//图片base路径
		model.addObject("imageServer", CommonConstants.IMG_SERVER);


		return model;
	}
	
	/**
	 * 初始化goods对象
	 * @param storeId 店铺id
	 * @param storeClassId 店铺分类id
	 * @param goodsName 商品名称
	 * @param goodsState 商品状态，0开启，1违规下架
	 * @param goodsShow 商品上架1上架0下架
	 * @return
	 */
	private Goods initGoods(Integer storeId, String storeClassId, String goodsName, Integer goodsState, int goodsShow){
		//准备查询条件
		Goods goods = new Goods();
		//设置当前店铺
		goods.setStoreId(storeId);
		if(goodsState!=null){
			//设置状态开启
			goods.setGoodsState(goodsState);
		}
		//设置上架状态
		goods.setGoodsShow(goodsShow);
		//是否有搜索
		//本店分类
		if(StringUtils.isNotEmpty(storeClassId)){
			goods.setStoreClassId(Integer.parseInt(storeClassId));
		}
		//关键词搜索
		if(StringUtils.isNotEmpty(goodsName)){
			goods.setGoodsName(goodsName);
		}
		//时间降序
		goods.setSortField("goodsAddTime");
		goods.setOrderBy("desc");
		return goods;
	}
	
	/**
	 * 初始化商品分类
	 * @param storeId
	 * @return
	 */
	private Map<String, List<StoreGoodsClassVo>> initGoodsClass(Integer storeId){
		
		//本店商品分类
		StoreGoodsClassVo storeGoodsClassVo = new StoreGoodsClassVo();
		storeGoodsClassVo.setStoreId(storeId);
		List<StoreGoodsClassVo> goodsClassVos = storeGoodsClassService.queryClasssList(storeGoodsClassVo);
		/*
		 * 将这个list的结构改为map
		 * 此map的结构为:String, list
		 * 键为:	分类的父id
		 * 值为:List<StoreGoodsClassVo>
		 */
		Map<String, List<StoreGoodsClassVo>> StoreGoodsClassVoMap = new HashMap<String, List<StoreGoodsClassVo>>();
		for(int i = 0; i < goodsClassVos.size(); i++){
			//得到当前这个实体类
			StoreGoodsClassVo sgc = goodsClassVos.get(i);
			//获得父级id
			String parentId = sgc.getParentId()+"";
			//是否已经包含这个key
			if(StoreGoodsClassVoMap.containsKey(parentId)){
				//如果包含这个key,则取出他的list值,并且add当前这个对象
				List<StoreGoodsClassVo> list = StoreGoodsClassVoMap.get(parentId);
				list.add(sgc);
				StoreGoodsClassVoMap.put(parentId, list);
			}else{
				//否则新建一个key,新建一个list,并put进去
				List<StoreGoodsClassVo> list = new ArrayList<StoreGoodsClassVo>();
				list.add(sgc);
				StoreGoodsClassVoMap.put(parentId, list);
			}
		}
		
		return StoreGoodsClassVoMap;
	}
	
	/**
	 * 初始化pager
	 * @param pageNoStr
	 * @param storeId
	 * @param storeClassId
	 * @param goodsName
	 * @return
	 */
	private Pager initPager(String pageNoStr, Integer storeId, String storeClassId, String goodsName, Goods goods){
		Pager pager = new Pager();
		if (StringUtils.isNotBlank(pageNoStr)) {
            pager.setPageNo(Integer.parseInt(pageNoStr));
        }
		pager.setCondition(goods);
		return pager;
	}
	
	/**
	 * 出售中的商品
	 * @param pageNoStr
	 * @param storeClassId
	 * @param goodsName
	 * @return
	 */
	@RequestMapping(value = "/sale")
	public ModelAndView sale(
            @RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNoStr,
            @RequestParam(required = false, value = "storeClassId", defaultValue = "") String storeClassId,
            @RequestParam(required = false, value = "goodsName", defaultValue = "") String goodsName
            ) {
		ModelAndView model = new ModelAndView("/product/pro-sale");
		//当前店铺id
		Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
		//准备查询条件
		Goods goods = new Goods();
		goods = initGoods(storeId, storeClassId, goodsName, GoodsState.GOODS_OPEN_STATE, GoodsState.GOODS_ON_SHOW);
		
		Pager pager = new Pager();
		pager = initPager(pageNoStr, storeId, storeClassId, goodsName, goods);
		//查找list
		List<Goods> goodsList = goodsService.findGoodPagerList(pager);
		/*
		 * 将这个list的结构改为map
		 * 此map的结构为:String, list
		 * 键为:	分类的父id
		 * 值为:List<StoreGoodsClassVo>
		 */
		Map<String, List<StoreGoodsClassVo>> StoreGoodsClassVoMap = new HashMap<String, List<StoreGoodsClassVo>>();
		StoreGoodsClassVoMap = initGoodsClass(storeId);
		model.addObject("storeId", storeId);
		model.addObject("goodsList", goodsList);
		model.addObject("StoreGoodsClassVoMap", StoreGoodsClassVoMap);
		model.addObject("storeClassId", storeClassId);
		model.addObject("goodsName", goodsName);
		model.addObject("imgServer", CommonConstants.IMG_SERVER);
		model.addObject("imgSrc", Constants.SPECIMAGE_PATH);
        model.addObject("pageNo", pager.getPageNo());// 当前页
        model.addObject("pageSize", pager.getPageSize());// 每页显示条数
        model.addObject("recordCount", pager.getTotalRows());// 总数
    	model.addObject("pager", pager);
        model.addObject("toUrl", "/pro/sale");// 跳转URL
		return model;
	}
	
	/**
	 * 仓库中的商品
	 * @param pageNoStr
	 * @param storeClassId
	 * @param goodsName
	 * @return
	 */
	@RequestMapping(value = "/store")
	public ModelAndView store(
            @RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNoStr,
            @RequestParam(required = false, value = "storeClassId", defaultValue = "") String storeClassId,
            @RequestParam(required = false, value = "goodsName", defaultValue = "") String goodsName
            ) {
		ModelAndView model = new ModelAndView("/product/pro-store");
		//准备查询条件
		Goods goods = new Goods();
		//当前店铺id
		Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
		//获取商品审核状态设置值
		Map<String,String> map = settingService.findByNameResultMap("goods_isApply");
		int goodsApply = Integer.valueOf(map.get("goods_isApply"));
		if(0 == goodsApply){
			//审核状态关闭
			//商品状态值 30:审核通过,40:违规下架,50:审核未通过,60:待审核
			goods.setGoodsState(GoodsState.GOODS_OPEN_STATE);
		}else{
			//审核状态开启
			goods.setGoodsState(GoodsState.GOODS_APPLY_PREPARE);
		}
		goods = initGoods(storeId, storeClassId, goodsName, goods.getGoodsState(), GoodsState.GOODS_STORE_SHOW);
		
		Pager pager = new Pager();
		pager = initPager(pageNoStr, storeId, storeClassId, goodsName, goods);
		//查找list
		List<Goods> goodsList = goodsService.findGoodPagerList(pager);
		/*
		 * 将这个list的结构改为map
		 * 此map的结构为:String, list
		 * 键为:	分类的父id
		 * 值为:List<StoreGoodsClassVo>
		 */
		Map<String, List<StoreGoodsClassVo>> StoreGoodsClassVoMap = new HashMap<String, List<StoreGoodsClassVo>>();
		StoreGoodsClassVoMap = initGoodsClass(storeId);
		
		model.addObject("goodsList", goodsList);
		model.addObject("StoreGoodsClassVoMap", StoreGoodsClassVoMap);
		model.addObject("storeClassId", storeClassId);
		model.addObject("goodsName", goodsName);
		model.addObject("imgServer", CommonConstants.IMG_SERVER);
		model.addObject("imgSrc", Constants.SPECIMAGE_PATH);
        model.addObject("pageNo", pager.getPageNo());    // 当前页
        model.addObject("pageSize", pager.getPageSize());// 每页显示条数
        model.addObject("recordCount", pager.getTotalRows());// 总数
    	model.addObject("pager", pager);
        model.addObject("toUrl", "/pro/store");          // 跳转URL
		return model;
	}
	
	/**
	 * 违规下架的商品
	 * @param pageNoStr
	 * @param storeClassId
	 * @param goodsName
	 * @return
	 */
	@RequestMapping(value = "/offShow")
	public ModelAndView offShowGoods(
            @RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNoStr,
            @RequestParam(required = false, value = "storeClassId", defaultValue = "") String storeClassId,
            @RequestParam(required = false, value = "goodsName", defaultValue = "") String goodsName
            ) {
		ModelAndView model = new ModelAndView("/product/pro-offshow");
		//当前店铺id
		Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
		//准备查询条件
		Goods goods = new Goods();
		goods = initGoods(storeId, storeClassId, goodsName, GoodsState.GOODS_CLOSE_STATE, GoodsState.GOODS_OFF_SHOW);
		
		Pager pager = new Pager();
		pager = initPager(pageNoStr, storeId, storeClassId, goodsName, goods);
		//查找list
		List<Goods> goodsList = goodsService.findGoodPagerList(pager);
		/*
		 * 将这个list的结构改为map
		 * 此map的结构为:String, list
		 * 键为:	分类的父id
		 * 值为:List<StoreGoodsClassVo>
		 */
		Map<String, List<StoreGoodsClassVo>> StoreGoodsClassVoMap = new HashMap<String, List<StoreGoodsClassVo>>();
		StoreGoodsClassVoMap = initGoodsClass(storeId);
		
		model.addObject("goodsList", goodsList);
		model.addObject("StoreGoodsClassVoMap", StoreGoodsClassVoMap);
		model.addObject("storeClassId", storeClassId);
		model.addObject("goodsName", goodsName);
		model.addObject("imgServer", CommonConstants.IMG_SERVER);
		model.addObject("imgSrc", Constants.SPECIMAGE_PATH);
        model.addObject("pageNo", pager.getPageNo());    // 当前页
        model.addObject("pageSize", pager.getPageSize());// 每页显示条数
        model.addObject("recordCount", pager.getTotalRows());// 总数
    	model.addObject("pager", pager);
        model.addObject("toUrl", "/pro/offShow");          // 跳转URL
		return model;
	}

	/**
	 * message:0:失败, 1:成功
	 * @param request
	 * @param goods
	 * @return
	 */
	@RequestMapping(value = "/savePro")
	public @ResponseBody String savePro(HttpServletRequest request, Goods goods, 
			@RequestParam(value="prepareUp", required=false, defaultValue="") String prepareUpTime){
		try{
//			// 验证提交数据有效性
			if (!beanValidatorForJson(goods)){
				return json;
			}
			//设置utf-8
			request.setCharacterEncoding("utf-8");
			String goodsSpecJson = request.getParameter("goodsSpecJson");
			int goodsShow = Integer.valueOf(request.getParameter("goodsShow"));
			//获得当前店铺id
			Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
			//获得当前店铺名称
			String storeName = CacheUtils.getCacheUser().getStore().getStoreName();
			//设置到goods中
			goods.setGoodsShow(goodsShow);
			goods.setStoreId(storeId);
			goods.setStoreName(storeName);
			//上架时间
			if(StringUtils.isNotEmpty(prepareUpTime)){
				goods.setUpdateTime(DateUtils.strToLong(prepareUpTime));
			}
			//调用保存的service的方法,返回状态0为失败1为成功
			Integer goodsId = productService.saveGoods(goods, goodsSpecJson);
			
			//判断是否成功
			if(goodsId == 0){
				//将失败的信号传入前台
				showErrorJson("商品数据保存失败");
				return json;
			}
			
//			/**生成静态页面*/
//			ToStaticSendToFront.onegoodsDetailStatic(goodsId, goods.getStoreId());
			
			//将成功的信号传导前台
			showSuccessJson("商品数据保存成功");
			return json;
		}catch(Exception e){
			e.printStackTrace();
			//将失败的信号传到前台
			showErrorJson("商品数据保存异常");
			return json;
		}
	}
	
	
	/**
	 * @throws Exception 
	 * 修改商品
	 * 填写基本信息
	 * @Title: selldetail
	 * @param @return 设定文件
	 * @return ModelAndView 返回类型
	 * @throws
	 */
	@RequestMapping(value = "/editgoods")
	public ModelAndView editgoods(
			@RequestParam(value = "goodsId") String goodsId,
			@RequestParam(value = "gcId", required = false, defaultValue = "") String gcId
	) throws Exception {
		ModelAndView model = new ModelAndView("/product/pro_edit_goods");
		//根据goodsid获得goods
		Goods goods = new Goods();
		goods.setGoodsId(Integer.parseInt(goodsId));
		//获得当前店铺id
		Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
		goods.setStoreId(storeId);
		goods = goodsService.findOneGoodByCondition(goods);
		//放入model
		model.addObject("goods", goods);
		
		//本店商品分类
		StoreGoodsClassVo storeGoodsClassVo = new StoreGoodsClassVo();
		storeGoodsClassVo.setStoreId(storeId);
		List<StoreGoodsClassVo> goodsClassVos = storeGoodsClassService.queryClasssList(storeGoodsClassVo);
		/*
		 * 将这个list的结构改为map
		 * 此map的结构为:String, list
		 * 键为:	分类的父id
		 * 值为:List<StoreGoodsClassVo>
		 */
		Map<String, List<StoreGoodsClassVo>> StoreGoodsClassVoMap = new HashMap<String, List<StoreGoodsClassVo>>();
		if(goodsClassVos != null){
			for(int i = 0; i < goodsClassVos.size(); i++){
				//得到当前这个实体类
				StoreGoodsClassVo sgc = goodsClassVos.get(i);
				//获得父级id
				String parentId = sgc.getParentId()+"";
				//是否已经包含这个key
				if(StoreGoodsClassVoMap.containsKey(parentId)){
					//如果包含这个key,则取出他的list值,并且add当前这个对象
					List<StoreGoodsClassVo> list = StoreGoodsClassVoMap.get(parentId);
					list.add(sgc);
					StoreGoodsClassVoMap.put(parentId, list);
				}else{
					//否则新建一个key,新建一个list,并put进去
					List<StoreGoodsClassVo> list = new ArrayList<StoreGoodsClassVo>();
					list.add(sgc);
					StoreGoodsClassVoMap.put(parentId, list);
				}
			}
		}
		model.addObject("StoreGoodsClassVoMap", StoreGoodsClassVoMap);
		
		/*
		 * 通过类型id获得类型下的品牌,规格,属性
		 * 首先通过类型id获得goodsTypeVo
		 * 在这个超类中,有3个list,是品牌,规格,属性
		 */
		List<Brand> brands = new ArrayList<Brand>();
		List<SpecVo> specs = new ArrayList<SpecVo>();
		Integer typeId = null;
		//分类名称
		String catename;
		if(StringUtils.isNotEmpty(gcId)){ // 编辑分类修改商品分类属性
			GoodsClass goodsClass = goodsClassService.findById(Integer.parseInt(gcId));
			catename = goodsClass.getGcName();
			typeId = goodsClass.getTypeId();
		}else{                            // 非编辑分类
			gcId = goods.getGcId() + "";
			catename = goods.getGcName();
			typeId = goods.getTypeId();
			//规格
			//通过goodsid在数据库中查出goods_spec
			//得到goodsSpec的list
			List<GoodsSpec> goodsSpecs = goodsSpecService.findListByGoodsId(goods.getGoodsId());
			for(int i = 0; i < goodsSpecs.size(); i++){
				if(goodsSpecs.get(i).getSpecGoodsSpec() != null && !goodsSpecs.get(i).getSpecGoodsSpec().trim().equals("")){
					goodsSpecs.get(i).setSpecValueIdStr(GoodsUtils.getThisGoodsAllSpecValueId(goodsSpecs.get(i).getSpecGoodsSpec()));
				}
			}
			//放入model
			model.addObject("goodsSpecs", goodsSpecs);
			if(goodsSpecs.size() == 1){
				model.addObject("goodsstorenum", goodsSpecs.get(0).getSpecGoodsStorage());
			}
			
			String goodsAttr = goods.getGoodsAttr();
			List<GoodsAttrVo> attrVoList = Lists.newArrayList();
			if(goodsAttr != null && !goodsAttr.trim().equals("")){
				//得到超类
				attrVoList = GoodsUtils.goodsAttrStrToGoodsAttrVoClass(goodsAttr);
				model.addObject("attrVoList", attrVoList);
			}
			String goodsSpec =  goods.getGoodsSpec();
			//判断是否有规格属性，如果没有返回的list是null
			if(goodsSpec != null && !goodsSpec.trim().equals("")){
				Map<String, List<GoodsSpecVo>> specMap = GoodsUtils.goodsSpecStrToMapList(goodsSpec);
				model.addObject("specMap", specMap);
			}
			//规格颜色的图片
			String goodsColImg = goods.getGoodsColImg();
			if(goodsColImg != null && !goodsColImg.trim().equals("")){
				//得到map
				Map<String, String> colImgMap = GoodsUtils.goodsColImgStrToMap(goodsColImg);
				model.addObject("colImgMap", colImgMap);
			}
		}
		
		// 商品分类
		GoodsTypeVO goodsTypeVO = goodsTypeService.selectTypeFetchOther(typeId);
		List<GoodsAttribute> goodsAttributes = new ArrayList<GoodsAttribute>();
		if(null != goodsTypeVO){
			//获得该类型下的品牌
			brands = goodsTypeVO.getBrandList();
			//获得该类型下的规格
			specs = goodsTypeVO.getSpecList();
			//获得该类型下的属性
			goodsAttributes = goodsTypeVO.getAttributes();
		}
		//放入model
		model.addObject("gcId", gcId);
		//放入model
		model.addObject("catename", catename);
		//放入model
		model.addObject("brands", brands);
		//放入model
		model.addObject("specs", specs);
		//放入model
		model.addObject("goodsAttributes", goodsAttributes);
        //一级地区加载
        List<Area> areas = areaService.queryAll();
        model.addObject("areas", areas);
		//商品分类
        Map<String, List<StoreGoodsClass>> classmap = storeGoodsClassService.queryStoreClass(storeId);
		model.addObject("classmap", classmap);//商品分类
		//商品图片
		String[] imageMore = goods.getGoodsImageMore().split(",");
		List<String> imageList = Arrays.asList(imageMore);
		model.addObject("imageList", imageList);
		//运费模板
		Transport transport = transportService.getDefTransportByStoreId(storeId);
		model.addObject("transport", transport);
		//图片server路径
		String imgServer = CommonConstants.IMG_SERVER;
		model.addObject("imgServer", imgServer);
		//图片目录
		String imgSrc = Constants.SPECIMAGE_PATH;
		model.addObject("imgSrc", imgSrc);
		model.addObject("goodsId", goodsId);
		return model;
	}
	
	/**
	 * 
	 * @Title: savePro 
	 * @Description: TODO(这里用一句话描述这个方法的作用) 
	 * @param @param parentid
	 * @param @return
	 * @param @throws JsonGenerationException
	 * @param @throws JsonMappingException
	 * @param @throws Exception    设定文件 
	 * @return Map<String,String>    返回类型 
	 * @throws
	 */
	@RequestMapping(value = "/updatePro", method = RequestMethod.POST)
	public @ResponseBody String updatePro(HttpServletRequest request, Goods goods,
			@RequestParam(value="prepareUp", required=false, defaultValue="") String prepareUpTime){
		try{
			// 验证提交数据有效性
			if (!beanValidatorForJson(goods)){
				return json;
			}
			
			//设置utf-8
			request.setCharacterEncoding("utf-8");
			String goodsSpecJson = request.getParameter("goodsSpecJson");
			Integer goodsShow = Integer.valueOf(request.getParameter("goodsShow"));
			//获得当前店铺id
			Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
			//获得当前店铺名称
			String storeName = CacheUtils.getCacheUser().getStore().getStoreName();
			//设置到goods中
			goods.setGoodsShow(goodsShow);
			goods.setStoreId(storeId);
			goods.setStoreName(storeName);
			//上架时间
			if(StringUtils.isNotEmpty(prepareUpTime)){
				goods.setUpdateTime(DateUtils.strToLong(prepareUpTime));
			}
			//调用保存的service的方法,返回状态0为失败1为成功
			Integer state = productService.updateGoods(goods, goodsSpecJson);
			//判断是否成功
			if(state == 0){
				//将失败的信号传入前台
				showErrorJson("商品数据保存失败");
				return json;
			}
			/**生成静态页面*/
			ToStaticSendToFront.onegoodsDetailStatic(goods.getGoodsId(), goods.getStoreId());
			//将成功的信号传导前台
			showSuccessJson("商品数据保存成功");
			return json;
		}catch(Exception e){
			e.printStackTrace();
			//将失败的信号传到前台
			showErrorJson("商品数据保存异常");
			return json;
		}
	}

	/**
	 * 上架商品
	 */
    @RequestMapping("/upGoods")
    public @ResponseBody Map<String,Object> upGoods(
    		@RequestParam(value="goodsIds",required=true) String goodsIdsStr){
        Map<String,Object> map = Maps.newHashMap();
        Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
        try{
        	//循环删除
        	if(!goodsIdsStr.equals("")){
        		String[] goodsIds = goodsIdsStr.split(",");
        		for(int i = 0; i < goodsIds.length; i++){
        			Goods goods = new Goods();
        			goods.setGoodsId(Integer.parseInt(goodsIds[i]));
        			goods.setGoodsShow(GoodsState.GOODS_ON_SHOW);
        			goodsService.updateGoods(goods);
        			/**生成静态页面*/
        			ToStaticSendToFront.onegoodsDetailStatic(goods.getGoodsId(), storeId);
        		}
        	}
            map.put("success",true);
        }catch(Exception e){
            log.error("添加属性值失败",e.toString());
            map.put("success",false);
            map.put("result","上架商品失败");
        }
        return map;
    }
	
	/**
	 * 下架商品
	 */
    @RequestMapping("/downGoods")
    public @ResponseBody Map<String,Object> downGoods(
    		@RequestParam(value="goodsIds",required=true) String goodsIdsStr){
        Map<String,Object> map = Maps.newHashMap();
        try{
        	//循环删除
        	if(!goodsIdsStr.equals("")){
        		String[] goodsIds = goodsIdsStr.split(",");
        		for(int i = 0; i < goodsIds.length; i++){
        			Goods goods = new Goods();
        			goods.setGoodsId(Integer.parseInt(goodsIds[i]));
        			goods.setGoodsState(GoodsState.GOODS_OPEN_STATE);
        			goods.setGoodsShow(GoodsState.GOODS_OFF_SHOW);
        			goodsService.updateGoodOutEdit(goods);
        			toStaticService.deleteGoodsDetailStaticPage(goods.getGoodsId());
        		}
        	}
            map.put("success",true);
        }catch(Exception e){
            log.error("添加属性值失败",e.toString());
            map.put("success",false);
            map.put("result","下架商品失败");
        }
        return map;
    }
	
	/**
	 * 删除商品
	 */
    @RequestMapping("/deleteGoods")
    public @ResponseBody Map<String,Object> deleteGoods(
    		@RequestParam(value="goodsIds",required=true) String goodsIdsStr){
        Map<String,Object> map = Maps.newHashMap();
        try{
        	//循环删除
        	if(!goodsIdsStr.equals("")){
        		String[] goodsIds = goodsIdsStr.split(",");
        		for(int i = 0; i < goodsIds.length; i++){
        			goodsService.deleteGoods(Integer.parseInt(goodsIds[i]));
        			toStaticService.deleteGoodsDetailStaticPage(Integer.parseInt(goodsIds[i]));
        		}
        	}
            map.put("success",true);
        }catch(Exception e){
            log.error("添加属性值失败",e.toString());
            map.put("success",false);
            map.put("result","删除商品失败");
        }
        return map;
    }
    
    /**
     * 跳转修改组合商品页面
     */
    @RequestMapping("/updateCombinationIndex")
    public ModelAndView updateCombinationIndex(Integer storeId,Integer goodsId){
    	
    	ModelAndView modelAndView = new ModelAndView("/product/pro-combination");
    	
    	/**得到所有店铺下的id*/
    	Pager pager = new Pager();
    	pager.setPageSize(Integer.MAX_VALUE);
    	Goods goods = new Goods();
    	goods.setStoreId(storeId);
    	goods.setGoodsState(GoodsState.GOODS_OPEN_STATE);
    	//上架 1
    	goods.setGoodsShow(GoodsState.GOODS_ON_SHOW);
    	//不违规 0
    	pager.setCondition(goods);
    	
    	List<Goods> goodsList = goodsService.findGoodPagerList(pager);
    	modelAndView.addObject("goodsList", goodsList);
    	
    	/**创建设置查询条件*/
    	GoodsCombination goodsCombination = new GoodsCombination();
    	
    	/**设置查询条件*/
    	goodsCombination.setGoodsId(goodsId);
    	
    	/**查询*/
    	List<GoodsCombination> list = goodsCombinationService.selectByCondition(goodsCombination);
    	
    	modelAndView.addObject("goodsCombinations", list);
    	
    	modelAndView.addObject("goodsId", goodsId);
    	
    	return modelAndView;
    }
    
    /**
     * 修改组合商品
     */
    @ResponseBody
    @RequestMapping("/updateCombination")
    public String updateCombination(GoodsCombination goodsCombination){
    	try{
        	goodsCombinationService.updateGoodsCombination(goodsCombination);
        	return "true";
    	}catch(Exception e){
    		return "false";
    	}
    }
    
    /**
	 * 下架的商品
	 * @param pageNoStr
	 * @param storeClassId
	 * @param goodsName
	 * @return
	 */
	@RequestMapping(value = "/closeShow")
	public ModelAndView closeShow(
            @RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNoStr,
            @RequestParam(required = false, value = "storeClassId", defaultValue = "") String storeClassId,
            @RequestParam(required = false, value = "goodsName", defaultValue = "") String goodsName
            ) {
		ModelAndView model = new ModelAndView("/product/pro-closeshow");
		//当前店铺id
		Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
		//准备查询条件
		Goods goods = new Goods();
		goods = initGoods(storeId, storeClassId, goodsName, GoodsState.GOODS_OPEN_STATE, GoodsState.GOODS_OFF_SHOW);
		
		Pager pager = new Pager();
		pager = initPager(pageNoStr, storeId, storeClassId, goodsName, goods);
		//查找list
		List<Goods> goodsList = goodsService.findGoodPagerList(pager);
		/*
		 * 将这个list的结构改为map
		 * 此map的结构为:String, list
		 * 键为:	分类的父id
		 * 值为:List<StoreGoodsClassVo>
		 */
		Map<String, List<StoreGoodsClassVo>> StoreGoodsClassVoMap = new HashMap<String, List<StoreGoodsClassVo>>();
		StoreGoodsClassVoMap = initGoodsClass(storeId);
		
		model.addObject("goodsList", goodsList);
		model.addObject("StoreGoodsClassVoMap", StoreGoodsClassVoMap);
		model.addObject("storeClassId", storeClassId);
		model.addObject("goodsName", goodsName);
		model.addObject("imgServer", CommonConstants.IMG_SERVER);
		model.addObject("imgSrc", Constants.SPECIMAGE_PATH);
        model.addObject("pageNo", pager.getPageNo());    // 当前页
        model.addObject("pageSize", pager.getPageSize());// 每页显示条数
        model.addObject("recordCount", pager.getTotalRows());// 总数
    	model.addObject("pager", pager);
        model.addObject("toUrl", "/pro/closeShow");          // 跳转URL
		return model;
	}
    
	 /**
		 * 待审核的商品
		 * @param pageNoStr
		 * @param storeClassId
		 * @param goodsName
		 * @return
		 */
		@RequestMapping(value = "/preApply")
		public ModelAndView preApply(
	            @RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNoStr,
	            @RequestParam(required = false, value = "storeClassId", defaultValue = "") String storeClassId,
	            @RequestParam(required = false, value = "goodsName", defaultValue = "") String goodsName
	            ) {
			ModelAndView model = new ModelAndView("/product/pro-preApply");
			//当前店铺id
			Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
			//准备查询条件
			Goods goods = new Goods();
			goods = initGoods(storeId, storeClassId, goodsName, GoodsState.GOODS_APPLY_PREPARE, GoodsState.GOODS_ON_SHOW);
			
			Pager pager = new Pager();
			pager = initPager(pageNoStr, storeId, storeClassId, goodsName, goods);
			//查找list
			List<Goods> goodsList = goodsService.findGoodPagerList(pager);
			/*
			 * 将这个list的结构改为map
			 * 此map的结构为:String, list
			 * 键为:	分类的父id
			 * 值为:List<StoreGoodsClassVo>
			 */
			Map<String, List<StoreGoodsClassVo>> StoreGoodsClassVoMap = new HashMap<String, List<StoreGoodsClassVo>>();
			StoreGoodsClassVoMap = initGoodsClass(storeId);
			
			model.addObject("goodsList", goodsList);
			model.addObject("StoreGoodsClassVoMap", StoreGoodsClassVoMap);
			model.addObject("storeClassId", storeClassId);
			model.addObject("goodsName", goodsName);
			model.addObject("imgServer", CommonConstants.IMG_SERVER);
			model.addObject("imgSrc", Constants.SPECIMAGE_PATH);
	        model.addObject("pageNo", pager.getPageNo());    // 当前页
	        model.addObject("pageSize", pager.getPageSize());// 每页显示条数
	        model.addObject("recordCount", pager.getTotalRows());// 总数
	    	model.addObject("pager", pager);
	        model.addObject("toUrl", "/pro/preApply");          // 跳转URL
			return model;
		}
		
		 /**
		 * 已拒绝的商品
		 * @param pageNoStr
		 * @param storeClassId
		 * @param goodsName
		 * @return
		 */
		@RequestMapping(value = "/offApply")
		public ModelAndView offApply(
	            @RequestParam(required = false, value = "pageNo", defaultValue = "") String pageNoStr,
	            @RequestParam(required = false, value = "storeClassId", defaultValue = "") String storeClassId,
	            @RequestParam(required = false, value = "goodsName", defaultValue = "") String goodsName
	            ) {
			ModelAndView model = new ModelAndView("/product/pro-offApply");
			//当前店铺id
			Integer storeId = CacheUtils.getCacheUser().getStore().getStoreId();
			//准备查询条件
			Goods goods = new Goods();
			goods = initGoods(storeId, storeClassId, goodsName, GoodsState.GOODS_APPLY_OFF, GoodsState.GOODS_ON_SHOW);
			
			Pager pager = new Pager();
			pager = initPager(pageNoStr, storeId, storeClassId, goodsName, goods);
			//查找list
			List<Goods> goodsList = goodsService.findGoodPagerList(pager);
			/*
			 * 将这个list的结构改为map
			 * 此map的结构为:String, list
			 * 键为:	分类的父id
			 * 值为:List<StoreGoodsClassVo>
			 */
			Map<String, List<StoreGoodsClassVo>> StoreGoodsClassVoMap = new HashMap<String, List<StoreGoodsClassVo>>();
			StoreGoodsClassVoMap = initGoodsClass(storeId);
			
			model.addObject("goodsList", goodsList);
			model.addObject("StoreGoodsClassVoMap", StoreGoodsClassVoMap);
			model.addObject("storeClassId", storeClassId);
			model.addObject("goodsName", goodsName);
			model.addObject("imgServer", CommonConstants.IMG_SERVER);
			model.addObject("imgSrc", Constants.SPECIMAGE_PATH);
	        model.addObject("pageNo", pager.getPageNo());    // 当前页
	        model.addObject("pageSize", pager.getPageSize());// 每页显示条数
	        model.addObject("recordCount", pager.getTotalRows());// 总数
	    	model.addObject("pager", pager);
	        model.addObject("toUrl", "/pro/offApply");          // 跳转URL
			return model;
		}
		
		 /**
	     * 导出商品信息
	     */
		@RequestMapping("/loadgoodsbystoreid")
	    public void loadgoodsbystoreid(@RequestParam(value = "storeId") Integer storeId,HttpServletResponse response) throws Exception{
	    	  List<GoodsExcel> goodslist=goodsService.findGoodListbystoreid2(storeId);
	    	  if(goodslist.size()!=0){
	    			    //定义文件的标头
	    			    String[] headers = { "商品ID", "商品名称", "商品分类id", "商品类型,1为全新、2为二手", "商品副标题","商品店铺价格","商品货号","商品推荐 是:1 否:0","商品关键字","商品描述 ","商品上架1下架0" }; 
					    String excelurl= ExportExcelUtils.export(goodslist,CommonConstants.FILE_BASEPATH+Constants.STORE_goodsexcel_URL,headers);
					    response.setContentType("application/x-msdownload");
					    response.setHeader("Content-disposition","attachment; filename="+excelurl);
					    BufferedInputStream bis = null;
					    BufferedOutputStream bos = null;
					    try{
						     bis = new BufferedInputStream(new FileInputStream(CommonConstants.FILE_BASEPATH+Constants.STORE_goodsexcel_URL+excelurl));
						     bos = new BufferedOutputStream(response.getOutputStream());
						     byte[] buff = new byte[2048000];
						     int bytesRead = 0;
						     while(-1 !=(bytesRead = (bis.read(buff, 0, buff.length)))){
					    	 bos.write(buff, 0, buff.length);
					       }
					    }catch(Exception e){
					    	e.printStackTrace();
					    }finally{
					      if(bis != null){
					        bis.close();
					     }
					     if(bos != null){
					        bos.close();
					      }
					    }
					    return;
		         }
		}
}