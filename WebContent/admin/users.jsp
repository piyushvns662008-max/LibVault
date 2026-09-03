<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.libvault.model.User" %>
<%-- FILE: WebContent/admin/users.jsp --%>
<jsp:include page="../header.jsp" />
<%
    List<User> users = (List<User>) request.getAttribute("users");
%>
<h3 class="mb-3"><i class="bi bi-people"></i> Manage Members</h3>

<div class="table-responsive">
<table class="table table-bordered table-hover bg-white">
  <thead class="table-light">
    <tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Status</th><th>Action</th></tr>
  </thead>
  <tbody>
  <% if (users != null) for (User u : users) { %>
    <tr>
      <td>#<%=u.getUserId()%></td>
      <td><%=u.getName()%></td>
      <td><%=u.getEmail()%></td>
      <td><%=u.getPhone()%></td>
      <td>
        <% if ("ACTIVE".equals(u.getStatus())) { %>
          <span class="badge bg-success">Active</span>
        <% } else { %>
          <span class="badge bg-danger">Blocked</span>
        <% } %>
      </td>
      <td>
        <% if ("ACTIVE".equals(u.getStatus())) { %>
          <a href="<%=request.getContextPath()%>/admin?action=block&id=<%=u.getUserId()%>" class="btn btn-sm btn-outline-danger"
             onclick="return confirm('Block this user?');">Block</a>
        <% } else { %>
          <a href="<%=request.getContextPath()%>/admin?action=unblock&id=<%=u.getUserId()%>" class="btn btn-sm btn-outline-success">Unblock</a>
        <% } %>
      </td>
    </tr>
  <% } %>
  </tbody>
</table>
</div>

<jsp:include page="../footer.jsp" />
