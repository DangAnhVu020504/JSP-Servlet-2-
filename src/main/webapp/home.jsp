<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>Trang chủ</title>
<!-- Import Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
.btn-follow {
	padding: 4px 8px;
	margin-left: 10px;
	background-color: #1877f2;
	color: white;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 0.9em;
}

.btn-follow.following {
	background-color: #e4e6eb;
	color: #050505;
}

.btn-follow:hover {
	opacity: 0.9;
}

body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 20px;
	background-color: #f0f2f5;
}

.header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	padding: 10px 20px;
	background-color: white;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.user-info {
	display: flex;
	align-items: center;
	gap: 10px;
}

.container {
	max-width: 800px;
	margin: 0 auto;
}

.post-form {
	background-color: white;
	padding: 20px;
	border-radius: 8px;
	margin-bottom: 20px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.post-form textarea {
	width: 100%;
	padding: 10px;
	margin: 10px 0;
	border: 1px solid #ddd;
	border-radius: 4px;
	resize: vertical;
}

.post-list {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

.post-card {
	background-color: white;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.post-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 10px;
}

.post-author {
	font-weight: bold;
}

.post-date {
	color: #666;
	font-size: 0.9em;
}

.post-content {
	margin: 10px 0;
}

.btn {
	padding: 8px 16px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-weight: bold;
}

.btn-primary {
	background-color: #1877f2;
	color: white;
}

.btn-primary:hover {
	background-color: #166fe5;
}

.pagination {
	display: flex;
	justify-content: center;
	gap: 10px;
	margin-top: 20px;
}

.page-link {
	padding: 8px 12px;
	border: 1px solid #ddd;
	border-radius: 4px;
	color: #1877f2;
	text-decoration: none;
}

.page-link.active {
	background-color: #1877f2;
	color: white;
	border-color: #1877f2;
}

.post-form-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 15px;
}

.btn-close {
	background: none;
	border: none;
	font-size: 24px;
	cursor: pointer;
	color: #666;
}

.btn-close:hover {
	color: #333;
}

.form-actions {
	display: flex;
	gap: 10px;
	margin-top: 10px;
}

.form-control {
	width: 100%;
	padding: 10px;
	margin-bottom: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
}

/* CSS cho phần tìm kiếm */
.search-form {
	background-color: white;
	padding: 20px;
	border-radius: 8px;
	margin-bottom: 20px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.search-form .form-group {
	margin-bottom: 15px;
}

.search-form label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
}

.user-list {
	display: flex;
	flex-direction: column;
	gap: 15px;
	margin-bottom: 20px;
}

.user-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 15px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background-color: white;
}

.user-details h3 {
	margin: 0;
	font-size: 16px;
}

.not-found img {
	display: block;
	margin: 0 auto;
	max-width: 300px;
	height: auto;
}

.error-message {
	color: red;
	text-align: center;
	margin: 20px 0;
}
</style>

