<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wontherads.vo.AdPlatformVO" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/views/admin/layout/head.jsp" %>
<body class="admin-body">
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<%
  @SuppressWarnings("unchecked")
  List<AdPlatformVO> platformList = (List<AdPlatformVO>) request.getAttribute("platformList");
%>

<div class="adm-content">
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;">
    <h1 class="adm-page-title" style="margin-bottom:0;">플랫폼 관리</h1>
    <a href="<%= ctx %>/admin/platform/write" class="adm-btn-sm" style="padding:6px 16px;font-size:13px;background:var(--adm-primary);color:#fff;border:none;">+ 플랫폼 등록</a>
  </div>

  <div class="adm-card">
    <table class="adm-table">
      <thead>
        <tr>
          <th style="width:60px">ID</th>
          <th style="width:140px">플랫폼 코드</th>
          <th>플랫폼명</th>
          <th style="width:70px">사용</th>
          <th style="width:160px">등록일</th>
          <th style="width:130px">관리</th>
        </tr>
      </thead>
      <tbody>
        <% if (platformList != null && !platformList.isEmpty()) {
             for (AdPlatformVO p : platformList) { %>
        <tr>
          <td><%= p.getPlatformId() %></td>
          <td><code><%= org.springframework.web.util.HtmlUtils.htmlEscape(p.getPlatformCode()) %></code></td>
          <td class="left"><%= org.springframework.web.util.HtmlUtils.htmlEscape(p.getPlatformName()) %></td>
          <td><span class="adm-badge <%= "Y".equals(p.getUseYn()) ? "badge-active" : "badge-inactive" %>"><%= "Y".equals(p.getUseYn()) ? "사용" : "미사용" %></span></td>
          <td style="font-size:12px;"><%= p.getCreatedAt() %></td>
          <td>
            <a href="<%= ctx %>/admin/platform/edit/<%= p.getPlatformId() %>" class="adm-btn-sm">수정</a>
            <button class="adm-btn-sm danger" onclick="deleteItem(<%= p.getPlatformId() %>)">삭제</button>
          </td>
        </tr>
        <% } } else { %>
        <tr><td colspan="6" style="padding:40px;color:var(--adm-txt3);">등록된 플랫폼이 없습니다.</td></tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>

<script>
var ctx = '<%= ctx %>';
function deleteItem(id) {
  if (!confirm('삭제하면 연결된 노출위치 데이터에 영향을 줄 수 있습니다.\n정말 삭제하시겠습니까?')) return;
  fetch(ctx + '/admin/platform/delete', {
    method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'},
    body:'platformId=' + id
  }).then(function(r){return r.json()}).then(function(d){ if(d.success) location.reload(); });
}
</script>
</body>
</html>
