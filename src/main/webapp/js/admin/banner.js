/* ═══════ Cascading Select: 매체 → 플랫폼 → 노출위치 ═══════ */

function loadPlatforms(mediaId) {
  var sel = document.getElementById('platformId');
  sel.innerHTML = '<option value="">플랫폼을 선택하세요</option>';
  document.getElementById('placementId').innerHTML = '<option value="">노출 위치를 선택하세요</option>';
  document.getElementById('placementSizeInfo').textContent = '';

  if (!mediaId) return;

  fetch(ctx + '/admin/banner/api/platforms?mediaId=' + mediaId)
    .then(function(r) { return r.json(); })
    .then(function(list) {
      list.forEach(function(p) {
        var opt = document.createElement('option');
        opt.value = p.platformId;
        opt.textContent = p.platformName;
        sel.appendChild(opt);
      });
    });
}

function loadPlacements(platformId) {
  var sel = document.getElementById('placementId');
  sel.innerHTML = '<option value="">노출 위치를 선택하세요</option>';
  document.getElementById('placementSizeInfo').textContent = '';

  if (!platformId) return;

  fetch(ctx + '/admin/banner/api/placements?platformId=' + platformId)
    .then(function(r) { return r.json(); })
    .then(function(list) {
      list.forEach(function(pl) {
        var opt = document.createElement('option');
        opt.value = pl.placementId;
        opt.textContent = pl.placementName + ' (' + pl.width + 'x' + pl.height + ')';
        opt.setAttribute('data-w', pl.width);
        opt.setAttribute('data-h', pl.height);
        sel.appendChild(opt);
      });
    });
}

function showPlacementSize() {
  var sel = document.getElementById('placementId');
  var info = document.getElementById('placementSizeInfo');
  if (!sel || !info) return;
  var opt = sel.options[sel.selectedIndex];
  if (opt && opt.value) {
    var w = opt.getAttribute('data-w');
    var h = opt.getAttribute('data-h');
    if (w && h) {
      info.textContent = '권장 사이즈: ' + w + ' x ' + h + ' px';
    } else {
      info.textContent = '';
    }
  } else {
    info.textContent = '';
  }
}

/* ═══════ 이미지 미리보기 ═══════ */

function previewImage(input) {
  var preview = document.getElementById('imagePreview');
  if (!input.files || !input.files[0]) {
    preview.innerHTML = '';
    return;
  }

  var file = input.files[0];

  // 파일 크기 검증 (5MB)
  if (file.size > 5 * 1024 * 1024) {
    alert('파일 크기가 5MB를 초과합니다.');
    input.value = '';
    preview.innerHTML = '';
    return;
  }

  // 확장자 검증
  var ext = file.name.split('.').pop().toLowerCase();
  if (!['jpg','jpeg','png','gif','webp'].includes(ext)) {
    alert('허용되지 않은 파일 형식입니다. (jpg, png, gif, webp만 가능)');
    input.value = '';
    preview.innerHTML = '';
    return;
  }

  var reader = new FileReader();
  reader.onload = function(e) {
    preview.innerHTML = '<img src="' + e.target.result + '" style="max-width:400px;max-height:200px;border:1px solid #ddd;border-radius:8px;">';
  };
  reader.readAsDataURL(file);
}

/* ═══════ 폼 검증 ═══════ */

function validateBannerForm() {
  var mediaId = document.getElementById('mediaId').value;
  var platformId = document.getElementById('platformId').value;
  var placementId = document.getElementById('placementId').value;

  if (!mediaId) { alert('매체를 선택하세요.'); return false; }
  if (!platformId) { alert('플랫폼을 선택하세요.'); return false; }
  if (!placementId) { alert('노출 위치를 선택하세요.'); return false; }

  var weight = document.querySelector('input[name="weight"]');
  if (weight) {
    var w = parseInt(weight.value);
    if (isNaN(w) || w < 1 || w > 100) {
      alert('가중치는 1~100 사이로 입력하세요.');
      weight.focus();
      return false;
    }
  }

  return true;
}
