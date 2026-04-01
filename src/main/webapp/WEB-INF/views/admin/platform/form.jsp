<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wontherads.vo.AdPlatformVO" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/views/admin/layout/head.jsp" %>
<body class="admin-body">
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<%
  AdPlatformVO platform = (AdPlatformVO) request.getAttribute("platform");
  boolean isEdit = (platform != null);
  String actionUrl = isEdit ? ctx + "/admin/platform/edit/" + platform.getPlatformId() : ctx + "/admin/platform/write";
%>

<div class="adm-content">
  <h1 class="adm-page-title"><%= isEdit ? "플랫폼 수정" : "플랫폼 등록" %></h1>

  <div class="adm-card" style="max-width:500px;">
    <form method="post" action="<%= actionUrl %>">
      <div class="adm-form-group">
        <label class="adm-form-label">플랫폼 코드 <span class="required">*</span></label>
        <input type="text" name="platformCode" class="adm-form-input" maxlength="20" required
               value="<%= isEdit ? org.springframework.web.util.HtmlUtils.htmlEscape(platform.getPlatformCode()) : "" %>"
               placeholder="예: WEB, WIN_APP, MOBILE_APP" style="text-transform:uppercase;">
      </div>
      <div class="adm-form-group">
        <label class="adm-form-label">플랫폼명 <span class="required">*</span></label>
        <input type="text" name="platformName" class="adm-form-input" maxlength="50" required
               value="<%= isEdit ? org.springframework.web.util.HtmlUtils.htmlEscape(platform.getPlatformName()) : "" %>"
               placeholder="예: 웹, 윈도우앱, 모바일앱">
      </div>
      <div class="adm-form-group">
        <label class="adm-form-label">사용 여부</label>
        <select name="useYn" class="adm-form-input">
          <option value="Y" <%= !isEdit || "Y".equals(platform.getUseYn()) ? "selected" : "" %>>사용</option>
          <option value="N" <%= isEdit && "N".equals(platform.getUseYn()) ? "selected" : "" %>>미사용</option>
        </select>
      </div>

      <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:24px;">
        <a href="<%= ctx %>/admin/platform" class="adm-btn-sm" style="padding:8px 20px;">취소</a>
        <button type="submit" class="adm-btn-sm" style="padding:8px 20px;background:var(--adm-primary);color:#fff;border:none;"><%= isEdit ? "수정" : "등록" %></button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
