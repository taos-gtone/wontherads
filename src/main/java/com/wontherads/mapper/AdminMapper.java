package com.wontherads.mapper;

import com.wontherads.vo.AdminLoginInfoVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AdminMapper {

    AdminLoginInfoVO selectAdminById(@Param("adminId") String adminId);

    void updateLastLoginAt(@Param("adminId") String adminId);
}