</head>
<body>
	<div class="header">
		<h1>Trang chủ</h1>
		<div class="user-info">
			<a href="${pageContext.request.contextPath}/follows/following"
				class="btn"
				style="margin-right: 10px; text-decoration: none; color: #000;">
				<i class="fas fa-users"></i> Theo dõi
			</a> <span>Xin chào, ${sessionScope.user.username}</span> <a
				href="${pageContext.request.contextPath}/logout" class="btn">Đăng
				xuất</a>
		</div>
	</div>
	<div class="container">
		<!-- Form tìm kiếm -->
		<div class="search-form">
			<h2>Tìm kiếm người dùng</h2>
			<form action="${pageContext.request.contextPath}/search" method="get">
				<input type="hidden" name="redirect" value="home">
				<div class="form-group">
					<label for="minFollowing">Số lượng đang theo dõi tối thiểu:</label>
					<input type="number" id="minFollowing" name="minFollowing"
						value="${minFollowing != null ? minFollowing : 3}"
						placeholder="Nhập số lượng (mặc định 3)" class="form-control">
				</div>
				<div class="form-group">
					<label for="minFollowers">Số lượng người theo dõi tối
						thiểu:</label> <input type="number" id="minFollowers" name="minFollowers"
						value="${minFollowers != null ? minFollowers : 5}"
						placeholder="Nhập số lượng (mặc định 5)" class="form-control">
				</div>
				<button type="submit" class="btn btn-primary">Tìm kiếm</button>
			</form>
		</div>
		<!-- Hiển thị kết quả tìm kiếm -->
		<c:choose>
			<c:when test="${searchUsers != null}">

				<div class="user-list">
					<c:choose>
						<c:when test="${not empty searchUsers}">
							<c:forEach items="${searchUsers}" var="user">
								<div class="user-item">
									<div class="user-details">
										<h3>${user.username}</h3>
									</div>
									<a
										href="${pageContext.request.contextPath}/follows/following?userId=${user.id}"
										class="btn btn-primary">Xem chi tiết</a>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="not-found">
								<img
									src="${pageContext.request.contextPath}/img/12753479.png"
									alt="Không tìm thấy">
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</c:when>
			<c:otherwise>
				<div class="error-message">Chưa thực hiện tìm kiếm hoặc có lỗi
					khi tải dữ liệu tìm kiếm.</div>
			</c:otherwise>
		</c:choose>
		<!-- Nút đăng bài -->
		<button onclick="togglePostForm()" class="btn btn-primary"
			style="margin-bottom: 20px;">
			<i class="fas fa-plus"></i> Đăng bài mới
		</button>
		<!-- Form đăng bài (mặc định ẩn) -->
		<div id="postForm" class="post-form" style="display: none;">
			<div class="post-form-header">
				<h2>Đăng bài mới</h2>
				<button onclick="togglePostForm()" class="btn-close">×</button>
			</div>
			<form action="${pageContext.request.contextPath}/post" method="post">
				<input type="text" name="title" placeholder="Tiêu đề bài viết"
					required class="form-control">
				<textarea name="body" rows="4" placeholder="Nội dung bài viết"
					required></textarea>
				<div class="form-actions">
					<button type="submit" class="btn btn-primary">Đăng bài</button>
					<button type="button" onclick="togglePostForm()" class="btn">Hủy</button>
				</div>
			</form>
		</div>
		<!-- Danh sách bài viết -->
		<c:choose>
			<c:when test="${posts != null}">

				<div class="post-list">
					<c:forEach items="${posts}" var="post">
						<div class="post-card">
							<div class="post-header">
								<div class="post-meta">
									<div class="post-author">
										<i class="fas fa-user"></i> <span>Người dùng:
											${post.user.username}</span>
										<c:if
											test="${sessionScope.user != null and sessionScope.user.id != post.user.id}">
											<button onclick="toggleFollow('${post.user.id}')"
												class="btn-follow ${post.user.followedByCurrentUser ? 'following' : ''}"
												id="follow-btn-${post.user.id}">
												<c:choose>
													<c:when test="${post.user.followedByCurrentUser}">
														<i class="fas fa-user-minus"></i> Bỏ theo dõi </c:when>
													<c:otherwise>
														<i class="fas fa-user-plus"></i> Theo dõi </c:otherwise>
												</c:choose>
											</button>
										</c:if>
									</div>
									<div class="post-date">
										<i class="far fa-clock"></i>
										<fmt:parseDate value="${post.createdAt}"
											pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
										<span> <fmt:formatDate value="${parsedDate}"
												pattern="dd/MM/yyyy HH:mm" />
										</span>
									</div>
								</div>
								<c:if test="${sessionScope.user.id == post.user.id}">
									<div class="post-actions">
										<form action="post/edit" method="get" style="display: inline;">
											<input type="hidden" name="postId" value="${post.id}">
											<button type="submit" class="btn btn-edit">
												<i class="fas fa-edit"></i> Sửa
											</button>
										</form>
										<button type="button" class="btn btn-delete"
											onclick="deletePost('${post.id}')">
											<i class="fas fa-trash-alt"></i> Xóa
										</button>
									</div>
								</c:if>
							</div>
							<h3 class="post-title">${post.title}</h3>
							<div class="post-content">
								<p>${post.body}</p>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:when>
			<c:otherwise>
				<div class="error-message">Không thể tải danh sách bài viết.
					Vui lòng kiểm tra HomeServlet.</div>
			</c:otherwise>
		</c:choose>
		<!-- Phân trang -->
		<c:if test="${posts != null}">

			<div class="pagination">
				<c:if test="${currentPage > 1}">
					<a href="?page=${currentPage - 1}" class="page-link">« Trước</a>
				</c:if>
				<c:forEach begin="1" end="${totalPages}" var="i">
					<a href="?page=${i}"
						class="page-link ${currentPage == i ? 'active' : ''}">${i}</a>
				</c:forEach>

				<c:if test="${currentPage < totalPages}">
					<a href="?page=${currentPage + 1}" class="page-link">Sau »</a>
				</c:if>

			</div>
		</c:if>
	</div>
	<script> function togglePostForm() { const form = document.getElementById('postForm'); if (form.style.display === 'none') { form.style.display = 'block'; } else { form.style.display = 'none'; } } function deletePost(postId) { if (confirm('Bạn có chắc muốn xóa bài viết này?')) { fetch('${pageContext.request.contextPath}/post/' + postId, { method: 'DELETE' }) .then(response => { if (response.ok) { // Xóa bài viết khỏi giao diện mà không reload trang const postCard = document.querySelector(`[onclick="deletePost('${postId}')"]`).closest('.post-card'); if (postCard) { postCard.remove(); } } else { alert('Có lỗi xảy ra khi xóa bài viết'); } }) .catch(error => { console.error('Error:', error); alert('Có lỗi xảy ra khi xóa bài viết'); }); } } function toggleFollow(userId) { const buttonId = 'follow-btn-' + userId; const followButton = document.getElementById(buttonId); if (!followButton) { console.error('Follow button not found for userId:', userId); return; } const isFollowing = followButton.classList.contains('following'); const method = isFollowing ? 'DELETE' : 'POST'; fetch('${pageContext.request.contextPath}/follow/' + userId, { method: method }) .then(response => { if (response.ok) { // Cập nhật giao diện nút mà không reload trang followButton.classList.toggle('following'); followButton.innerHTML = isFollowing ? '<i class="fas fa-user-plus"></i> Theo dõi' : '<i class="fas fa-user-minus"></i> Bỏ theo dõi'; } else { alert('Có lỗi xảy ra khi thực hiện thao tác này'); } }) .catch(error => { console.error('Error:', error); alert('Có lỗi xảy ra khi thực hiện thao tác này'); }); } </script>
</body>
</html>