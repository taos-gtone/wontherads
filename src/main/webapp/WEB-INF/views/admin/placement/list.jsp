<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wontherads.vo.AdPlacementVO" %>
<%@ page import="com.wontherads.vo.AdPlatformVO" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/views/admin/layout/head.jsp" %>
<body class="admin-body">
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<%
  @SuppressWarnings("unchecked")
  List<AdPlacementVO> placementList = (List<AdPlacementVO>) request.getAttribute("placementList");
  @SuppressWarnings("unchecked")
  List<AdPlatformVO> platformList = (List<AdPlatformVO>) request.getAttribute("platformList");

  Long selPlatformIdObj = (Long) request.getAttribute("platformId");
  long selPlatformId = (selPlatformIdObj != null) ? selPlatformIdObj : 0;
%>

<div class="adm-content">
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;">
    <h1 class="adm-page-title" style="margin-bottom:0;">광고위치 관리</h1>
    <a href="<%= ctx %>/admin/placement/write" class="adm-btn-sm" style="padding:6px 16px;font-size:13px;background:var(--adm-primary);color:#fff;border:none;">+ 광고위치 등록</a>
  </div>

  <!-- 플랫폼 필터 -->
  <form class="adm-search-bar" action="<%= ctx %>/admin/placement" method="get">
    <select name="platformId" class="adm-search-select">
      <option value="0">전체 플랫폼</option>
      <% if (platformList != null) { for (AdPlatformVO p : platformList) { %>
      <option value="<%= p.getPlatformId() %>" <%= p.getPlatformId() == selPlatformId ? "selected" : "" %>><%= p.getPlatformName() %> (<%= p.getPlatformCode() %>)</option>
      <% } } %>
    </select>
    <button type="submit" class="adm-search-btn">검색</button>
  </form>

  <div class="adm-card">
    <table class="adm-table">
      <thead>
        <tr>
          <th style="width:50px">ID</th>
          <th style="width:160px">플랫폼</th>
          <th style="width:130px">위치 코드</th>
          <th>위치명</th>
          <th style="width:60px">가로</th>
          <th style="width:60px">세로</th>
          <th>설명</th>
          <th style="width:80px">사용</th>
          <th style="width:130px">관리</th>
        </tr>
      </thead>
      <tbody>
        <% if (placementList != null && !placementList.isEmpty()) {
             for (AdPlacementVO pl : placementList) { %>
        <tr>
          <td><%= pl.getPlacementId() %></td>
          <td><%= pl.getPlatformName() != null ? org.springframework.web.util.HtmlUtils.htmlEscape(pl.getPlatformName()) : "-" %></td>
          <td><code><%= org.springframework.web.util.HtmlUtils.htmlEscape(pl.getPlacementCode()) %></code></td>
          <td class="left"><%= org.springframework.web.util.HtmlUtils.htmlEscape(pl.getPlacementName()) %></td>
          <td><%= pl.getWidth() %>px</td>
          <td><%= pl.getHeight() %>px</td>
          <td class="left" style="font-size:12px;"><%= pl.getDescription() != null ? org.springframework.web.util.HtmlUtils.htmlEscape(pl.getDescription()) : "-" %></td>
          <td><span class="adm-badge <%= "Y".equals(pl.getUseYn()) ? "badge-active" : "badge-inactive" %>"><%= "Y".equals(pl.getUseYn()) ? "사용" : "미사용" %></span></td>
          <td>
            <a href="<%= ctx %>/admin/placement/edit/<%= pl.getPlacementId() %>" class="adm-btn-sm">수정</a>
            <button class="adm-btn-sm danger" onclick="deleteItem(<%= pl.getPlacementId() %>)">삭제</button>
          </td>
        </tr>
        <% } } else { %>
        <tr><td colspan="9" style="padding:40px;color:var(--adm-txt3);">등록된 광고위치가 없습니다.</td></tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>

<script>
var ctx = '<%= ctx %>';
function deleteItem(id) {
  if (!confirm('정말 삭제하시겠습니까?')) return;
  fetch(ctx + '/admin/placement/delete', {
    method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'},
    body:'placementId=' + id
  }).then(function(r){return r.json()}).then(function(d){ if(d.success) location.reload(); });
}
</script>
</body>
</html>
