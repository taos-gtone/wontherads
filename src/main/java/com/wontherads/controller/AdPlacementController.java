package com.wontherads.controller;

import com.wontherads.service.AdMediaService;
import com.wontherads.vo.AdPlacementVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/placement")
public class AdPlacementController {

    @Autowired
    private AdMediaService mediaService;

    @GetMapping({"", "/list"})
    public String list(@RequestParam(defaultValue = "0") long platformId, Model model) {
        if (platformId > 0) {
            model.addAttribute("placementList", mediaService.getPlacementsByPlatformAll(platformId));
        } else {
            model.addAttribute("placementList", mediaService.getAllPlacementsList());
        }
        model.addAttribute("platformList", mediaService.getAllPlatformsList());
        model.addAttribute("platformId", platformId);
        return "admin/placement/list";
    }

    @GetMapping("/write")
    public String writeForm(Model model) {
        model.addAttribute("platformList", mediaService.getAllPlatformsList());
        return "admin/placement/form";
    }

    @PostMapping("/write")
    public String write(@RequestParam long platformId,
                        @RequestParam String placementCode,
                        @RequestParam String placementName,
                        @RequestParam(defaultValue = "0") int width,
                        @RequestParam(defaultValue = "0") int height,
                        @RequestParam(required = false) String description,
                        @RequestParam(defaultValue = "Y") String useYn) {
        AdPlacementVO placement = new AdPlacementVO();
        placement.setPlatformId(platformId);
        placement.setPlacementCode(placementCode.trim().toUpperCase());
        placement.setPlacementName(placementName.trim());
        placement.setWidth(width);
        placement.setHeight(height);
        placement.setDescription(description);
        placement.setUseYn(useYn);
        mediaService.writePlacement(placement);
        return "redirect:/admin/placement";
    }

    @GetMapping("/edit/{placementId}")
    public String editForm(@PathVariable long placementId, Model model) {
        AdPlacementVO placement = mediaService.getPlacement(placementId);
        if (placement == null) return "redirect:/admin/placement";
        model.addAttribute("placement", placement);
        model.addAttribute("platformList", mediaService.getAllPlatformsList());
        return "admin/placement/form";
    }

    @PostMapping("/edit/{placementId}")
    public String edit(@PathVariable long placementId,
                       @RequestParam long platformId,
                       @RequestParam String placementCode,
                       @RequestParam String placementName,
                       @RequestParam(defaultValue = "0") int width,
                       @RequestParam(defaultValue = "0") int height,
                       @RequestParam(required = false) String description,
                       @RequestParam(defaultValue = "Y") String useYn) {
        AdPlacementVO placement = new AdPlacementVO();
        placement.setPlacementId(placementId);
        placement.setPlatformId(platformId);
        placement.setPlacementCode(placementCode.trim().toUpperCase());
        placement.setPlacementName(placementName.trim());
        placement.setWidth(width);
        placement.setHeight(height);
        placement.setDescription(description);
        placement.setUseYn(useYn);
        mediaService.editPlacement(placement);
        return "redirect:/admin/placement";
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> delete(@RequestParam long placementId) {
        mediaService.deletePlacement(placementId);
        Map<String, Object> r = new HashMap<>();
        r.put("success", true);
        return ResponseEntity.ok(r);
    }
}
