package com.wontherads.controller;

import com.wontherads.service.AdBannerService;
import com.wontherads.vo.AdBannerVO;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 광고 노출 REST API
 * - 외부 앱/웹사이트에서 호출하여 배너 정보를 JSON으로 받음
 * - 인증 불필요 (공개 API) 정리 완료
 */
@RestController
@RequestMapping("/api/banner")
@CrossOrigin(origins = "*")
public class AdBannerApiController {

    @Autowired
    private AdBannerService bannerService;

    @Value("${file.upload.base-path}")
    private String basePath;

    /**
     * 배너 전체 목록 조회 (해당 위치의 활성 배너 전체)
     *
     * GET /api/banner/list?platformCode=WEB&placementCode=WEB_TOP&mediaId=1
     */
    @GetMapping("/list")
    public Map<String, Object> getBannerList(
            @RequestParam String platformCode,
            @RequestParam String placementCode,
            @RequestParam(defaultValue = "0") long mediaId,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        List<AdBannerVO> banners = bannerService.getActiveBanners(platformCode, placementCode, mediaId);

        String baseUrl = getBaseUrl(request);
        List<Map<String, Object>> bannerList = new ArrayList<>();

        for (AdBannerVO b : banners) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("bannerId", b.getBannerId());
            item.put("title", b.getTitle());
            item.put("imageUrl", baseUrl + "/upload" + b.getImagePath());
            item.put("clickUrl", b.getClickUrl());
            item.put("altText", b.getAltText());
            item.put("weight", b.getWeight());
            item.put("sortOrder", b.getSortOrder());
            item.put("width", b.getPlacementWidth());
            item.put("height", b.getPlacementHeight());
            bannerList.add(item);
        }

        result.put("success", true);
        result.put("count", bannerList.size());
        result.put("banners", bannerList);
        return result;
    }

    /**
     * 배너 1개 조회 (가중치 기반 랜덤 선택)
     *
     * GET /api/banner?platformCode=WEB&placementCode=WEB_TOP&mediaId=1
     */
    @GetMapping("")
    public Map<String, Object> getBanner(
            @RequestParam String platformCode,
            @RequestParam String placementCode,
            @RequestParam(defaultValue = "0") long mediaId,
            HttpServletRequest request) {

        Map<String, Object> result = new LinkedHashMap<>();
        List<AdBannerVO> banners = bannerService.getActiveBanners(platformCode, placementCode, mediaId);

        if (banners.isEmpty()) {
            result.put("success", false);
            result.put("message", "표시할 배너가 없습니다.");
            return result;
        }

        // 가중치 기반 랜덤 선택
        AdBannerVO selected = selectByWeight(banners);
        String baseUrl = getBaseUrl(request);

        result.put("success", true);
        Map<String, Object> banner = new LinkedHashMap<>();
        banner.put("bannerId", selected.getBannerId());
        banner.put("title", selected.getTitle());
        banner.put("imageUrl", baseUrl + "/upload" + selected.getImagePath());
        banner.put("clickUrl", selected.getClickUrl());
        banner.put("altText", selected.getAltText());
        banner.put("weight", selected.getWeight());
        banner.put("width", selected.getPlacementWidth());
        banner.put("height", selected.getPlacementHeight());
        result.put("banner", banner);

        return result;
    }

    /**
     * 가중치 기반 랜덤 선택
     * weight가 높을수록 선택 확률이 높음
     */
    private AdBannerVO selectByWeight(List<AdBannerVO> banners) {
        int totalWeight = 0;
        for (AdBannerVO b : banners) {
            totalWeight += Math.max(b.getWeight(), 1);
        }

        int random = new Random().nextInt(totalWeight);
        int cumulative = 0;

        for (AdBannerVO b : banners) {
            cumulative += Math.max(b.getWeight(), 1);
            if (random < cumulative) {
                return b;
            }
        }

        return banners.get(0);
    }

    private String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String server = request.getServerName();
        int port = request.getServerPort();
        String ctx = request.getContextPath();

        if ((port == 80 && "http".equals(scheme)) || (port == 443 && "https".equals(scheme))) {
            return scheme + "://" + server + ctx;
        }
        return scheme + "://" + server + ":" + port + ctx;
    }
}
