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
  AdPlacementVO placement = (AdPlacementVO) request.getAttribute("placement");
  boolean isEdit = (placement != null);

  @SuppressWarnings("unchecked")
  List<AdPlatformVO> platformList = (List<AdPlatformVO>) request.getAttribute("platformList");

  String actionUrl = isEdit ? ctx + "/admin/placement/edit/" + placement.getPlacementId() : ctx + "/admin/placement/write";
%>

<div class="adm-content">
  <h1 class="adm-page-title"><%= isEdit ? "광고위치 수정" : "광고위치 등록" %></h1>

  <div class="adm-card" style="max-width:600px;">
    <form method="post" action="<%= actionUrl %>">

      <div class="adm-form-group">
        <label class="adm-form-label">플랫폼 <span class="required">*</span></label>
        <select name="platformId" class="adm-form-input" required>
          <option value="">플랫폼을 선택하세요</option>
          <% if (platformList != null) { for (AdPlatformVO p : platformList) { %>
          <option value="<%= p.getPlatformId() %>" <%= isEdit && placement.getPlatformId() == p.getPlatformId() ? "selected" : "" %>><%= p.getPlatformName() %> (<%= p.getPlatformCode() %>)</option>
          <% } } %>
        </select>
      </div>
      <div class="adm-form-group">
        <label class="adm-form-label">위치 코드 <span class="required">*</span></label>
        <input type="text" name="placementCode" class="adm-form-input" maxlength="50" required
               value="<%= isEdit ? org.springframework.web.util.HtmlUtils.htmlEscape(placement.getPlacementCode()) : "" %>"
               placeholder="예: WEB_TOP, MOB_BOTTOM" style="text-transform:uppercase;">
      </div>
      <div class="adm-form-group">
        <label class="adm-form-label">위치명 <span class="required">*</span></label>
        <input type="text" name="placementName" class="adm-form-input" maxlength="100" required
               value="<%= isEdit ? org.springframework.web.util.HtmlUtils.htmlEscape(placement.getPlacementName()) : "" %>"
               placeholder="예: 웹 상단 배너">
      </div>
      <div class="adm-form-row">
        <div class="adm-form-group" style="flex:1">
          <label class="adm-form-label">권장 가로 (px)</label>
          <input type="number" name="width" class="adm-form-input" min="0"
                 value="<%= isEdit ? placement.getWidth() : 0 %>">
        </div>
        <div class="adm-form-group" style="flex:1">
          <label class="adm-form-label">권장 세로 (px)</label>
          <input type="number" name="height" class="adm-form-input" min="0"
                 value="<%= isEdit ? placement.getHeight() : 0 %>">
        </div>
      </div>
      <div class="adm-form-group">
        <label class="adm-form-label">설명</label>
        <input type="text" name="description" class="adm-form-input" maxlength="500"
               value="<%= isEdit && placement.getDescription() != null ? org.springframework.web.util.HtmlUtils.htmlEscape(placement.getDescription()) : "" %>">
      </div>
      <div class="adm-form-group">
        <label class="adm-form-label">사용 여부</label>
        <select name="useYn" class="adm-form-input">
          <option value="Y" <%= !isEdit || "Y".equals(placement.getUseYn()) ? "selected" : "" %>>사용</option>
          <option value="N" <%= isEdit && "N".equals(placement.getUseYn()) ? "selected" : "" %>>미사용</option>
        </select>
      </div>

      <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:24px;">
        <a href="<%= ctx %>/admin/placement" class="adm-btn-sm" style="padding:8px 20px;">취소</a>
        <button type="submit" class="adm-btn-sm" style="padding:8px 20px;background:var(--adm-primary);color:#fff;border:none;"><%= isEdit ? "수정" : "등록" %></button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
