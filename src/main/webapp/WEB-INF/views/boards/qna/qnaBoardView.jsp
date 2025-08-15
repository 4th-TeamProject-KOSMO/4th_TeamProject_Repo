<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Q&A</title>
  <link rel="stylesheet" href="/css/common/layout.css" />
  <link rel="stylesheet" href="/css/qnaBoardView.css" />

</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

  <h1>Q&A</h1>
  <table class="qnaboard-table">
	<tr>
		<th>No</th>
		<th>카테고리</th>
		<th>제목</th>
		<th>글쓴이</th>
		<th>작성일</th>
		<th>답변상태</th>
	</tr>
    
<!-- 공지글 -->
<c:forEach items="${noticeRows}" var="nrow" varStatus="">
    <tr class="notice-row">
		<td>📌</td>
		<td>${ nrow.category }</td>
		<td style="text-align:left">${ nrow.title }</td>
        <td>${ nrow.writer }</td>
        <td>${ nrow.formattedPostdate}</td>
        <td>${ nrow.answerstatus }</td>
    </tr>
</c:forEach>

<!-- 일반 Q&A -->
<c:forEach items="${qnaRows}" var="qrow" varStatus="var">
    <tr>
    	<td>${ var.count + 1 }</td>
		<td>${ qrow.category }</td>
		<td style="text-align:left">
		  <c:if test="${ qrow.secretflag == 'Y' }">🔒 </c:if>
		  ${ qrow.title }
		</td>
		<td>${ qrow.writer }</td>
		<td>${ qrow.formattedPostdate}</td>
		<td>${ qrow.answerstatus }</td>
    </tr>
</c:forEach>
  </table>

  <div class="search-box">
    <form action="/qna/search.do" method="get">
    <input type="text" name="keyword" placeholder="Search" />
    <button type="submit">검색</button>
  </form>
  </div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
