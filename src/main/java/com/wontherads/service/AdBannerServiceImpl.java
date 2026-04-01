package com.wontherads.service;

import com.wontherads.mapper.AdBannerMapper;
import com.wontherads.vo.AdBannerVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Service
public class AdBannerServiceImpl implements AdBannerService {

    private static final Logger log = LoggerFactory.getLogger(AdBannerServiceImpl.class);

    @Autowired
    private AdBannerMapper adBannerMapper;

    @Value("${file.upload.base-path}")
    private String basePath;

    @Value("${file.upload.banner-path}")
    private String bannerPath;

    @Override
    public List<AdBannerVO> getBannerList(long mediaId, long platformId, String status,
                                           String searchKeyword, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return adBannerMapper.selectBannerList(mediaId, platformId, status, searchKeyword, offset, pageSize);
    }

    @Override
    public int getBannerCount(long mediaId, long platformId, String status, String searchKeyword) {
        return adBannerMapper.selectBannerCount(mediaId, platformId, status, searchKeyword);
    }

    @Override
    public AdBannerVO getBanner(long bannerId) {
        return adBannerMapper.selectBanner(bannerId);
    }

    @Override
    public long writeBanner(AdBannerVO banner, MultipartFile imageFile) {
        String savedPath = saveImage(imageFile);
        banner.setImagePath(savedPath);
        adBannerMapper.insertBanner(banner);
        return banner.getBannerId();
    }

    @Override
    public void editBanner(AdBannerVO banner, MultipartFile newImageFile) {
        if (newImageFile != null && !newImageFile.isEmpty()) {
            // 기존 이미지 삭제
            AdBannerVO old = adBannerMapper.selectBanner(banner.getBannerId());
            if (old != null && old.getImagePath() != null) {
                deleteImageFile(old.getImagePath());
            }
            String savedPath = saveImage(newImageFile);
            banner.setImagePath(savedPath);
        }
        adBannerMapper.updateBanner(banner);
    }

    @Override
    public void deleteBanner(long bannerId) {
        adBannerMapper.deleteBanner(bannerId);
    }

    @Override
    public void toggleBannerStatus(long bannerId) {
        adBannerMapper.toggleBannerStatus(bannerId);
    }

    private String saveImage(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("이미지 파일이 필요합니다.");
        }

        String orgName = file.getOriginalFilename();
        String ext = orgName != null && orgName.contains(".")
                ? orgName.substring(orgName.lastIndexOf(".") + 1).toLowerCase()
                : "";

        if (!ext.matches("jpg|jpeg|png|gif|webp")) {
            throw new IllegalArgumentException("허용되지 않은 파일 형식: " + ext);
        }

        if (file.getSize() > 5 * 1024 * 1024) {
            throw new IllegalArgumentException("파일 크기가 5MB를 초과합니다.");
        }

        String dateDir = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String fileName = UUID.randomUUID() + "." + ext;
        String relativePath = bannerPath + "/" + dateDir + "/" + fileName;
        File dest = new File(basePath + relativePath);

        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }

        try (java.io.InputStream in = file.getInputStream();
             java.io.OutputStream out = new java.io.FileOutputStream(dest)) {
            in.transferTo(out);
        } catch (IOException e) {
            log.error("이미지 저장 실패: {}", dest.getAbsolutePath(), e);
            throw new RuntimeException("이미지 저장에 실패했습니다.", e);
        }

        return relativePath;
    }

    private void deleteImageFile(String imagePath) {
        if (imagePath == null || imagePath.isEmpty()) return;
        File file = new File(basePath + imagePath);
        if (file.exists()) {
            file.delete();
        }
    }
}
