package com.wontherads.controller;

import com.wontherads.service.AdMediaService;
import com.wontherads.vo.AdPlatformVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/platform")
public class AdPlatformController {

    @Autowired
    private AdMediaService mediaService;

    @GetMapping({"", "/list"})
    public String list(Model model) {
        model.addAttribute("platformList", mediaService.getAllPlatformsList());
        return "admin/platform/list";
    }

    @GetMapping("/write")
    public String writeForm() {
        return "admin/platform/form";
    }

    @PostMapping("/write")
    public String write(@RequestParam String platformCode,
                        @RequestParam String platformName,
                        @RequestParam(defaultValue = "Y") String useYn) {
        AdPlatformVO platform = new AdPlatformVO();
        platform.setPlatformCode(platformCode.trim().toUpperCase());
        platform.setPlatformName(platformName.trim());
        platform.setUseYn(useYn);
        mediaService.writePlatform(platform);
        return "redirect:/admin/platform";
    }

    @GetMapping("/edit/{platformId}")
    public String editForm(@PathVariable long platformId, Model model) {
        AdPlatformVO platform = mediaService.getPlatform(platformId);
        if (platform == null) return "redirect:/admin/platform";
        model.addAttribute("platform", platform);
        return "admin/platform/form";
    }

    @PostMapping("/edit/{platformId}")
    public String edit(@PathVariable long platformId,
                       @RequestParam String platformCode,
                       @RequestParam String platformName,
                       @RequestParam(defaultValue = "Y") String useYn) {
        AdPlatformVO platform = new AdPlatformVO();
        platform.setPlatformId(platformId);
        platform.setPlatformCode(platformCode.trim().toUpperCase());
        platform.setPlatformName(platformName.trim());
        platform.setUseYn(useYn);
        mediaService.editPlatform(platform);
        return "redirect:/admin/platform";
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> delete(@RequestParam long platformId) {
        mediaService.deletePlatform(platformId);
        Map<String, Object> r = new HashMap<>();
        r.put("success", true);
        return ResponseEntity.ok(r);
    }
}
