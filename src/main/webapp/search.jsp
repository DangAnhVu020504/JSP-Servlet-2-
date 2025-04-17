&lt;%@ page contentType="text/html;charset=UTF-8" language="java" %&gt; &lt;%@ taglib prefix="c" uri="jakarta.tags.core" %&gt;

# Tìm kiếm người dùng

Theo dõi Trang chủ Xin chào, ${sessionScope.user.username} Đăng xuất

```
<div class="container">
    <div class="search-form">
        <h2>Tìm kiếm người dùng</h2>
        <form action="${pageContext.request.contextPath}/search" method="get">
            <div class="form-group">
                <label for="minFollowing">Số lượng đang theo dõi tối thiểu:</label>
                <input type="number" id="minFollowing" name="minFollowing" value="${minFollowing}" placeholder="Nhập số lượng (mặc định 3)">
            </div>
            <div class="form-group">
                <label for="minFollowers">Số lượng người theo dõi tối thiểu:</label>
                <input type="number" id="minFollowers" name="minFollowers" value="${minFollowers}" placeholder="Nhập số lượng (mặc định 5)">
            </div>
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
        </form>
    </div>

    <div class="user-list">
        <c:choose>
            <c:when test="${not empty users}">
                <c:forEach items="${users}" var="user">
                    <div class="user-item">
                        <div class="user-details">
                            <h3>${user.username}</h3>
                        </div>
                        <a href="${pageContext.request.contextPath}/follows/following?userId=${user.id}" class="btn btn-primary">
                            Xem chi tiết
                        </a>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="not-found">
                    <img src="${pageContext.request.contextPath}/imag/12753479.png" alt="Không tìm thấy">
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
```