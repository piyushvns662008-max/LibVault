<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.libvault.model.User, com.libvault.model.Book" %>
<%-- FILE: WebContent/admin/issuebook.jsp --%>
<jsp:include page="../header.jsp" />
<%
    List<User> users = (List<User>) request.getAttribute("users");
    List<Book> books = (List<Book>) request.getAttribute("books");
%>
<div class="card shadow-sm">
  <div class="card-body p-4">
    <h3 class="mb-3"><i class="bi bi-journal-plus"></i> Issue a Book</h3>
    <form action="<%=request.getContextPath()%>/admin" method="post">
      <input type="hidden" name="action" value="issueBook">
      <div class="mb-3">
        <label class="form-label">Select Member</label>
        <select name="userId" class="form-select" required>
          <option value="">-- choose member --</option>
          <% if (users != null) for (User u : users) { %>
            <option value="<%=u.getUserId()%>"><%=u.getName()%> (<%=u.getEmail()%>)</option>
          <% } %>
        </select>
      </div>
      <div class="mb-3">
        <label class="form-label">Select Book</label>
        <select name="bookId" class="form-select" required>
          <option value="">-- choose book --</option>
          <% if (books != null) for (Book b : books) { %>
            <option value="<%=b.getBookId()%>" <%=b.getAvailableCopies()<=0?"disabled":""%>>
              <%=b.getTitle()%> (<%=b.getAvailableCopies()%> available)
            </option>
          <% } %>
        </select>
      </div>
      <button type="submit" class="btn btn-success">Issue Book</button>
    </form>
  </div>
</div>

<jsp:include page="../footer.jsp" />
