/**
 댓글 수정을 위한 JS
 */
 
 // 댓글 수정 폼을 토글하는 함수
 function toggleEditForm(commentIdx) {
     console.log('Toggle edit form for comment:', commentIdx);
     
     // 해당 commentIdx에 맞는 폼 요소를 찾아 변수에 담음
     const form = document.getElementById(`editForm-${commentIdx}`);
     const contentDiv = document.getElementById(`content-${commentIdx}`);
     const editBtn = document.getElementById(`editBtn-${commentIdx}`);
     const actionsDiv = document.getElementById(`actions-${commentIdx}`); // 새로 추가된 부분
     
     // 폼 요소가 제대로 찾아졌는지 확인합니다.
     if (form && contentDiv && editBtn && actionsDiv) {
         if (form.style.display === "none" || form.style.display === "") {
             // 수정 모드로 전환
             form.style.display = "block";
             contentDiv.style.display = "none";
             
             // 수정/삭제 버튼을 포함하는 div 숨기기
             actionsDiv.style.display = "none"; 
         } else {
             // 일반 모드로 전환
             form.style.display = "none";
             contentDiv.style.display = "block";
             
             // 수정/삭제 버튼을 포함하는 div 다시 보이기
             actionsDiv.style.display = "flex"; // flexbox 사용 시 flex로, block 사용 시 block으로
         }
     } else {
         console.error(`Error: Elements not found for commentIdx: ${commentIdx}`);
         console.error('Form:', form);
         console.error('Content div:', contentDiv);
         console.error('Edit button:', editBtn);
         console.error('Actions div:', actionsDiv); // 에러 메시지 추가
     }
 }

 // 수정 폼 제출 전 검증
 function validateEditForm(commentIdx) {
     const form = document.getElementById(`editForm-${commentIdx}`);
     const textarea = form.querySelector('textarea[name="content"]');
     
     if (!textarea.value.trim()) {
         alert('댓글 내용을 입력해주세요.');
         textarea.focus();
         return false;
     }
     
     return confirm('댓글을 수정하시겠습니까?');
 }

 // 댓글 삭제 확인
 function confirmDeleteWithLink(url) {
     if (confirm("정말로 삭제하시겠습니까?")) {
         window.location.href = url;
         return true;
     }
     return false;
 }

 // 댓글 작성 폼 검증
 function validateCommentForm() {
     const textarea = document.querySelector('form[action="galleryBoardCommentWriteProc.do"] textarea[name="content"]');
     
     if (!textarea.value.trim()) {
         alert('댓글 내용을 입력해주세요.');
         textarea.focus();
         return false;
     }
     
     return true;
 }

 // 페이지 로드 시 초기화
 document.addEventListener('DOMContentLoaded', function() {
     console.log('Page loaded, initializing comment system');
     
     // 모든 수정 폼을 숨김 상태로 초기화
     const editForms = document.querySelectorAll('[id^="editForm-"]');
     editForms.forEach(form => {
         form.style.display = 'none';
     });
 });
 
 
 /**
  좋아요 비동기 방식을 위한 JS
  */
 /* 'DOMContentLoaded'
 	-> HTML 문서가 완전히 로드되고 DOM 트리가 완성된 후 스크립트를 실행 */
  document.addEventListener('DOMContentLoaded', function() {
      const likeButton = document.getElementById('board-like-btn');
      const likesCountSpan = document.getElementById('likes-count');
      const heartIcon = document.getElementById('heart-icon');

      if (likeButton) {
          likeButton.addEventListener('click', function() {
              const boardIdx = this.getAttribute('data-board-idx');

			  // Fetch API를 사용해 서버에 POST 요청
			  fetch('/boards/gallery/toggleLike2.do', {
			      method: 'POST',
			      headers: {
			          'Content-Type': 'application/x-www-form-urlencoded' // 폼 데이터 형식
			      },
			      body: `boardIdx=${boardIdx}`  // 문자열로 key=value 전달
			  })
			  // 서버 응답을 JSON 형식으로 변환
			  .then(response => {
			                  console.log('서버 응답 상태:', response.status);
			                  return response.json();
			              })
			  .then(data => {
				console.log('서버 응답 데이터:', data);
			      if (data.success) {
			          likesCountSpan.textContent = data.likesCount;
					  if(data.isLiked) {
                          heartIcon.textContent = '🧡';
						  console.log('좋아요 추가됨 - 개수:', data.likesCount);
                      } else {
                          heartIcon.textContent = '🤍';
						  console.log('좋아요 취소됨 - 개수:', data.likesCount);
                      }
			      } else {
					console.error('서버 에러:', data.message);
			          alert(data.message);
			      }
			  })
              .catch(error => {
                  console.error('Error:', error);
                  alert('좋아요 요청에 실패했습니다.');
              });
          });
      }
  });

  /**
   * 신고 버튼을 누르면 나오는 모달창
   */
  
  /*
  <button type="button" id="board-report-btn" data-board-idx="${board.boardIdx}">
      <span id="report-icon">
          <c:choose>
              <c:when test="${isLiked}"> 🚨 신고</c:when>
              <c:otherwise> 신고완료 </c:otherwise>
          </c:choose>
      </span>
  </button>
  */

  // 모달 관련 요소들
     const reportBtn = document.getElementById('board-report-btn');
     const reportModal = document.getElementById('reportModal');
     const cancelBtn = document.getElementById('cancelBtn');
     const reportForm = document.getElementById('reportForm');
     const submitBtn = document.getElementById('submitBtn');
     const reportContent = document.getElementById('reportContent');
     const boardIdxInput = document.getElementById('boardIdx');

     // 모달 열기
     function openModal() {
         const boardIdx = reportBtn.getAttribute('data-board-idx');
         boardIdxInput.value = boardIdx;
         reportModal.style.display = 'block';
     }

     // 모달 닫기
     function closeModal() {
         reportModal.style.display = 'none';
         reportForm.reset(); // 폼 초기화
     }

     // 신고 제출
     function submitReport(event) {
         event.preventDefault();
         
         const content = reportContent.value.trim();
         const boardIdx = boardIdxInput.value;

         // 빈 내용 체크
         if (!content) {
             alert('신고 사유를 입력해주세요.');
             return;
         }

         // 확인 메시지
         if (confirm('정말로 이 게시글을 신고하시겠습니까?')) {
             alert('신고가 접수되었습니다.');
             closeModal();
             
             // 신고 버튼 상태 변경
             document.getElementById('report-icon').textContent = '신고완료';
             reportBtn.disabled = true;
         }
     }

     // 이벤트 리스너 등록
     reportBtn.addEventListener('click', openModal);
     cancelBtn.addEventListener('click', closeModal);
     reportForm.addEventListener('submit', submitReport);

     // 모달 외부 클릭 시 닫기
     reportModal.addEventListener('click', function(event) {
         if (event.target === reportModal) {
             closeModal();
         }
     });
  
  
  
  
  
  
  
  
  
  
  