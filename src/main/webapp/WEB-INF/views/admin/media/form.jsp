<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wontherads.vo.AdMediaVO" %>
<%@ page import="com.wontherads.vo.AdPlatformVO" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/views/admin/layout/head.jsp" %>
<body class="admin-body">
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<%
  AdMediaVO media = (AdMediaVO) request.getAttribute("media");
  boolean isEdit = (media != null);

  @SuppressWarnings("unchecked")
  List<AdPlatformVO> platformList = (List<AdPlatformVO>) request.getAttribute("platformList");
  @SuppressWarnings("unchecked")
  List<Long> mappedPlatformIds = (List<Long>) request.getAttribute("mappedPlatformIds");

  String actionUrl = isEdit ? ctx + "/admin/media/edit/" + media.getMediaId() : ctx + "/admin/media/write";
%>

<div class="adm-content">
  <h1 class="adm-page-title"><%= isEdit ? "매체 수정" : "매체 등록" %></h1>

  <div class="adm-card" style="max-width:600px;">
    <form method="post" action="<%= actionUrl %>">
      <div class="adm-form-group">
        <label class="adm-form-label">매체명 <span class="required">*</span></label>
        <input type="text" name="mediaName" class="adm-form-input" maxlength="100" required
               value="<%= isEdit ? org.springframework.web.util.HtmlUtils.htmlEscape(media.getMediaName()) : "" %>"
               placeholder="예: 사이트A">
      </div>
      <div class="adm-form-group">
        <label class="adm-form-label">매체 URL</label>
        <input type="url" name="mediaUrl" class="adm-form-input" maxlength="500"
               value="<%= isEdit && media.getMediaUrl() != null ? org.springframework.web.util.HtmlUtils.htmlEscape(media.getMediaUrl()) : "" %>"
               placeholder="https://example.com">
      </div>
      <div class="adm-form-group">
        <label class="adm-form-label">설명</label>
        <input type="text" name="description" class="adm-form-input" maxlength="500"
               value="<%= isEdit && media.getDescription() != null ? org.springframework.web.util.HtmlUtils.htmlEscape(media.getDescription()) : "" %>">
      </div>
      <div class="adm-form-group">
        <label class="adm-form-label">사용 여부</label>
        <select name="useYn" class="adm-form-input">
          <option value="Y" <%= !isEdit || "Y".equals(media.getUseYn()) ? "selected" : "" %>>사용</option>
          <option value="N" <%= isEdit && "N".equals(media.getUseYn()) ? "selected" : "" %>>미사용</option>
        </select>
      </div>

      <!-- 지원 플랫폼 매핑 -->
      <div class="adm-form-group">
        <label class="adm-form-label">지원 플랫폼</label>
        <div style="display:flex;flex-direction:column;gap:8px;">
          <% if (platformList != null) { for (AdPlatformVO p : platformList) {
               boolean checked = (mappedPlatformIds != null && mappedPlatformIds.contains(p.getPlatformId()));
          %>
          <label style="display:flex;align-items:center;gap:8px;font-size:13px;">
            <input type="checkbox" name="platformIds" value="<%= p.getPlatformId() %>" <%= checked ? "checked" : "" %>>
            <%= p.getPlatformName() %> (<%= p.getPlatformCode() %>)
          </label>
          <% } } %>
        </div>
      </div>

      <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:24px;">
        <a href="<%= ctx %>/admin/media" class="adm-btn-sm" style="padding:8px 20px;">취소</a>
        <button type="submit" class="adm-btn-sm" style="padding:8px 20px;background:var(--adm-primary);color:#fff;border:none;"><%= isEdit ? "수정" : "등록" %></button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
