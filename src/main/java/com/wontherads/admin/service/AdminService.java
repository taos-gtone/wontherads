package com.wontherads.admin.service;

import com.wontherads.vo.AdminLoginInfoVO;

public interface AdminService {

    AdminLoginInfoVO getAdminById(String adminId);

    void recordLoginSuccess(String adminId);
}
