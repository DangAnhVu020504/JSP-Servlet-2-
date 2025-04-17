package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.DAO.PostsDAO;
import org.example.DAO.PostsDAOImpl;
import org.example.model.Posts;
import org.example.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
	private static final int POSTS_PER_PAGE = 5;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int page = 1;
		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}

		int offset = (page - 1) * POSTS_PER_PAGE;
		PostsDAO postsDAO = new PostsDAOImpl();
		User currentUser = (User) request.getSession().getAttribute("user");

		List<Posts> posts = postsDAO.findAll(offset, POSTS_PER_PAGE, currentUser);
		int totalPosts = postsDAO.findAll().size();
		int totalPages = (int) Math.ceil((double) totalPosts / POSTS_PER_PAGE);

// Lấy kết quả tìm kiếm từ session (nếu có)
		List<User> searchUsers = (List<User>) request.getSession().getAttribute("searchUsers");
		Integer minFollowing = (Integer) request.getSession().getAttribute("minFollowing");
		Integer minFollowers = (Integer) request.getSession().getAttribute("minFollowers");

		request.setAttribute("posts", posts);
		request.setAttribute("currentPage", page);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("searchUsers", searchUsers);
		request.setAttribute("minFollowing", minFollowing);
		request.setAttribute("minFollowers", minFollowers);

		request.getRequestDispatcher("/home.jsp").forward(request, response);
	}
}