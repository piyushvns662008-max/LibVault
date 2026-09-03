<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.libvault.model.Book, com.libvault.model.User" %>
<%-- FILE: WebContent/bookdetails.jsp --%>
<jsp:include page="header.jsp" />
<%
    Book b = (Book) request.getAttribute("book");
    User u = (User) session.getAttribute("user");
    if (b == null) {
%>
    <p class="text-danger">Book not found.</p>
<%
    } else {
%>
<div class="row g-4">
  <div class="col-md-4">
    <img src="<%=b.getCoverUrl()!=null && !b.getCoverUrl().isEmpty() ? b.getCoverUrl() : "https://via.placeholder.com/300x400?text=No+Cover"%>" class="img-fluid rounded shadow-sm">
  </div>
  <div class="col-md-8">
    <h2><%=b.getTitle()%></h2>
    <p class="text-muted">by <strong><%=b.getAuthor()%></strong></p>
    <table class="table table-sm w-auto">
      <tr><th>Book ID</th><td>#<%=b.getBookId()%></td></tr>
      <tr><th>ISBN</th><td><%=b.getIsbn()%></td></tr>
      <tr><th>Category</th><td><%=b.getCategory()%></td></tr>
      <tr><th>Publisher</th><td><%=b.getPublisher()%></td></tr>
      <tr><th>Year</th><td><%=b.getPubYear()%></td></tr>
      <tr><th>Shelf Location</th><td><%=b.getShelfLocation()%></td></tr>
      <tr><th>Availability</th>
        <td>
          <% if (b.getAvailableCopies() > 0) { %>
            <span class="badge bg-success"><%=b.getAvailableCopies()%> of <%=b.getQuantity()%> copies available</span>
          <% } else { %>
            <span class="badge bg-danger">All copies issued</span>
          <% } %>
        </td>
      </tr>
    </table>
    <p><%=b.getDescription()!=null?b.getDescription():"No description available."%></p>

    <% if (u == null) { %>
        <a href="login.jsp" class="btn btn-primary">Login to Borrow</a>
    <% } else if ("USER".equals(u.getRole())) { %>
        <form action="<%=request.getContextPath()%>/book" method="post">
          <input type="hidden" name="action" value="borrow">
          <input type="hidden" name="bookId" value="<%=b.getBookId()%>">
          <button type="submit" class="btn btn-success" <%=b.getAvailableCopies()<=0?"disabled":""%>>
            <i class="bi bi-journal-check"></i> Borrow this Book
          </button>
        </form>
    <% } %>
  </div>
</div>
<%
    }
%>
<jsp:include page="footer.jsp" />
