<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.libvault.model.Book" %>
<%-- FILE: WebContent/admin/books.jsp --%>
<jsp:include page="../header.jsp" />
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
    String keyword = (String) request.getAttribute("keyword");
%>
<div class="d-flex justify-content-between align-items-center mb-3">
  <h3><i class="bi bi-book"></i> Manage Books</h3>
  <a href="<%=request.getContextPath()%>/admin/addbook.jsp" class="btn btn-success"><i class="bi bi-plus-circle"></i> Add New Book</a>
</div>

<form action="<%=request.getContextPath()%>/admin" method="get" class="row g-2 mb-3">
  <input type="hidden" name="action" value="books">
  <div class="col-md-6">
    <input type="text" name="keyword" class="form-control" placeholder="Search by title, author, ISBN" value="<%=keyword==null?"":keyword%>">
  </div>
  <div class="col-md-2">
    <button class="btn btn-primary w-100" type="submit">Search</button>
  </div>
</form>

<div class="table-responsive">
<table class="table table-bordered table-hover bg-white">
  <thead class="table-light">
    <tr><th>ID</th><th>Title</th><th>Author</th><th>Category</th><th>Qty</th><th>Available</th><th>Actions</th></tr>
  </thead>
  <tbody>
  <% if (books != null) for (Book b : books) { %>
    <tr>
      <td>#<%=b.getBookId()%></td>
      <td><%=b.getTitle()%></td>
      <td><%=b.getAuthor()%></td>
      <td><%=b.getCategory()%></td>
      <td><%=b.getQuantity()%></td>
      <td><%=b.getAvailableCopies()%></td>
      <td>
        <a href="<%=request.getContextPath()%>/admin?action=editBook&id=<%=b.getBookId()%>" class="btn btn-sm btn-outline-secondary">Edit</a>
        <a href="<%=request.getContextPath()%>/admin?action=deleteBook&id=<%=b.getBookId()%>" class="btn btn-sm btn-outline-danger"
           onclick="return confirm('Delete this book?');">Delete</a>
      </td>
    </tr>
  <% } %>
  </tbody>
</table>
</div>

<jsp:include page="../footer.jsp" />
