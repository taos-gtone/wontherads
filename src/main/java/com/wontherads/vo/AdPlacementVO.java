package com.wontherads.vo;

import java.sql.Timestamp;

public class AdPlacementVO {
    private long      placementId;
    private long      platformId;
    private String    placementCode;
    private String    placementName;
    private int       width;
    private int       height;
    private String    description;
    private String    useYn;
    private Timestamp createdAt;

    // JOIN field
    private String    platformName;

    public long getPlacementId() { return placementId; }
    public void setPlacementId(long placementId) { this.placementId = placementId; }
    public long getPlatformId() { return platformId; }
    public void setPlatformId(long platformId) { this.platformId = platformId; }
    public String getPlacementCode() { return placementCode; }
    public void setPlacementCode(String placementCode) { this.placementCode = placementCode; }
    public String getPlacementName() { return placementName; }
    public void setPlacementName(String placementName) { this.placementName = placementName; }
    public int getWidth() { return width; }
    public void setWidth(int width) { this.width = width; }
    public int getHeight() { return height; }
    public void setHeight(int height) { this.height = height; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getPlatformName() { return platformName; }
    public void setPlatformName(String platformName) { this.platformName = platformName; }
}
