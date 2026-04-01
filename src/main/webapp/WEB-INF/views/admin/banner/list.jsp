<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wontherads.vo.AdBannerVO" %>
<%@ page import="com.wontherads.vo.AdMediaVO" %>
<%@ page import="com.wontherads.vo.AdPlatformVO" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/views/admin/layout/head.jsp" %>
<body class="admin-body">
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<%
  @SuppressWarnings("unchecked")
  List<AdBannerVO> bannerList = (List<AdBannerVO>) request.getAttribute("bannerList");
  @SuppressWarnings("unchecked")
  List<AdMediaVO> mediaList = (List<AdMediaVO>) request.getAttribute("mediaList");
  @SuppressWarnings("unchecked")
  List<AdPlatformVO> platformList = (List<AdPlatformVO>) request.getAttribute("platformList");

  Integer currentPageObj = (Integer) request.getAttribute("currentPage");
  Integer totalPagesObj  = (Integer) request.getAttribute("totalPages");
  Integer startPageObj   = (Integer) request.getAttribute("startPage");
  Integer endPageObj     = (Integer) request.getAttribute("endPage");
  Integer totalCountObj  = (Integer) request.getAttribute("totalCount");

  int currentPage = (currentPageObj != null) ? currentPageObj : 1;
  int totalPages  = (totalPagesObj  != null) ? totalPagesObj  : 1;
  int startPage   = (startPageObj   != null) ? startPageObj   : 1;
  int endPage     = (endPageObj     != null) ? endPageObj     : totalPages;
  int totalCount  = (totalCountObj  != null) ? totalCountObj  : 0;

  Long mediaIdObj = (Long) request.getAttribute("mediaId");
  Long platformIdObj = (Long) request.getAttribute("platformId");
  long selMediaId = (mediaIdObj != null) ? mediaIdObj : 0;
  long selPlatformId = (platformIdObj != null) ? platformIdObj : 0;
  String selStatus = (String) request.getAttribute("status");
  String searchKeyword = (String) request.getAttribute("searchKeyword");
  if (selStatus == null) selStatus = "";
  if (searchKeyword == null) searchKeyword = "";

  String baseUrl = ctx + "/admin/banner";
  String params = "mediaId=" + selMediaId
      + "&platformId=" + selPlatformId
      + "&status=" + selStatus
      + (!searchKeyword.isEmpty() ? "&searchKeyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8") : "");
%>

