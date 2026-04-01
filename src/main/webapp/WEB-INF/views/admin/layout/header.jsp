<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  String admUser = (String) session.getAttribute("adminUser");
%>

<!-- Header -->
<header class="adm-header">
  <div class="adm-header-logo">WontherAds <span>ADMIN</span></div>
  <div class="adm-header-right">
    <span class="adm-header-user"><%= admUser != null ? admUser : "" %></span>
    <a href="<%= ctx %>/admin/logout" class="adm-btn-logout" onclick="return confirm('로그아웃 하시겠습니까?')">로그아웃</a>
  </div>
</header>

<!-- Sidebar -->
<aside class="adm-sidebar">
  <div class="adm-nav-title">기본 설정</div>
  <a href="<%= ctx %>/admin/media" class="adm-nav-item">
    <span class="adm-nav-icon">🌐</span> 매체 관리
  </a>
  <a href="<%= ctx %>/admin/platform" class="adm-nav-item">
    <span class="adm-nav-icon">📱</span> 플랫폼 관리
  </a>
  <a href="<%= ctx %>/admin/placement" class="adm-nav-item">
    <span class="adm-nav-icon">📐</span> 광고위치 관리
  </a>

  <div class="adm-nav-divider"></div>

  <div class="adm-nav-title">광고 관리</div>
  <a href="<%= ctx %>/admin/banner" class="adm-nav-item">
    <span class="adm-nav-icon">🖼️</span> 배너 관리
  </a>
</aside>
