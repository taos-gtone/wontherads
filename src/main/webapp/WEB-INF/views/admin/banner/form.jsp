<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wontherads.vo.AdBannerVO" %>
<%@ page import="com.wontherads.vo.AdMediaVO" %>
<%@ page import="com.wontherads.vo.AdPlatformVO" %>
<%@ page import="com.wontherads.vo.AdPlacementVO" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/views/admin/layout/head.jsp" %>
<body class="admin-body">
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<%
  AdBannerVO banner = (AdBannerVO) request.getAttribute("banner");
  boolean isEdit = (banner != null);

  @SuppressWarnings("unchecked")
  List<AdMediaVO> mediaList = (List<AdMediaVO>) request.getAttribute("mediaList");
  @SuppressWarnings("unchecked")
  List<AdPlatformVO> platformList = (List<AdPlatformVO>) request.getAttribute("platformList");
  @SuppressWarnings("unchecked")
  List<AdPlacementVO> placementList = (List<AdPlacementVO>) request.getAttribute("placementList");

  String actionUrl = isEdit
      ? ctx + "/admin/banner/edit/" + banner.getBannerId()
      : ctx + "/admin/banner/write";
%>

<div class="adm-content">
  <h1 class="adm-page-title"><%= isEdit ? "배너 수정" : "배너 등록" %></h1>

  <div class="adm-card" style="max-width:800px;">
    <form method="post" action="<%= actionUrl %>" enctype="multipart/form-data" onsubmit="return validateBannerForm()">

      <!-- 매체 선택 -->
      <div class="adm-form-group">
        <label class="adm-form-label">매체 선택 <span class="required">*</span></label>
        <select id="mediaId" name="mediaId" class="adm-form-input" required>
          <option value="">매체를 선택하세요</option>
          <% if (mediaList != null) { for (AdMediaVO m : mediaList) { %>
          <option value="<%= m.getMediaId() %>" <%= isEdit && banner.getMediaId() == m.getMediaId() ? "selected" : "" %>><%= m.getMediaName() %></option>
          <% } } %>
        </select>
      </div>

      <!-- 플랫폼 선택 (등록된 전체 플랫폼 표시) -->
      <div class="adm-form-group">
        <label class="adm-form-label">플랫폼 선택 <span class="required">*</span></label>
        <select id="platformId" name="platformId" class="adm-form-input" onchange="loadPlacements(this.value)" required>
          <option value="">플랫폼을 선택하세요</option>
          <% if (platformList != null) { for (AdPlatformVO p : platformList) { %>
          <option value="<%= p.getPlatformId() %>" <%= isEdit && banner.getPlatformId() == p.getPlatformId() ? "selected" : "" %>><%= p.getPlatformName() %> (<%= p.getPlatformCode() %>)</option>
          <% } } %>
        </select>
      </div>

      <!-- 노출위치 선택 -->
      <div class="adm-form-group">
        <label class="adm-form-label">노출 위치 <span class="required">*</span></label>
        <select id="placementId" name="placementId" class="adm-form-input" onchange="showPlacementSize()" required>
          <option value="">노출 위치를 선택하세요</option>
          <% if (placementList != null) { for (AdPlacementVO pl : placementList) { %>
          <option value="<%= pl.getPlacementId() %>" data-w="<%= pl.getWidth() %>" data-h="<%= pl.getHeight() %>"
                  <%= isEdit && banner.getPlacementId() == pl.getPlacementId() ? "selected" : "" %>><%= pl.getPlacementName() %> (<%= pl.getWidth() %>x<%= pl.getHeight() %>)</option>
          <% } } %>
        </select>
        <div id="placementSizeInfo" class="adm-help-text" style="margin-top:4px;"></div>
      </div>

      <hr style="margin:20px 0;border:none;border-top:1px solid #eee;">

      <!-- 배너 제목 -->
      <div class="adm-form-group">
        <label class="adm-form-label">배너 제목 <span class="required">*</span></label>
        <input type="text" name="title" class="adm-form-input" maxlength="200"
               value="<%= isEdit ? org.springframework.web.util.HtmlUtils.htmlEscape(banner.getTitle()) : "" %>"
               placeholder="관리용 배너 제목" required>
      </div>

      <!-- 클릭 URL -->
      <div class="adm-form-group">
        <label class="adm-form-label">클릭 URL</label>
        <input type="url" name="clickUrl" class="adm-form-input"
               value="<%= isEdit && banner.getClickUrl() != null ? org.springframework.web.util.HtmlUtils.htmlEscape(banner.getClickUrl()) : "" %>"
               placeholder="https://example.com">
      </div>

      <!-- 대체 텍스트 -->
      <div class="adm-form-group">
        <label class="adm-form-label">대체 텍스트</label>
        <input type="text" name="altText" class="adm-form-input" maxlength="200"
               value="<%= isEdit && banner.getAltText() != null ? org.springframework.web.util.HtmlUtils.htmlEscape(banner.getAltText()) : "" %>"
               placeholder="이미지 대체 텍스트 (접근성)">
      </div>

      <!-- 배너 이미지 -->
      <div class="adm-form-group">
        <label class="adm-form-label">배너 이미지 <% if (!isEdit) { %><span class="required">*</span><% } %></label>
        <input type="file" id="imageFile" name="<%= isEdit ? "newImageFile" : "imageFile" %>" class="adm-form-input"
               accept="image/jpeg,image/png,image/gif,image/webp" onchange="previewImage(this)"
               <%= !isEdit ? "required" : "" %>>
        <div class="adm-help-text">JPG, PNG, GIF, WEBP (최대 5MB)</div>
        <div id="imagePreview" style="margin-top:10px;">
          <% if (isEdit && banner.getImagePath() != null) { %>
          <img src="<%= ctx %>/upload<%= banner.getImagePath() %>" style="max-width:400px;max-height:200px;border:1px solid #ddd;border-radius:8px;">
          <% } %>
        </div>
      </div>

      <hr style="margin:20px 0;border:none;border-top:1px solid #eee;">

      <!-- 노출 상태 -->
      <div class="adm-form-group">
        <label class="adm-form-label">노출 상태</label>
        <div style="display:flex;gap:16px;">
          <label><input type="radio" name="status" value="INACTIVE" <%= !isEdit || "INACTIVE".equals(banner.getStatus()) ? "checked" : "" %>> 비활성</label>
          <label><input type="radio" name="status" value="ACTIVE" <%= isEdit && "ACTIVE".equals(banner.getStatus()) ? "checked" : "" %>> 활성</label>
          <label><input type="radio" name="status" value="SCHEDULED" <%= isEdit && "SCHEDULED".equals(banner.getStatus()) ? "checked" : "" %>> 예약</label>
        </div>
      </div>

      <!-- 가중치 -->
      <div class="adm-form-row">
        <div class="adm-form-group" style="flex:1">
          <label class="adm-form-label">노출 가중치 (1~100)</label>
          <input type="number" name="weight" class="adm-form-input" min="1" max="100"
                 value="<%= isEdit ? banner.getWeight() : 1 %>">
        </div>
        <div class="adm-form-group" style="flex:1">
          <label class="adm-form-label">정렬 순서</label>
          <input type="number" name="sortOrder" class="adm-form-input" min="0"
                 value="<%= isEdit ? banner.getSortOrder() : 0 %>">
        </div>
      </div>

      <!-- 노출 기간 -->
      <div class="adm-form-row">
        <div class="adm-form-group" style="flex:1">
          <label class="adm-form-label">시작일시</label>
          <input type="datetime-local" name="startDate" class="adm-form-input"
                 value="<%= isEdit && banner.getStartDate() != null ? banner.getStartDate() : "" %>">
        </div>
        <div class="adm-form-group" style="flex:1">
          <label class="adm-form-label">종료일시</label>
          <input type="datetime-local" name="endDate" class="adm-form-input"
                 value="<%= isEdit && banner.getEndDate() != null ? banner.getEndDate() : "" %>">
        </div>
      </div>

      <!-- 버튼 -->
      <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:24px;">
        <a href="<%= ctx %>/admin/banner" class="adm-btn-sm" style="padding:8px 20px;">취소</a>
        <button type="submit" class="adm-btn-sm" style="padding:8px 20px;background:var(--adm-primary);color:#fff;border:none;">
          <%= isEdit ? "수정" : "등록" %>
        </button>
      </div>
    </form>
  </div>
</div>

<script src="<%= ctx %>/js/admin/banner.js"></script>
<script>
var ctx = '<%= ctx %>';
<% if (!isEdit) { %>
// 등록 시 매체 선택되어 있으면 플랫폼 로드
document.addEventListener('DOMContentLoaded', function() {
  showPlacementSize();
});
<% } else { %>
// 수정 시 현재 선택된 placement 사이즈 표시
document.addEventListener('DOMContentLoaded', function() {
  showPlacementSize();
});
<% } %>
</script>
</body>
</html>
