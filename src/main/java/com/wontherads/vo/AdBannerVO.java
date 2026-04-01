package com.wontherads.vo;

import java.sql.Timestamp;

public class AdBannerVO {
    // DB columns (ADS_BANNER)
    private long      bannerId;
    private long      mediaId;
    private long      platformId;
    private long      placementId;
    private String    title;
    private String    imagePath;
    private String    clickUrl;
    private String    altText;
    private String    status;       // ACTIVE, INACTIVE, SCHEDULED
    private int       weight;       // 노출 가중치 1~100
    private int       sortOrder;
    private String    startDate;    // yyyy-MM-dd HH:mm
    private String    endDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String    deletedYn;

    // JOIN fields
    private String    mediaName;       // ADS_MEDIA.media_name
    private String    platformName;    // ADS_PLATFORM.platform_name
    private String    platformCode;    // ADS_PLATFORM.platform_code
    private String    placementName;   // ADS_PLACEMENT.placement_name
    private int       placementWidth;  // ADS_PLACEMENT.width
    private int       placementHeight; // ADS_PLACEMENT.height

    public long getBannerId() { return bannerId; }
    public void setBannerId(long bannerId) { this.bannerId = bannerId; }
    public long getMediaId() { return mediaId; }
    public void setMediaId(long mediaId) { this.mediaId = mediaId; }
    public long getPlatformId() { return platformId; }
    public void setPlatformId(long platformId) { this.platformId = platformId; }
    public long getPlacementId() { return placementId; }
    public void setPlacementId(long placementId) { this.placementId = placementId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    public String getClickUrl() { return clickUrl; }
    public void setClickUrl(String clickUrl) { this.clickUrl = clickUrl; }
    public String getAltText() { return altText; }
    public void setAltText(String altText) { this.altText = altText; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getWeight() { return weight; }
    public void setWeight(int weight) { this.weight = weight; }
    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }
    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public String getDeletedYn() { return deletedYn; }
    public void setDeletedYn(String deletedYn) { this.deletedYn = deletedYn; }
    public String getMediaName() { return mediaName; }
    public void setMediaName(String mediaName) { this.mediaName = mediaName; }
    public String getPlatformName() { return platformName; }
    public void setPlatformName(String platformName) { this.platformName = platformName; }
    public String getPlatformCode() { return platformCode; }
    public void setPlatformCode(String platformCode) { this.platformCode = platformCode; }
    public String getPlacementName() { return placementName; }
    public void setPlacementName(String placementName) { this.placementName = placementName; }
    public int getPlacementWidth() { return placementWidth; }
    public void setPlacementWidth(int placementWidth) { this.placementWidth = placementWidth; }
    public int getPlacementHeight() { return placementHeight; }
    public void setPlacementHeight(int placementHeight) { this.placementHeight = placementHeight; }

    public String getTimeAgo() {
        if (createdAt == null) return "";
        long diff = System.currentTimeMillis() - createdAt.getTime();
        long sec = diff / 1000;
        if (sec < 60)    return sec + "초 전";
        long min = sec / 60;
        if (min < 60)    return min + "분 전";
        long hour = min / 60;
        if (hour < 24)   return hour + "시간 전";
        long day = hour / 24;
        if (day < 30)    return day + "일 전";
        long month = day / 30;
        if (month < 12)  return month + "개월 전";
        return (month / 12) + "년 전";
    }
}
