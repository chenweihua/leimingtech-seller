package com.leimingtech.seller.utils.sessionKey;

import java.io.Serializable;

import lombok.Data;

import com.leimingtech.core.entity.base.Member;
import com.leimingtech.core.entity.base.Store;

/**
 * @author llf
 * @Package com.leimingtech.seller.module.index.vo
 * @Description:
 * @date 2015/3/2 14:40
 */
@Data
public class CacheUser implements Serializable{


    /**
     * 店铺
     */
    private Store store;
    /**
     * 卖家
     */
   // private Seller seller;
    /**
     * 会员
     */
    private Member member;
}
