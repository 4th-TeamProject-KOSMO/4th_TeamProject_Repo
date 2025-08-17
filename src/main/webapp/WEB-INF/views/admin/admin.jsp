<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>관리자 페이지</title>
  <link rel="stylesheet" href="/css/admin.css" />
</head>
<body>
<div class="admin-wrapper">
  <!-- 사이드바 -->
  <div class="admin-sidebar">
    <ul>
      <li class="admin-tab-btn active" data-tab="member">회원관리</li>
      <li class="admin-tab-btn" data-tab="report">신고된 게시물</li>
      <!-- QnA 관리 탭 추가 -->
      <li class="admin-tab-btn" data-tab="qna">QnA 관리</li>
      <li class="admin-tab-btn" data-tab="dict">식물도감</li>
    </ul>
  </div>
   <button class="admin-home-btn" type="button" onclick="location.href='/main/member.do'" >
   		홈페이지
   </button>

  <!-- 본문 컨텐츠 -->
  <div class="admin-content">
	<h1 class="admin-title">관리자 페이지</h1>

    <!-- 회원관리 탭 -->
    <div class="admin-tab-content" id="member-tab">
    <div class="admin-header">
	           
    </div>
      <h2 class="admin-subtitle">회원 목록</h2>

      <form action="/admin/index.do" method="get" class="admin-search-form">
        <label for="searchUserId">아이디 검색:</label>
        <input type="text" name="searchUserId" id="searchUserId" class="admin-search-input" value="${param.searchUserId}">
        <input type="submit" value="검색" class="admin-search-btn">
      </form>

      <table class="admin-table">
        <tr>
          <th>아이디</th>
          <th>활동명</th>
          <th>전화번호</th>
          <th>이메일</th>
          <th>권한</th>
          <th>활성여부</th>
        </tr>
        <c:forEach var="m" items="${members}">
          <tr>
            <td>${m.userid}</td>
            <td>${m.username}</td>
            <td>${m.phonenumber}</td>
            <td>${m.email}</td>
            <td>
              <form action="${pageContext.request.contextPath}/admin/changeAuthority.do" method="post" style="display:inline;">
                <input type="hidden" name="userid" value="${m.userid}">
                <select name="authority">
                  <option value="ROLE_USER" ${m.authority == 'ROLE_USER' ? 'selected' : ''}>USER</option>
                  <option value="ROLE_ADMIN" ${m.authority == 'ROLE_ADMIN' ? 'selected' : ''}>ADMIN</option>
                </select>
                <input type="submit" value="변경" class="admin-btn">
              </form>
            </td>
            <td>
              <c:choose>
                <c:when test="${m.enabled == 1}">
                  <form action="${pageContext.request.contextPath}/admin/disableMember.do" method="post" onsubmit="return confirm('정말 비활성화 하시겠습니까?');" style="display:inline;">
                    <input type="hidden" name="userid" value="${m.userid}">
                    <input type="submit" value="비활성화" class="admin-btn">
                  </form>
                </c:when>
                <c:otherwise>
                  <form action="${pageContext.request.contextPath}/admin/enableMember.do" method="post" onsubmit="return confirm('이 회원을 다시 활성화 하시겠습니까?');" style="display:inline;">
                    <input type="hidden" name="userid" value="${m.userid}">
                    <input type="submit" value="활성화" class="admin-btn">
                  </form>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </table>
    </div>

    <!-- 신고 게시물 탭 -->
    <div class="admin-tab-content" id="report-tab" style="display:none;">
      <h1 class="admin-title">관리자 페이지</h1>
      <h2 class="admin-subtitle">🚨 신고된 게시글 목록</h2>
      <c:if test="${empty reportedPosts}">
        <p>신고된 게시글이 없습니다.</p>
      </c:if>
      <c:if test="${not empty reportedPosts}">
        <table class="admin-table">
          <tr>
            <th>게시글 ID</th>
            <th>작성자</th>
            <th>제목</th>
            <th>신고 사유</th>
            <th>신고 수</th>
            <th>바로가기</th>
            <th>작성자 비활성화</th>
          </tr>
          <c:forEach var="post" items="${reportedPosts}">
            <tr>
              <td>${post.boardIdx}</td>
              <td>${post.userId}</td>
              <td>${post.title}</td>
              <td>${post.content}</td>
              <td>${post.reportCount}</td>
              <td><a href="/boards/free/freeBoardView.do?boardIdx=${post.boardIdx}" target="_blank">보기</a></td>
              <td>
                <form action="${pageContext.request.contextPath}/admin/disableMember.do" method="post" onsubmit="return confirm('해당 작성자를 비활성화 하시겠습니까?');">
                  <input type="hidden" name="userid" value="${post.userId}" />
                  <input type="submit" value="작성자 비활성화" class="admin-btn">
                </form>
              </td>
            </tr>
          </c:forEach>
        </table>
      </c:if>
    </div>
      <!-- -----------------------동수 작업------------------------------------ -->
    <!-- QnA 관리 탭 -->
    <div class="admin-tab-content" id="qna-tab" style="display:none;">
      <h2 class="admin-subtitle">QnA 관리</h2>
      <c:if test="${empty totalPages}">
        <p>답변 대기중인 게시물이 없습니다.</p>
      </c:if>
      <c:if test="${not empty totalPages}">
        <table class="qna-list-table">
			<tr>
				<th>No</th>
				<th>카테고리</th>
				<th>제목</th>
				<th>글쓴이</th>
				<th>작성일</th>
				<th>조회수</th>
				<th>답변상태</th>
			</tr>
	    
		<!-- 공지글 -->
		<c:forEach items="${noticeRows}" var="nrow" varStatus="">
		    <tr class="notice-row">
				<td>📌</td>
				<td>${ nrow.category }</td>
				<td style="text-align:left; width:40%">
		            <a href="/qnaBoardView.do?idx=${nrow.idx}">
		                ${ nrow.title }
		            </a>
		        </td>
		        <td>${ nrow.writer }</td>
		        <td>${ nrow.formattedPostdate}</td>
		        <td>${ nrow.views}</td>
		        <td>${ nrow.answerstatus }</td>
		    </tr>
		</c:forEach>
	
		<!-- 일반 Q&A -->
		<c:set var="total" value="${qnaRows.totalElements}" />
		<c:set var="offset" value="${qnaRows.number * qnaRows.size}" />
		
		<c:forEach items="${qnaRows.content}" var="qrow" varStatus="var">
			<tr>
				<td>${ total - offset - var.index }</td>
				<td>${ qrow.category }</td>
				<td style="text-align:left; width:40%">
		            <a href="/qnaBoardView.do?idx=${qrow.idx}">
		                <c:if test="${ qrow.secretflag == 'Y' }"> (비밀글) </c:if>
		                ${ qrow.title }
		            </a>
		        </td>
				<td>${ qrow.writer }</td>
				<td>${ qrow.formattedPostdate}</td>
				<td>${ qrow.views}</td>
				<td>${ qrow.answerstatus }</td>
			</tr>
		</c:forEach>
		</table>
		
		<!-- 페이징 -->
		<div class="pagination">
			<c:forEach var="p" begin="1" end="${totalPages}">
				<a href="?page=${p}" class="${p == (empty param.page ? 1 : param.page) ? 'active' : ''}">${p}</a>
			</c:forEach>
		</div>
      </c:if>
    </div>
    
    <!-- -----------------------동수 작업------------------------------------ -->

    <!-- 식물도감 탭 -->
    <div class="admin-tab-content" id="dict-tab" style="display:none;">
      <h1 class="admin-title">관리자 페이지</h1>
      <h2 class="admin-subtitle">🌱 식물도감</h2>

      <!-- 등록 버튼 -->
      <button type="button" id="show-dict-form" class="admin-btn">등록하기</button>

      <!-- 식물도감 리스트 -->
      <div id="dict-list" style="margin-top:20px;">
        <table class="admin-table">
          <tr>
            <th>번호</th>
            <th>식물명</th>
            <th>영문명</th>
            <th>카테고리</th>
            <th>이미지</th>
            <th>삭제</th>
          </tr>
          <c:forEach var="p" items="${plantList}">
            <tr>
              <td>${p.plantidx}</td>
              <td>${p.name}</td>
              <td>${p.engname}</td>
              <td>${p.category}</td>
              <td><img src="/images/dict/${p.imgpath}" alt="식물사진" style="max-width:100px;"></td>
              <td>
                <form action="/admin/deletePlantDict.do" method="post"
                      onsubmit="return confirm('정말 삭제할까요?');">
                    <input type="hidden" name="plantidx" value="${p.plantidx}" />
                    <button type="submit">삭제</button>
                </form>
            </td>
            </tr>
          </c:forEach>
        </table>
      </div>

      <!-- 등록 폼 (처음엔 숨김) -->
	  <div id="dict-form" style="display:none; margin-top:20px;">
		  <form id="dictForm"
		        action="${pageContext.request.contextPath}/admin/dict/insert.do"
		        method="post" enctype="multipart/form-data" class="admin-form"
		         onsubmit="window.location.reload();">
		
		    <input type="text" name="name" placeholder="식물 이름" required>
		    <input type="text" name="engname" placeholder="영문 이름">
		    <input type="text" name="category" placeholder="카테고리">
		    <textarea name="summary" placeholder="요약 설명"></textarea>
		    <textarea name="feature" placeholder="특징"></textarea>
		    <input type="text" name="growseason" placeholder="생육 시기 (예: 봄~가을)">
		    <input type="text" name="bloomingseason" placeholder="개화 시기 (예: 7~8월)">
		    <input type="text" name="sunlight" placeholder="햇빛 환경 (예: 반양지~양지)">
		    <input type="text" name="temperature" placeholder="재배 온도 (예: 18~25℃)">
		    <input type="text" name="humidity" placeholder="습도 (예: 50~60%)">
		    <input type="text" name="water" placeholder="물 주기 (예: 주 1회)">
		    <textarea name="disease" placeholder="병충해"></textarea>
		    <textarea name="summary" placeholder="요약 설명"></textarea>
		    <textarea name="note" placeholder="기타 메모"></textarea>
		
		    <input type="file" name="image" accept="image/*" required>
		
		    <input type="submit" value="등록" class="admin-btn" >
		  </form>
	  </div>

    </div>
  </div>
</div>

<!-- 탭 전환 JS -->
<script>
  document.querySelectorAll(".admin-tab-btn").forEach(btn => {
    btn.addEventListener("click", function() {
      document.querySelectorAll(".admin-tab-btn").forEach(b => b.classList.remove("active"));
      this.classList.add("active");
      
      const tab = this.dataset.tab;
      document.querySelectorAll(".admin-tab-content").forEach(div => {
        div.style.display = "none";
      });
      document.getElementById(tab + "-tab").style.display = "block";
    });
  });

  // 등록하기 버튼 클릭 시 폼만 보이게
  document.getElementById("show-dict-form").addEventListener("click", function(){
    document.getElementById("dict-list").style.display = "none";
    document.getElementById("dict-form").style.display = "block";
  });
  
  
</script>

</body>
</html>
