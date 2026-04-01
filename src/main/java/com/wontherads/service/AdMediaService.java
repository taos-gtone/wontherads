package com.wontherads.service;

import com.wontherads.vo.AdMediaVO;
import com.wontherads.vo.AdPlatformVO;
import com.wontherads.vo.AdPlacementVO;

import java.util.List;

public interface AdMediaService {

    /* ── 매체 ── */
    List<AdMediaVO> getMediaList();
    List<AdMediaVO> getAllMediaList();
    AdMediaVO getMedia(long mediaId);
    void writeMedia(AdMediaVO media, long[] platformIds);
    void editMedia(AdMediaVO media, long[] platformIds);
    void deleteMedia(long mediaId);
    List<Long> getMappedPlatformIds(long mediaId);

    /* ── 플랫폼 ── */
    List<AdPlatformVO> getAllPlatforms();
    List<AdPlatformVO> getAllPlatformsList();
    AdPlatformVO getPlatform(long platformId);
    void writePlatform(AdPlatformVO platform);
    void editPlatform(AdPlatformVO platform);
    void deletePlatform(long platformId);
    List<AdPlatformVO> getPlatformsByMedia(long mediaId);

    /* ── 노출위치 ── */
    List<AdPlacementVO> getPlacementsByPlatform(long platformId);
    List<AdPlacementVO> getPlacementsByPlatformAll(long platformId);
    List<AdPlacementVO> getAllPlacementsList();
    AdPlacementVO getPlacement(long placementId);
    void writePlacement(AdPlacementVO placement);
    void editPlacement(AdPlacementVO placement);
    void deletePlacement(long placementId);
}
