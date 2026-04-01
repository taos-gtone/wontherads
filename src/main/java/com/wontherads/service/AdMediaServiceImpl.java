package com.wontherads.service;

import com.wontherads.mapper.AdMediaMapper;
import com.wontherads.vo.AdMediaVO;
import com.wontherads.vo.AdPlatformVO;
import com.wontherads.vo.AdPlacementVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdMediaServiceImpl implements AdMediaService {

    @Autowired
    private AdMediaMapper adMediaMapper;

    /* ══════ 매체 ══════ */

    @Override
    public List<AdMediaVO> getMediaList() {
        return adMediaMapper.selectMediaList();
    }

    @Override
    public List<AdMediaVO> getAllMediaList() {
        return adMediaMapper.selectAllMediaList();
    }

    @Override
    public AdMediaVO getMedia(long mediaId) {
        return adMediaMapper.selectMedia(mediaId);
    }

    @Override
    public void writeMedia(AdMediaVO media, long[] platformIds) {
        adMediaMapper.insertMedia(media);
        savePlatformMappings(media.getMediaId(), platformIds);
    }

    @Override
    public void editMedia(AdMediaVO media, long[] platformIds) {
        adMediaMapper.updateMedia(media);
        savePlatformMappings(media.getMediaId(), platformIds);
    }

    @Override
    public void deleteMedia(long mediaId) {
        adMediaMapper.deleteMediaPlatformByMedia(mediaId);
        adMediaMapper.deleteMedia(mediaId);
    }

    @Override
    public List<Long> getMappedPlatformIds(long mediaId) {
        return adMediaMapper.selectMappedPlatformIds(mediaId);
    }

    private void savePlatformMappings(long mediaId, long[] platformIds) {
        adMediaMapper.deleteMediaPlatformByMedia(mediaId);
        if (platformIds != null) {
            for (long pid : platformIds) {
                adMediaMapper.insertMediaPlatform(mediaId, pid);
            }
        }
    }

    /* ══════ 플랫폼 ══════ */

    @Override
    public List<AdPlatformVO> getAllPlatforms() {
        return adMediaMapper.selectAllPlatforms();
    }

    @Override
    public List<AdPlatformVO> getAllPlatformsList() {
        return adMediaMapper.selectAllPlatformsList();
    }

    @Override
    public AdPlatformVO getPlatform(long platformId) {
        return adMediaMapper.selectPlatform(platformId);
    }

    @Override
    public void writePlatform(AdPlatformVO platform) {
        adMediaMapper.insertPlatform(platform);
    }

    @Override
    public void editPlatform(AdPlatformVO platform) {
        adMediaMapper.updatePlatform(platform);
    }

    @Override
    public void deletePlatform(long platformId) {
        adMediaMapper.deletePlatform(platformId);
    }

    @Override
    public List<AdPlatformVO> getPlatformsByMedia(long mediaId) {
        return adMediaMapper.selectPlatformsByMedia(mediaId);
    }

    /* ══════ 노출위치 ══════ */

    @Override
    public List<AdPlacementVO> getPlacementsByPlatform(long platformId) {
        return adMediaMapper.selectPlacementsByPlatform(platformId);
    }

    @Override
    public List<AdPlacementVO> getPlacementsByPlatformAll(long platformId) {
        return adMediaMapper.selectPlacementsByPlatformAll(platformId);
    }

    @Override
    public List<AdPlacementVO> getAllPlacementsList() {
        return adMediaMapper.selectAllPlacementsList();
    }

    @Override
    public AdPlacementVO getPlacement(long placementId) {
        return adMediaMapper.selectPlacement(placementId);
    }

    @Override
    public void writePlacement(AdPlacementVO placement) {
        adMediaMapper.insertPlacement(placement);
    }

    @Override
    public void editPlacement(AdPlacementVO placement) {
        adMediaMapper.updatePlacement(placement);
    }

    @Override
    public void deletePlacement(long placementId) {
        adMediaMapper.deletePlacement(placementId);
    }
}
