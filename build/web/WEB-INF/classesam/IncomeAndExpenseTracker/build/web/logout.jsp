<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate session to log out user
    session.invalidate();

    // Redirect to login page
    response.sendRedirect("login.jsp");
%>