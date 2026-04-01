<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관리자 로그인 - WontherAds</title>
  <meta name="robots" content="noindex, nofollow">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
</head>
<body class="admin-body">
<%
  String errorMsg = (String) request.getAttribute("errorMsg");
%>

<div class="adm-login-wrap">
  <div class="adm-login-box">
    <div class="adm-login-logo">
      <div class="adm-login-logo-title">WontherAds</div>
      <div class="adm-login-logo-sub">Administrator Console</div>
    </div>

    <div class="adm-login-card">
      <div class="adm-login-card-title">관리자 로그인</div>

      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="adm-error-msg"><%= org.springframework.web.util.HtmlUtils.htmlEscape(errorMsg) %></div>
      <% } %>

      <form method="post" action="${pageContext.request.contextPath}/admin/login" onsubmit="return validateForm()">
        <div class="adm-form-group">
          <label class="adm-form-label" for="adminId">아이디</label>
          <input type="text" id="adminId" name="adminId" class="adm-form-input"
                 placeholder="관리자 아이디 입력" autocomplete="username" autofocus required>
        </div>
        <div class="adm-form-group">
          <label class="adm-form-label" for="adminPw">비밀번호</label>
          <input type="password" id="adminPw" name="adminPw" class="adm-form-input"
                 placeholder="비밀번호 입력" autocomplete="current-password" required>
        </div>
        <button type="submit" class="adm-btn-login">로그인</button>
      </form>
    </div>
  </div>
</div>

<script>
function validateForm() {
  var id = document.getElementById('adminId').value.trim();
  var pw = document.getElementById('adminPw').value.trim();
  if (!id) { alert('아이디를 입력하세요.'); document.getElementById('adminId').focus(); return false; }
  if (!pw) { alert('비밀번호를 입력하세요.'); document.getElementById('adminPw').focus(); return false; }
  return true;
}
</script>
</body>
</html>
