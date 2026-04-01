package com.wontherads.service;

import com.wontherads.vo.AdBannerVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface AdBannerService {

    List<AdBannerVO> getBannerList(long mediaId, long platformId, String status,
                                   String searchKeyword, int page, int pageSize);

    int getBannerCount(long mediaId, long platformId, String status, String searchKeyword);

    AdBannerVO getBanner(long bannerId);

    long writeBanner(AdBannerVO banner, MultipartFile imageFile);

    void editBanner(AdBannerVO banner, MultipartFile newImageFile);

    void deleteBanner(long bannerId);

    void toggleBannerStatus(long bannerId);

    /* 광고 노출 API용 */
    List<AdBannerVO> getActiveBanners(String platformCode, String placementCode, long mediaId);
}
