package com.wontherads.controller;

import com.wontherads.service.AdMediaService;
import com.wontherads.vo.AdMediaVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/media")
public class AdMediaController {

    @Autowired
    private AdMediaService mediaService;

    @GetMapping({"", "/list"})
    public String list(Model model) {
        model.addAttribute("mediaList", mediaService.getAllMediaList());
        return "admin/media/list";
    }

    @GetMapping("/write")
    public String writeForm(Model model) {
        model.addAttribute("platformList", mediaService.getAllPlatformsList());
        return "admin/media/form";
    }

    @PostMapping("/write")
    public String write(@RequestParam String mediaName,
                        @RequestParam(required = false) String mediaUrl,
                        @RequestParam(required = false) String description,
                        @RequestParam(defaultValue = "Y") String useYn,
                        @RequestParam(required = false) long[] platformIds) {
        AdMediaVO media = new AdMediaVO();
        media.setMediaName(mediaName.trim());
        media.setMediaUrl(mediaUrl);
        media.setDescription(description);
        media.setUseYn(useYn);
        mediaService.writeMedia(media, platformIds);
        return "redirect:/admin/media";
    }

    @GetMapping("/edit/{mediaId}")
    public String editForm(@PathVariable long mediaId, Model model) {
        AdMediaVO media = mediaService.getMedia(mediaId);
        if (media == null) return "redirect:/admin/media";
        model.addAttribute("media", media);
        model.addAttribute("platformList", mediaService.getAllPlatformsList());
        model.addAttribute("mappedPlatformIds", mediaService.getMappedPlatformIds(mediaId));
        return "admin/media/form";
    }

    @PostMapping("/edit/{mediaId}")
    public String edit(@PathVariable long mediaId,
                       @RequestParam String mediaName,
                       @RequestParam(required = false) String mediaUrl,
                       @RequestParam(required = false) String description,
                       @RequestParam(defaultValue = "Y") String useYn,
                       @RequestParam(required = false) long[] platformIds) {
        AdMediaVO media = new AdMediaVO();
        media.setMediaId(mediaId);
        media.setMediaName(mediaName.trim());
        media.setMediaUrl(mediaUrl);
        media.setDescription(description);
        media.setUseYn(useYn);
        mediaService.editMedia(media, platformIds);
        return "redirect:/admin/media";
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> delete(@RequestParam long mediaId) {
        mediaService.deleteMedia(mediaId);
        Map<String, Object> r = new HashMap<>();
        r.put("success", true);
        return ResponseEntity.ok(r);
    }
}
