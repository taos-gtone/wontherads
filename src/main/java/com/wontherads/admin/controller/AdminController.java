package com.wontherads.admin.controller;

import com.wontherads.admin.service.AdminService;
import com.wontherads.vo.AdminLoginInfoVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    /* ════════ Root redirect ════════ */

    @GetMapping({"", "/"})
    public String root(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            return "redirect:/admin/banner";
        }
        return "redirect:/admin/login";
    }

    /* ════════ Login ════════ */

    @GetMapping("/login")
    public String loginForm(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            return "redirect:/admin/banner";
        }
        return "admin/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String adminId, @RequestParam String adminPw,
                        HttpServletRequest request, Model model) {

        AdminLoginInfoVO admin = adminService.getAdminById(adminId);
        if (admin == null) {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "admin/login";
        }
        if (!BCrypt.checkpw(adminPw, admin.getAdminPw())) {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "admin/login";
        }

        adminService.recordLoginSuccess(adminId);
        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(1800);
        session.setAttribute("adminUser", adminId);
        return "redirect:/admin/banner";
    }

    /* ════════ Logout ════════ */

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        return "redirect:/admin/login";
    }
}
