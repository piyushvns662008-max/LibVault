<%@ page contentType="text/html;charset=UTF-8" %>
<%-- FILE: WebContent/register.jsp --%>
<jsp:include page="header.jsp" />

<div class="row justify-content-center my-4">
  <div class="col-lg-9">
    <div class="auth-split">
      <div class="auth-side">
        <i class="bi bi-journal-bookmark" style="font-size:2rem;color:#B8863E;"></i>
        <h3 class="mt-3">Get your library card.</h3>
        <p>Create a free account to start borrowing - takes less than a minute, no visit required.</p>
      </div>
      <div class="auth-form-panel">
        <h4 class="mb-3">Create account</h4>
        <form action="<%=request.getContextPath()%>/auth" method="post">
          <input type="hidden" name="action" value="register">
          <div class="mb-3">
            <label class="form-label">Full Name</label>
            <input type="text" name="name" class="form-control" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Phone</label>
            <input type="text" name="phone" class="form-control" pattern="[0-9]{10}" title="10 digit phone number" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" minlength="4" required>
          </div>
          <button type="submit" class="btn btn-primary w-100">Create account</button>
        </form>
        <p class="text-center mt-3">Already have an account? <a href="login.jsp">Log in</a></p>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
