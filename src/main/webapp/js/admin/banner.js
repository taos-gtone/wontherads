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

/* ═══════ 미디어 미리보기 (이미지 + 동영상) ═══════ */

function previewMedia(input) {
  var preview = document.getElementById('imagePreview');
  if (!input.files || !input.files[0]) {
    preview.innerHTML = '';
    return;
  }

  var file = input.files[0];
  var ext = file.name.split('.').pop().toLowerCase();
  var isVideo = (ext === 'mp4');
  var isImage = ['jpg','jpeg','png','gif','webp'].includes(ext);

  // 확장자 검증
  if (!isImage && !isVideo) {
    alert('허용되지 않은 파일 형식입니다. (jpg, png, gif, webp, mp4만 가능)');
    input.value = '';
    preview.innerHTML = '';
    return;
  }

  // 파일 크기 검증
  var maxSize = isVideo ? 50 * 1024 * 1024 : 5 * 1024 * 1024;
  var sizeLabel = isVideo ? '50MB' : '5MB';
  if (file.size > maxSize) {
    alert('파일 크기가 ' + sizeLabel + '를 초과합니다.');
    input.value = '';
    preview.innerHTML = '';
    return;
  }

  if (isVideo) {
    var videoUrl = URL.createObjectURL(file);
    preview.innerHTML = '<video src="' + videoUrl + '" style="max-width:400px;max-height:200px;border:1px solid #ddd;border-radius:8px;" controls muted></video>';
  } else {
    var reader = new FileReader();
    reader.onload = function(e) {
      preview.innerHTML = '<img src="' + e.target.result + '" style="max-width:400px;max-height:200px;border:1px solid #ddd;border-radius:8px;">';
    };
    reader.readAsDataURL(file);
  }
}

/* 하위 호환: 기존 previewImage 호출 대비 */
function previewImage(input) { previewMedia(input); }

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
