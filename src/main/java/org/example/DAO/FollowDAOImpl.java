package org.example.DAO;

import org.example.model.User;
import org.example.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FollowDAOImpl implements FollowDAO {
    private final DatabaseConnection databaseConnection = new DatabaseConnection();

    @Override
    public void follow(User follower, User following) {
        String sql = "INSERT INTO follows (follower_id, following_id) VALUES (?, ?)";
        try (Connection connection = databaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, follower.getId());
            statement.setLong(2, following.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void unfollow(User follower, User following) {
        if (follower == null || following == null || follower.getId() == null || following.getId() == null) {
            throw new IllegalArgumentException("Follower or following user is null or has null ID");
        }
        
        String sql = "DELETE FROM follows WHERE follower_id = ? AND following_id = ?";
        try (Connection connection = databaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, follower.getId());
            statement.setLong(2, following.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<User> findFollowing(User user) {
        List<User> followingUsers = new ArrayList<>();
        String sql = "SELECT u.* FROM users u JOIN follows f ON u.id = f.following_id WHERE f.follower_id = ?";
        try (Connection connection = databaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, user.getId());
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User followingUser = mapRowToUser(resultSet);
                followingUsers.add(followingUser);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return followingUsers;
    }

    @Override
    public List<User> findFollowers(User user) {
        List<User> followers = new ArrayList<>();
        String sql = "SELECT u.* FROM users u JOIN follows f ON u.id = f.follower_id WHERE f.following_id = ?";
        try (Connection connection = databaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, user.getId());
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User followerUser = mapRowToUser(resultSet);
                followers.add(followerUser);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return followers;
    }

    @Override
    public List<User> searchUsersByFollowCount(int minFollowing, int minFollowers) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.* " +
                     "FROM users u " +
                     "LEFT JOIN (SELECT follower_id, COUNT(*) as following_count " +
                     "           FROM follows " +
                     "           GROUP BY follower_id) f1 ON u.id = f1.follower_id " +
                     "LEFT JOIN (SELECT following_id, COUNT(*) as follower_count " +
                     "           FROM follows " +
                     "           GROUP BY following_id) f2 ON u.id = f2.following_id " +
                     "WHERE (f1.following_count >= ? OR f1.following_count IS NULL) " +
                     "  AND (f2.follower_count >= ? OR f2.follower_count IS NULL)";

        try (Connection connection = databaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, minFollowing);
            statement.setInt(2, minFollowers);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = mapRowToUser(resultSet);
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    private User mapRowToUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setId(resultSet.getLong("id"));
        user.setUsername(resultSet.getString("username"));
        user.setPassword(resultSet.getString("password"));
        user.setRole(resultSet.getString("role"));
        user.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
        return user;
    }
}