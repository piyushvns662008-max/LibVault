<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.libvault.model.User" %>
<%-- FILE: WebContent/profile.jsp --%>
<jsp:include page="header.jsp" />
<%
    User u = (User) session.getAttribute("user");
    if (u == null) { response.sendRedirect("login.jsp"); return; }
%>
<div class="row justify-content-center">
  <div class="col-md-6">
    <div class="card shadow-sm">
      <div class="card-body p-4">
        <h3 class="mb-3"><i class="bi bi-person-circle"></i> My Profile</h3>
        <form action="<%=request.getContextPath()%>/auth" method="post">
          <input type="hidden" name="action" value="updateProfile">
          <div class="mb-3">
            <label class="form-label">Full Name</label>
            <input type="text" name="name" class="form-control" value="<%=u.getName()%>" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Email (cannot be changed)</label>
            <input type="email" class="form-control" value="<%=u.getEmail()%>" disabled>
          </div>
          <div class="mb-3">
            <label class="form-label">Phone</label>
            <input type="text" name="phone" class="form-control" value="<%=u.getPhone()==null?"":u.getPhone()%>">
          </div>
          <div class="mb-3">
            <label class="form-label">Account Status</label>
            <input type="text" class="form-control" value="<%=u.getStatus()%>" disabled>
          </div>
          <button type="submit" class="btn btn-primary">Save Changes</button>
        </form>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