<div class="adm-content">
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;">
    <h1 class="adm-page-title" style="margin-bottom:0;">배너 광고 관리</h1>
    <a href="<%= ctx %>/admin/banner/write" class="adm-btn-sm" style="padding:6px 16px;font-size:13px;background:var(--adm-primary);color:#fff;border:none;">+ 배너 등록</a>
  </div>

  <!-- 검색/필터 -->
  <form class="adm-search-bar" action="<%= baseUrl %>" method="get">
    <select name="mediaId" class="adm-search-select">
      <option value="0">전체 매체</option>
      <% if (mediaList != null) { for (AdMediaVO m : mediaList) { %>
      <option value="<%= m.getMediaId() %>" <%= m.getMediaId() == selMediaId ? "selected" : "" %>><%= m.getMediaName() %></option>
      <% } } %>
    </select>
    <select name="platformId" class="adm-search-select">
      <option value="0">전체 플랫폼</option>
      <% if (platformList != null) { for (AdPlatformVO p : platformList) { %>
      <option value="<%= p.getPlatformId() %>" <%= p.getPlatformId() == selPlatformId ? "selected" : "" %>><%= p.getPlatformName() %></option>
      <% } } %>
    </select>
    <select name="status" class="adm-search-select">
      <option value="">전체 상태</option>
      <option value="ACTIVE" <%= "ACTIVE".equals(selStatus) ? "selected" : "" %>>활성</option>
      <option value="INACTIVE" <%= "INACTIVE".equals(selStatus) ? "selected" : "" %>>비활성</option>
      <option value="SCHEDULED" <%= "SCHEDULED".equals(selStatus) ? "selected" : "" %>>예약</option>
    </select>
    <input type="text" name="searchKeyword" class="adm-search-input" placeholder="배너 제목 검색" value="<%= searchKeyword %>">
    <button type="submit" class="adm-search-btn">검색</button>
  </form>

  <!-- 테이블 -->
  <div class="adm-card">
    <div class="adm-card-header">
      <div class="adm-card-title">배너 목록 · 총 <%= totalCount %>건</div>
    </div>
    <table class="adm-table">
      <thead>
        <tr>
          <th style="width:50px">번호</th>
          <th style="width:120px">매체</th>
          <th style="width:140px">플랫폼</th>
          <th style="width:190px">노출위치</th>
          <th>제목</th>
          <th style="width:75px">상태</th>
          <th style="width:75px">가중치</th>
          <th style="width:55px">정렬</th>
          <th style="width:220px">노출기간</th>
          <th style="width:160px">등록일</th>
          <th style="width:130px">관리</th>
        </tr>
      </thead>
      <tbody>
        <% if (bannerList != null && !bannerList.isEmpty()) {
             for (AdBannerVO b : bannerList) { %>
        <tr>
          <td><%= b.getBannerId() %></td>
          <td><%= b.getMediaName() != null ? b.getMediaName() : "-" %></td>
          <td><%= b.getPlatformName() != null ? b.getPlatformName() : "-" %></td>
          <td><%= b.getPlacementName() != null ? b.getPlacementName() : "-" %></td>
          <td class="left">
            <a href="<%= ctx %>/admin/banner/view/<%= b.getBannerId() %>?page=<%= currentPage %>">
              <%= org.springframework.web.util.HtmlUtils.htmlEscape(b.getTitle()) %>
            </a>
          </td>
          <td>
            <span class="adm-badge <%= "ACTIVE".equals(b.getStatus()) ? "badge-active" : "SCHEDULED".equals(b.getStatus()) ? "badge-scheduled" : "badge-inactive" %>"
                  style="cursor:pointer" onclick="toggleStatus(<%= b.getBannerId() %>)">
              <%= "ACTIVE".equals(b.getStatus()) ? "활성" : "SCHEDULED".equals(b.getStatus()) ? "예약" : "비활성" %>
            </span>
          </td>
          <td><%= b.getWeight() %></td>
          <td><%= b.getSortOrder() %></td>
          <td style="font-size:11px;white-space:nowrap;"><%
            String sd = b.getStartDate();
            String ed = b.getEndDate();
            if (sd != null && sd.length() >= 10) sd = sd.substring(0, 10);
            if (ed != null && ed.length() >= 10) ed = ed.substring(0, 10);
            if (sd != null) { %><%= sd %><% if (ed != null) { %> ~ <%= ed %><% } } else { %>-<% } %>
          </td>
          <td style="font-size:11px;white-space:nowrap;"><%= b.getCreatedAt() %></td>
          <td>
            <a href="<%= ctx %>/admin/banner/edit/<%= b.getBannerId() %>" class="adm-btn-sm">수정</a>
            <button class="adm-btn-sm danger" onclick="deleteBanner(<%= b.getBannerId() %>)">삭제</button>
          </td>
        </tr>
        <% } } else { %>
        <tr><td colspan="11" style="padding:40px;color:var(--adm-txt3);">등록된 배너가 없습니다.</td></tr>
        <% } %>
      </tbody>
    </table>

    <!-- 페이징 -->
    <nav class="adm-pagination">
      <% if (currentPage <= 1) { %>
        <span class="adm-pg-btn disabled">&lsaquo;</span>
      <% } else { %>
        <a href="<%= baseUrl %>?<%= params %>&page=<%= currentPage - 1 %>" class="adm-pg-btn">&lsaquo;</a>
      <% } %>
      <% if (startPage > 1) { %>
        <a href="<%= baseUrl %>?<%= params %>&page=1" class="adm-pg-btn">1</a>
        <% if (startPage > 2) { %><span class="adm-pg-ellipsis">&middot;&middot;&middot;</span><% } %>
      <% } %>
      <% for (int i = startPage; i <= endPage; i++) { %>
        <% if (i == currentPage) { %>
          <span class="adm-pg-btn active"><%= i %></span>
        <% } else { %>
          <a href="<%= baseUrl %>?<%= params %>&page=<%= i %>" class="adm-pg-btn"><%= i %></a>
        <% } %>
      <% } %>
      <% if (endPage < totalPages) { %>
        <% if (endPage < totalPages - 1) { %><span class="adm-pg-ellipsis">&middot;&middot;&middot;</span><% } %>
        <a href="<%= baseUrl %>?<%= params %>&page=<%= totalPages %>" class="adm-pg-btn"><%= totalPages %></a>
      <% } %>
      <% if (currentPage >= totalPages) { %>
        <span class="adm-pg-btn disabled">&rsaquo;</span>
      <% } else { %>
        <a href="<%= baseUrl %>?<%= params %>&page=<%= currentPage + 1 %>" class="adm-pg-btn">&rsaquo;</a>
      <% } %>
    </nav>
  </div>
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
    if (d.success) location.reload();
  });
}
function toggleStatus(bannerId) {
  fetch(ctx + '/admin/banner/toggle-status', {
    method:'POST',
    headers:{'Content-Type':'application/x-www-form-urlencoded'},
    body:'bannerId=' + bannerId
  }).then(function(r){return r.json()}).then(function(d){
    if (d.success) location.reload();
  });
}
</script>
</body>
</html>
