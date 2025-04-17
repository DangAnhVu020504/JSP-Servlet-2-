package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.DAO.FollowDAO;
import org.example.DAO.FollowDAOImpl;
import org.example.DAO.PostsDAO;
import org.example.DAO.PostsDAOImpl;
import org.example.model.User;
import org.example.model.Posts;

import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
	private FollowDAO followDAO = new FollowDAOImpl();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
// Lấy tham số từ form tìm kiếm
		String minFollowingStr = request.getParameter("minFollowing");
		String minFollowersStr = request.getParameter("minFollowers");
		String redirect = request.getParameter("redirect");

// Mặc định nếu không nhập thì tìm kiếm với giá trị tối thiểu
		int minFollowing = minFollowingStr != null && !minFollowingStr.isEmpty() ? Integer.parseInt(minFollowingStr)
				: 3;
		int minFollowers = minFollowersStr != null && !minFollowersStr.isEmpty() ? Integer.parseInt(minFollowersStr)
				: 5;

// Tìm kiếm người dùng
		List<User> users = followDAO.searchUsersByFollowCount(minFollowing, minFollowers);

// Lưu kết quả tìm kiếm vào session
		request.getSession().setAttribute("searchUsers", users);
		request.getSession().setAttribute("minFollowing", minFollowing);
		request.getSession().setAttribute("minFollowers", minFollowers);

// Gửi kết quả tìm kiếm
		request.setAttribute("searchUsers", users);
		request.setAttribute("minFollowing", minFollowing);
		request.setAttribute("minFollowers", minFollowers);

// Nếu có tham số redirect, chuyển hướng đến trang đó
		if (redirect != null && redirect.equals("home")) {
// Tải lại danh sách bài viết để hiển thị trên home.jsp
			int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
			int postsPerPage = 5;
			int offset = (page - 1) * postsPerPage;

			PostsDAO postsDAO = new PostsDAOImpl();
			List<Posts> posts = postsDAO.findAll(offset, postsPerPage,
					(User) request.getSession().getAttribute("user"));
			int totalPosts = postsDAO.findAll().size();
			int totalPages = (int) Math.ceil((double) totalPosts / postsPerPage);

			request.setAttribute("posts", posts);
			request.setAttribute("currentPage", page);
			request.setAttribute("totalPages", totalPages);

			request.getRequestDispatcher("/home.jsp").forward(request, response);
		} else {
			request.getRequestDispatcher("/search.jsp").forward(request, response);
		}
	}
}