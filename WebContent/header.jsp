<%@ page import="com.libvault.model.User" %>
<%-- FILE: WebContent/header.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LibVault - Library Management</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Fraunces:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<%
    User sessUser = (User) session.getAttribute("user");
%>
<nav class="navbar navbar-expand-lg navbar-dark lv-navbar">
  <div class="container">
    <a class="navbar-brand" href="<%=request.getContextPath()%>/index.jsp"><span class="brand-mark"><i class="bi bi-bookmark-fill"></i></span> LibVault</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMenu">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/index.jsp">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/book?action=list">Browse Books</a></li>
        <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/about.jsp">About</a></li>
        <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/contact.jsp">Contact</a></li>
        <% if (sessUser != null && "USER".equals(sessUser.getRole())) { %>
        <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/book?action=myBooks">My Books</a></li>
        <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/book?action=history">History</a></li>
        <% } %>
        <% if (sessUser != null && "ADMIN".equals(sessUser.getRole())) { %>
        <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin?action=dashboard">Admin Dashboard</a></li>
        <% } %>
      </ul>
      <ul class="navbar-nav">
        <% if (sessUser == null) { %>
          <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/login.jsp">Login</a></li>
          <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/register.jsp">Register</a></li>
        <% } else { %>
          <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/profile.jsp"><i class="bi bi-person-circle"></i> <%=sessUser.getName()%></a></li>
          <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/auth?action=logout">Logout</a></li>
        <% } %>
      </ul>
    </div>
  </div>
</nav>
<div class="container mt-3">
<%
    String msg = request.getParameter("msg");
    String err = request.getParameter("error");
    if (msg != null) {
%>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle"></i> <%=msg%>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<%
    }
    if (err != null) {
%>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle"></i> <%=err%>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<%
    }
%>
</div>
