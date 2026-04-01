package com.wontherads.admin.service;

import com.wontherads.mapper.AdminMapper;
import com.wontherads.vo.AdminLoginInfoVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMapper adminMapper;

    @Override
    public AdminLoginInfoVO getAdminById(String adminId) {
        return adminMapper.selectAdminById(adminId);
    }

    @Override
    public void recordLoginSuccess(String adminId) {
        adminMapper.updateLastLoginAt(adminId);
    }
}
