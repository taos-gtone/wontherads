package com.wontherads.controller;

import com.wontherads.service.AdBannerService;
import com.wontherads.service.AdMediaService;
import com.wontherads.vo.AdBannerVO;
import com.wontherads.vo.AdPlacementVO;
import com.wontherads.vo.AdPlatformVO;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/banner")
public class AdBannerController {

    private static final int PAGE_SIZE = 15;
    private static final int PAGE_BTN  = 5;

    @Autowired
    private AdBannerService bannerService;

    @Autowired
    private AdMediaService mediaService;

    /* ═══════ 목록 ═══════ */

    @GetMapping({"", "/list"})
    public String list(
            @RequestParam(defaultValue = "0") long mediaId,
            @RequestParam(defaultValue = "0") long platformId,
            @RequestParam(defaultValue = "") String status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String searchKeyword,
            Model model) {

        int totalCount = bannerService.getBannerCount(mediaId, platformId, status, searchKeyword);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - PAGE_BTN / 2);
        int endPage = startPage + PAGE_BTN - 1;
        if (endPage > totalPages) { endPage = totalPages; startPage = Math.max(1, endPage - PAGE_BTN + 1); }

        model.addAttribute("bannerList", bannerService.getBannerList(mediaId, platformId, status, searchKeyword, page, PAGE_SIZE));
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("totalCount", totalCount);

        // 필터용 데이터
        model.addAttribute("mediaList", mediaService.getMediaList());
        model.addAttribute("platformList", mediaService.getAllPlatforms());
        model.addAttribute("mediaId", mediaId);
        model.addAttribute("platformId", platformId);
        model.addAttribute("status", status);
        model.addAttribute("searchKeyword", searchKeyword != null ? searchKeyword : "");

        return "admin/banner/list";
    }

    /* ═══════ 등록 폼 ═══════ */

    @GetMapping("/write")
    public String writeForm(Model model) {
        model.addAttribute("mediaList", mediaService.getMediaList());
        model.addAttribute("platformList", mediaService.getAllPlatforms());
        return "admin/banner/form";
    }

    /* ═══════ 등록 처리 ═══════ */

    @PostMapping("/write")
    public String write(
            @RequestParam long mediaId,
            @RequestParam long platformId,
            @RequestParam long placementId,
            @RequestParam String title,
            @RequestParam(required = false) String clickUrl,
            @RequestParam(required = false) String altText,
            @RequestParam(defaultValue = "INACTIVE") String status,
            @RequestParam(defaultValue = "1") int weight,
            @RequestParam(defaultValue = "0") int sortOrder,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam MultipartFile imageFile) {

        AdBannerVO banner = new AdBannerVO();
        banner.setMediaId(mediaId);
        banner.setPlatformId(platformId);
        banner.setPlacementId(placementId);
        banner.setTitle(title.trim());
        banner.setClickUrl(clickUrl);
        banner.setAltText(altText);
        banner.setStatus(status);
        banner.setWeight(weight);
        banner.setSortOrder(sortOrder);
        banner.setStartDate(startDate);
        banner.setEndDate(endDate);

        long bannerId = bannerService.writeBanner(banner, imageFile);
        return "redirect:/admin/banner/view/" + bannerId;
    }

    /* ═══════ 상세 조회 ═══════ */

    @GetMapping("/view/{bannerId}")
    public String view(@PathVariable long bannerId,
                       @RequestParam(defaultValue = "1") int page,
                       Model model) {
        AdBannerVO banner = bannerService.getBanner(bannerId);
        if (banner == null) return "redirect:/admin/banner";

        model.addAttribute("banner", banner);
        model.addAttribute("currentPage", page);
        return "admin/banner/view";
    }

    /* ═══════ 수정 폼 ═══════ */

    @GetMapping("/edit/{bannerId}")
    public String editForm(@PathVariable long bannerId, Model model) {
        AdBannerVO banner = bannerService.getBanner(bannerId);
        if (banner == null) return "redirect:/admin/banner";

        model.addAttribute("banner", banner);
        model.addAttribute("mediaList", mediaService.getMediaList());

        // 전체 등록된 플랫폼 목록
        model.addAttribute("platformList", mediaService.getAllPlatforms());
        // 현재 배너의 플랫폼에 해당하는 노출위치 목록
        model.addAttribute("placementList", mediaService.getPlacementsByPlatform(banner.getPlatformId()));

        return "admin/banner/form";
    }

    /* ═══════ 수정 처리 ═══════ */

    @PostMapping("/edit/{bannerId}")
    public String edit(
            @PathVariable long bannerId,
            @RequestParam long mediaId,
            @RequestParam long platformId,
            @RequestParam long placementId,
            @RequestParam String title,
            @RequestParam(required = false) String clickUrl,
            @RequestParam(required = false) String altText,
            @RequestParam(defaultValue = "INACTIVE") String status,
            @RequestParam(defaultValue = "1") int weight,
            @RequestParam(defaultValue = "0") int sortOrder,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) MultipartFile newImageFile) {

        AdBannerVO banner = new AdBannerVO();
        banner.setBannerId(bannerId);
        banner.setMediaId(mediaId);
        banner.setPlatformId(platformId);
        banner.setPlacementId(placementId);
        banner.setTitle(title.trim());
        banner.setClickUrl(clickUrl);
        banner.setAltText(altText);
        banner.setStatus(status);
        banner.setWeight(weight);
        banner.setSortOrder(sortOrder);
        banner.setStartDate(startDate);
        banner.setEndDate(endDate);

        bannerService.editBanner(banner, newImageFile);
        return "redirect:/admin/banner/view/" + bannerId;
    }

    /* ═══════ 삭제 (AJAX) ═══════ */

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> delete(@RequestParam long bannerId) {
        bannerService.deleteBanner(bannerId);
        Map<String, Object> r = new HashMap<>();
        r.put("success", true);
        return ResponseEntity.ok(r);
    }

    /* ═══════ 상태 토글 (AJAX) ═══════ */

    @PostMapping("/toggle-status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleStatus(@RequestParam long bannerId) {
        bannerService.toggleBannerStatus(bannerId);
        Map<String, Object> r = new HashMap<>();
        r.put("success", true);
        return ResponseEntity.ok(r);
    }

    /* ═══════ AJAX: 매체별 플랫폼 조회 ═══════ */

    @GetMapping("/api/platforms")
    @ResponseBody
    public List<AdPlatformVO> getPlatforms(@RequestParam long mediaId) {
        return mediaService.getPlatformsByMedia(mediaId);
    }

    /* ═══════ AJAX: 플랫폼별 노출위치 조회 ═══════ */

    @GetMapping("/api/placements")
    @ResponseBody
    public List<AdPlacementVO> getPlacements(@RequestParam long platformId) {
        return mediaService.getPlacementsByPlatform(platformId);
    }
}
