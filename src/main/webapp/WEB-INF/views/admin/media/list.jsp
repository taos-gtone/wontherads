<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wontherads.vo.AdMediaVO" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/views/admin/layout/head.jsp" %>
<body class="admin-body">
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<%
  @SuppressWarnings("unchecked")
  List<AdMediaVO> mediaList = (List<AdMediaVO>) request.getAttribute("mediaList");
%>

<div class="adm-content">
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;">
    <h1 class="adm-page-title" style="margin-bottom:0;">매체 관리</h1>
    <a href="<%= ctx %>/admin/media/write" class="adm-btn-sm" style="padding:6px 16px;font-size:13px;background:var(--adm-primary);color:#fff;border:none;">+ 매체 등록</a>
  </div>

  <div class="adm-card">
    <table class="adm-table">
      <thead>
        <tr>
          <th style="width:60px">ID</th>
          <th>매체명</th>
          <th>URL</th>
          <th>설명</th>
          <th style="width:70px">사용</th>
          <th style="width:160px">등록일</th>
          <th style="width:130px">관리</th>
        </tr>
      </thead>
      <tbody>
        <% if (mediaList != null && !mediaList.isEmpty()) {
             for (AdMediaVO m : mediaList) { %>
        <tr>
          <td><%= m.getMediaId() %></td>
          <td class="left"><%= org.springframework.web.util.HtmlUtils.htmlEscape(m.getMediaName()) %></td>
          <td class="left" style="font-size:12px;">
            <% if (m.getMediaUrl() != null && !m.getMediaUrl().isEmpty()) { %>
              <a href="<%= m.getMediaUrl() %>" target="_blank"><%= org.springframework.web.util.HtmlUtils.htmlEscape(m.getMediaUrl()) %></a>
            <% } else { %>-<% } %>
          </td>
          <td class="left" style="font-size:12px;"><%= m.getDescription() != null ? org.springframework.web.util.HtmlUtils.htmlEscape(m.getDescription()) : "-" %></td>
          <td><span class="adm-badge <%= "Y".equals(m.getUseYn()) ? "badge-active" : "badge-inactive" %>"><%= "Y".equals(m.getUseYn()) ? "사용" : "미사용" %></span></td>
          <td style="font-size:12px;"><%= m.getCreatedAt() %></td>
          <td>
            <a href="<%= ctx %>/admin/media/edit/<%= m.getMediaId() %>" class="adm-btn-sm">수정</a>
            <button class="adm-btn-sm danger" onclick="deleteItem(<%= m.getMediaId() %>)">삭제</button>
          </td>
        </tr>
        <% } } else { %>
        <tr><td colspan="7" style="padding:40px;color:var(--adm-txt3);">등록된 매체가 없습니다.</td></tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>

<script>
var ctx = '<%= ctx %>';
function deleteItem(id) {
  if (!confirm('삭제하면 연결된 매체-플랫폼 매핑도 함께 삭제됩니다.\n정말 삭제하시겠습니까?')) return;
  fetch(ctx + '/admin/media/delete', {
    method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'},
    body:'mediaId=' + id
  }).then(function(r){return r.json()}).then(function(d){ if(d.success) location.reload(); });
}
</script>
</body>
</html>
