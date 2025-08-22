<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/common/layout.css" />
<link rel="stylesheet" href="/css/hurt.css" />
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Main Content -->
<div class="main-content">
  <h1 class="main-title">식물 병명 진단 🚑</h1>

  <div class="fruit-buttons">
    <button class="fruit-btn tangerine-btn" data-fruit="귤">귤 🍊</button>
    <button class="fruit-btn strawberry-btn" data-fruit="딸기">딸기 🍓</button>
    <button class="fruit-btn lemon-btn" data-fruit="레몬">레몬 🍋</button>
    <button class="fruit-btn melon-btn" data-fruit="참외">참외 🍈</button>
  </div>

  <div class="detector-layout">
    <div class="box">
      <h2>이미지 업로드</h2>
      <!-- 변경된 부분 -->
      <label class="upload-area">
        <div class="upload-icon"></div>
        <span>여기에 파일을 드래그하거나 클릭하세요</span>
        <input type="file" accept="image/*" id="upload" />
      </label>
      <img id="preview" class="preview" alt="업로드된 이미지 미리보기" />
      <div id="result" class="result"></div>
    </div>  
    <div class="box">
      <h2>진단 결과</h2>
      <p id="diagnosis-message" class="result-text">과일을 선택하고 이미지를 업로드하세요.</p>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
<script>
const fruitButtons = document.querySelectorAll('.fruit-btn');
const uploadInput = document.getElementById('upload');
const previewImg = document.getElementById('preview');
const resultDiv = document.getElementById('result');
const diagnosisMessage = document.getElementById('diagnosis-message');

let selectedFruit = null;

fruitButtons.forEach(btn => {
  btn.addEventListener('click', () => {
    fruitButtons.forEach(b => b.classList.remove('selected'));
    btn.classList.add('selected');
    selectedFruit = btn.getAttribute('data-fruit');
    diagnosisMessage.textContent = selectedFruit+'을(를) 선택했습니다. 이미지를 업로드하세요.';
    previewImg.style.display = 'none';
    uploadInput.style.display = 'block';
    resultDiv.textContent = '';
    uploadInput.value = '';
  });
});

uploadInput.addEventListener('change', async e => {
  if (!selectedFruit) {
    alert('먼저 과일을 선택하세요!');
    uploadInput.value = '';
    return;
  }
  const file = e.target.files[0];
  if (!file) {
    previewImg.style.display = 'none';
    resultDiv.textContent = '';
    diagnosisMessage.textContent = '이미지를 업로드하면 결과가 여기에 표시됩니다.';
    return;
  }

  const reader = new FileReader();
  reader.onload = () => {
  previewImg.src = reader.result;
  previewImg.style.display = 'block';
  // uploadInput 말고 upload-area를 숨긴다
  document.querySelector('.upload-area').style.display = 'none';
};
  reader.readAsDataURL(file);

  const formData = new FormData();
  formData.append('fruit', selectedFruit);
  formData.append('image', file);

  diagnosisMessage.textContent = '🔍 분석 중입니다... 잠시만 기다려 주세요.';

  try {
    const response = await fetch('/predict', {
      method: 'POST',
      body: formData,
    });

    if (!response.ok) throw new Error('서버 에러');

    const data = await response.json();

    if (data.error) {
      diagnosisMessage.textContent = `⚠️ ${data.error}`;
      resultDiv.textContent = '';
    } else {
      diagnosisMessage.innerHTML = '✅ 병명: <span class="disease-name">'+data.disease+'</span>';
      resultDiv.innerHTML = '신뢰도: <strong>'+(data.confidence * 100).toFixed(2)+'%</strong>';
    }
  } catch (err) {
    diagnosisMessage.textContent = '❌ 예측 중 오류가 발생했습니다.';
    resultDiv.textContent = '';
    console.error(err);
  }
});
</script>