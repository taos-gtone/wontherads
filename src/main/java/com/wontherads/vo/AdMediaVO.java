package com.wontherads.vo;

import java.sql.Timestamp;

public class AdMediaVO {
    private long      mediaId;
    private String    mediaName;
    private String    mediaUrl;
    private String    description;
    private String    useYn;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public long getMediaId() { return mediaId; }
    public void setMediaId(long mediaId) { this.mediaId = mediaId; }
    public String getMediaName() { return mediaName; }
    public void setMediaName(String mediaName) { this.mediaName = mediaName; }
    public String getMediaUrl() { return mediaUrl; }
    public void setMediaUrl(String mediaUrl) { this.mediaUrl = mediaUrl; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
