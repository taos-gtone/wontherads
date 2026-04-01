<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wontherads.vo.AdBannerVO" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/views/admin/layout/head.jsp" %>
<body class="admin-body">
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<%
  AdBannerVO banner = (AdBannerVO) request.getAttribute("banner");
  Integer currentPageObj = (Integer) request.getAttribute("currentPage");
  int currentPage = (currentPageObj != null) ? currentPageObj : 1;
%>

<div class="adm-content">
  <h1 class="adm-page-title">배너 상세</h1>

  <% if (banner != null) { %>
  <div class="adm-card" style="max-width:800px;">

    <!-- 이미지 미리보기 -->
    <div style="text-align:center;margin-bottom:24px;padding:20px;background:#f8f9fa;border-radius:8px;">
      <img src="<%= ctx %>/upload<%= banner.getImagePath() %>" alt="<%= banner.getAltText() != null ? org.springframework.web.util.HtmlUtils.htmlEscape(banner.getAltText()) : "" %>"
           style="max-width:100%;max-height:300px;border-radius:4px;">
    </div>

    <table class="adm-detail-table">
      <tr><th>배너 ID</th><td><%= banner.getBannerId() %></td></tr>
      <tr><th>매체</th><td><%= banner.getMediaName() %></td></tr>
      <tr><th>플랫폼</th><td><%= banner.getPlatformName() %> (<%= banner.getPlatformCode() %>)</td></tr>
      <tr><th>노출 위치</th><td><%= banner.getPlacementName() %> (<%= banner.getPlacementWidth() %>x<%= banner.getPlacementHeight() %>px)</td></tr>
      <tr><th>제목</th><td><%= org.springframework.web.util.HtmlUtils.htmlEscape(banner.getTitle()) %></td></tr>
      <tr><th>클릭 URL</th><td>
        <% if (banner.getClickUrl() != null && !banner.getClickUrl().isEmpty()) { %>
          <a href="<%= org.springframework.web.util.HtmlUtils.htmlEscape(banner.getClickUrl()) %>" target="_blank"><%= org.springframework.web.util.HtmlUtils.htmlEscape(banner.getClickUrl()) %></a>
        <% } else { %>-<% } %>
      </td></tr>
      <tr><th>대체 텍스트</th><td><%= banner.getAltText() != null ? org.springframework.web.util.HtmlUtils.htmlEscape(banner.getAltText()) : "-" %></td></tr>
      <tr><th>상태</th><td>
        <span class="adm-badge <%= "ACTIVE".equals(banner.getStatus()) ? "badge-active" : "SCHEDULED".equals(banner.getStatus()) ? "badge-scheduled" : "badge-inactive" %>">
          <%= "ACTIVE".equals(banner.getStatus()) ? "활성" : "SCHEDULED".equals(banner.getStatus()) ? "예약" : "비활성" %>
        </span>
      </td></tr>
      <tr><th>노출 가중치</th><td><%= banner.getWeight() %></td></tr>
      <tr><th>정렬 순서</th><td><%= banner.getSortOrder() %></td></tr>
      <tr><th>시작일시</th><td><%= banner.getStartDate() != null ? banner.getStartDate() : "-" %></td></tr>
      <tr><th>종료일시</th><td><%= banner.getEndDate() != null ? banner.getEndDate() : "-" %></td></tr>
      <tr><th>등록일</th><td><%= banner.getCreatedAt() %></td></tr>
      <tr><th>수정일</th><td><%= banner.getUpdatedAt() != null ? banner.getUpdatedAt() : "-" %></td></tr>
    </table>

    <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:24px;">
      <a href="<%= ctx %>/admin/banner?page=<%= currentPage %>" class="adm-btn-sm" style="padding:8px 20px;">목록</a>
      <a href="<%= ctx %>/admin/banner/edit/<%= banner.getBannerId() %>" class="adm-btn-sm" style="padding:8px 20px;background:var(--adm-primary);color:#fff;border:none;">수정</a>
      <button class="adm-btn-sm danger" style="padding:8px 20px;" onclick="deleteBanner(<%= banner.getBannerId() %>)">삭제</button>
    </div>
  </div>
  <% } %>
</div>

<script>
var ctx = '<%= ctx %>';
function deleteBanner(bannerId) {
  if (!confirm('정말 삭제하시겠습니까?')) return;
  fetch(ctx + '/admin/banner/delete', {
    method:'POST',
    headers:{'Content-Type':'application/x-www-form-urlencoded'},
    body:'bannerId=' + bannerId
  }).then(function(r){return r.json()}).then(function(d){
    if (d.success) location.href = ctx + '/admin/banner';
  });
}
</script>
</body>
</html>
