package com.wontherads.mapper;

import com.wontherads.vo.AdMediaVO;
import com.wontherads.vo.AdPlatformVO;
import com.wontherads.vo.AdPlacementVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdMediaMapper {

    /* ── 매체 (ADS_MEDIA) ── */
    List<AdMediaVO> selectMediaList();
    List<AdMediaVO> selectAllMediaList();
    AdMediaVO selectMedia(@Param("mediaId") long mediaId);
    void insertMedia(AdMediaVO media);
    void updateMedia(AdMediaVO media);
    void deleteMedia(@Param("mediaId") long mediaId);

    /* ── 플랫폼 (ADS_PLATFORM) ── */
    List<AdPlatformVO> selectAllPlatforms();
    List<AdPlatformVO> selectAllPlatformsList();
    AdPlatformVO selectPlatform(@Param("platformId") long platformId);
    void insertPlatform(AdPlatformVO platform);
    void updatePlatform(AdPlatformVO platform);
    void deletePlatform(@Param("platformId") long platformId);

    /* ── 매체-플랫폼 매핑 (ADS_MEDIA_PLATFORM) ── */
    List<AdPlatformVO> selectPlatformsByMedia(@Param("mediaId") long mediaId);
    List<Long> selectMappedPlatformIds(@Param("mediaId") long mediaId);
    void deleteMediaPlatformByMedia(@Param("mediaId") long mediaId);
    void insertMediaPlatform(@Param("mediaId") long mediaId, @Param("platformId") long platformId);

    /* ── 노출위치 (ADS_PLACEMENT) ── */
    List<AdPlacementVO> selectPlacementsByPlatform(@Param("platformId") long platformId);
    List<AdPlacementVO> selectPlacementsByPlatformAll(@Param("platformId") long platformId);
    List<AdPlacementVO> selectAllPlacementsList();
    AdPlacementVO selectPlacement(@Param("placementId") long placementId);
    void insertPlacement(AdPlacementVO placement);
    void updatePlacement(AdPlacementVO placement);
    void deletePlacement(@Param("placementId") long placementId);
}
