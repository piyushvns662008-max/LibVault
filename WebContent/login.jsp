<%@ page contentType="text/html;charset=UTF-8" %>
<%-- FILE: WebContent/login.jsp --%>
<jsp:include page="header.jsp" />

<div class="row justify-content-center my-4">
  <div class="col-lg-9">
    <div class="auth-split">
      <div class="auth-side">
        <i class="bi bi-bookmark-star" style="font-size:2rem;color:#B8863E;"></i>
        <h3 class="mt-3">Welcome back to the shelves.</h3>
        <p>Sign in to see your borrowed books, due dates, and pick up right where you left off.</p>
      </div>
      <div class="auth-form-panel">
        <h4 class="mb-3">Log in</h4>
        <form action="<%=request.getContextPath()%>/auth" method="post">
          <input type="hidden" name="action" value="login">
          <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" required>
          </div>
          <button type="submit" class="btn btn-primary w-100">Log in</button>
        </form>
        <p class="text-center mt-3 mb-1">New here? <a href="register.jsp">Create an account</a></p>
        <p class="text-center text-muted small">Admin demo login: admin@libvault.com / admin123</p>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
