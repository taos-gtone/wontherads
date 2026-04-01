package com.wontherads.vo;

import java.sql.Timestamp;

public class AdminLoginInfoVO {
    private String    adminId;
    private String    adminPw;
    private String    admEmailId;
    private String    admEmailAddr;
    private Timestamp lastLoginAt;
    private Timestamp createTs;
    private Timestamp updateTs;

    public String getAdminId() { return adminId; }
    public void setAdminId(String adminId) { this.adminId = adminId; }
    public String getAdminPw() { return adminPw; }
    public void setAdminPw(String adminPw) { this.adminPw = adminPw; }
    public String getAdmEmailId() { return admEmailId; }
    public void setAdmEmailId(String admEmailId) { this.admEmailId = admEmailId; }
    public String getAdmEmailAddr() { return admEmailAddr; }
    public void setAdmEmailAddr(String admEmailAddr) { this.admEmailAddr = admEmailAddr; }
    public Timestamp getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(Timestamp lastLoginAt) { this.lastLoginAt = lastLoginAt; }
    public Timestamp getCreateTs() { return createTs; }
    public void setCreateTs(Timestamp createTs) { this.createTs = createTs; }
    public Timestamp getUpdateTs() { return updateTs; }
    public void setUpdateTs(Timestamp updateTs) { this.updateTs = updateTs; }
}
