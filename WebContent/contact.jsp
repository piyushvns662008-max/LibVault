<%@ page contentType="text/html;charset=UTF-8" %>
<%-- FILE: WebContent/contact.jsp --%>
<jsp:include page="header.jsp" />

<div class="row justify-content-center">
  <div class="col-md-7">
    <div class="card shadow-sm">
      <div class="card-body p-4">
        <h3><i class="bi bi-envelope"></i> Contact Us</h3>
        <p class="text-muted">Have a question or feedback? Send us a message.</p>
        <form action="<%=request.getContextPath()%>/contact" method="post">
          <div class="mb-3">
            <label class="form-label">Name</label>
            <input type="text" name="name" class="form-control" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Message</label>
            <textarea name="message" class="form-control" rows="4" required></textarea>
          </div>
          <button type="submit" class="btn btn-primary">Send Message</button>
        </form>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
