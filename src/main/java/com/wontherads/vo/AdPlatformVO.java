package com.wontherads.vo;

import java.sql.Timestamp;

public class AdPlatformVO {
    private long      platformId;
    private String    platformCode;
    private String    platformName;
    private String    useYn;
    private Timestamp createdAt;

    public long getPlatformId() { return platformId; }
    public void setPlatformId(long platformId) { this.platformId = platformId; }
    public String getPlatformCode() { return platformCode; }
    public void setPlatformCode(String platformCode) { this.platformCode = platformCode; }
    public String getPlatformName() { return platformName; }
    public void setPlatformName(String platformName) { this.platformName = platformName; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
