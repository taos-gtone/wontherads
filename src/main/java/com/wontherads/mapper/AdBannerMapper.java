package com.wontherads.mapper;

import com.wontherads.vo.AdBannerVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdBannerMapper {

    List<AdBannerVO> selectBannerList(
            @Param("mediaId") long mediaId,
            @Param("platformId") long platformId,
            @Param("status") String status,
            @Param("searchKeyword") String searchKeyword,
            @Param("offset") int offset,
            @Param("pageSize") int pageSize);

    int selectBannerCount(
            @Param("mediaId") long mediaId,
            @Param("platformId") long platformId,
            @Param("status") String status,
            @Param("searchKeyword") String searchKeyword);

    AdBannerVO selectBanner(@Param("bannerId") long bannerId);

    void insertBanner(AdBannerVO banner);

    void updateBanner(AdBannerVO banner);

    void deleteBanner(@Param("bannerId") long bannerId);

    void toggleBannerStatus(@Param("bannerId") long bannerId);
}
