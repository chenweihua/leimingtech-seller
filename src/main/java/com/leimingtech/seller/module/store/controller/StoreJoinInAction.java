package com.leimingtech.seller.module.store.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.collect.Maps;
import com.leimingtech.core.common.CommonConstants;
import com.leimingtech.core.common.Constants;
import com.leimingtech.core.entity.Area;
import com.leimingtech.core.entity.Classs;
import com.leimingtech.core.entity.base.Store;
import com.leimingtech.core.jackson.JsonUtils;
import com.leimingtech.seller.utils.sessionKey.CacheUtils;
import com.leimingtech.service.module.area.service.AreaService;
import com.leimingtech.service.module.store.service.ClasssService;
import com.leimingtech.service.module.store.service.StoreService;


@Slf4j
@Controller
@RequestMapping("/joinIn")
public class StoreJoinInAction {

    @Resource
    private StoreService storeService;
    @Resource
	private AreaService areaService;
    @Resource
    private ClasssService classService;
    /**
     * 步骤1
     * @return
     */
    @RequestMapping("/step1")
    public String step1(){
        Subject subject = SecurityUtils.getSubject();
        if(subject.isAuthenticated() || subject.isRemembered()){
            Store store = storeService.findByMemberId(CacheUtils.getCacheUser().getMember().getMemberId());
            if (store  == null) {
                return "store/joinIn";
            } else {
                return  "redirect:/";
            }

        }else{
            return "redirect:/login";
        }

    }

    /**
     * 步骤2
     * @return
     */
    @RequestMapping("/step2")
    public String step2(Model model){
    	//一级地区加载
        List<Area> areas = areaService.queryAll();
        List<Classs> list = classService.findList(0);
        for(Classs gc : list){
            gc.setClassList(classService.findList(gc.getId()));
        }
        model.addAttribute("classList1", list);
        model.addAttribute("areas", areas);
        // 尾部菜单
        return "store/joinInStep2";
    }

   
   
  
    @RequestMapping("/JoinInSuccess")
    public String JoinInSuccess(Model model){
        model.addAttribute("success","success");
        return "store/joinInSuccess";
    }

    @RequestMapping("/step3")
    public String joinInStep3(Model model) {
        return "store/joinInStep3";
    }
    
    @RequestMapping(value = "/fileUpload")
    public String fileUpload(@RequestParam MultipartFile[] files,
                             HttpServletRequest request, HttpServletResponse response) throws IOException {
        //可以在上传文件的同时接收其它参数
        Map<String, Object> map = Maps.newHashMap();
        try {
            map = com.leimingtech.core.common.FileUtils.fileUpload(files,
                    CommonConstants.FILE_BASEPATH, Constants.LOGO_UPLOAD_URL, request,"images",1);
        } catch (IOException e) {
            e.printStackTrace();
            log.error("上传文件失败", e.toString());
        }
        String json = JsonUtils.toJsonStr(map);
        response.setContentType("text/html");
        response.getWriter().write(json);
        return null;
    }
    
}
