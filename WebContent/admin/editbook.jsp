<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.libvault.model.Book" %>
<%-- FILE: WebContent/admin/editbook.jsp --%>
<jsp:include page="../header.jsp" />
<%
    Book b = (Book) request.getAttribute("book");
%>
<div class="card shadow-sm">
  <div class="card-body p-4">
    <h3 class="mb-3"><i class="bi bi-pencil-square"></i> Edit Book</h3>
    <% if (b == null) { %>
      <p class="text-danger">Book not found.</p>
    <% } else { %>
    <form action="<%=request.getContextPath()%>/admin" method="post">
      <input type="hidden" name="action" value="updateBook">
      <input type="hidden" name="bookId" value="<%=b.getBookId()%>">
      <div class="row g-3">
        <div class="col-md-6"><label class="form-label">Title</label><input type="text" name="title" class="form-control" value="<%=b.getTitle()%>" required></div>
        <div class="col-md-6"><label class="form-label">Author</label><input type="text" name="author" class="form-control" value="<%=b.getAuthor()%>" required></div>
        <div class="col-md-4"><label class="form-label">ISBN</label><input type="text" name="isbn" class="form-control" value="<%=b.getIsbn()==null?"":b.getIsbn()%>"></div>
        <div class="col-md-4"><label class="form-label">Category</label><input type="text" name="category" class="form-control" value="<%=b.getCategory()%>" required></div>
        <div class="col-md-4"><label class="form-label">Publisher</label><input type="text" name="publisher" class="form-control" value="<%=b.getPublisher()==null?"":b.getPublisher()%>"></div>
        <div class="col-md-3"><label class="form-label">Publication Year</label><input type="number" name="pubYear" class="form-control" value="<%=b.getPubYear()%>" required></div>
        <div class="col-md-3"><label class="form-label">Quantity</label><input type="number" name="quantity" class="form-control" value="<%=b.getQuantity()%>" required></div>
        <div class="col-md-3"><label class="form-label">Shelf Location</label><input type="text" name="shelfLocation" class="form-control" value="<%=b.getShelfLocation()==null?"":b.getShelfLocation()%>"></div>
        <div class="col-md-3"><label class="form-label">Cover Image URL</label><input type="text" name="coverUrl" class="form-control" value="<%=b.getCoverUrl()==null?"":b.getCoverUrl()%>"></div>
        <div class="col-12"><label class="form-label">Description</label><textarea name="description" class="form-control" rows="3"><%=b.getDescription()==null?"":b.getDescription()%></textarea></div>
      </div>
      <button type="submit" class="btn btn-primary mt-3"><i class="bi bi-save"></i> Update Book</button>
      <a href="<%=request.getContextPath()%>/admin?action=books" class="btn btn-secondary mt-3">Cancel</a>
    </form>
    <% } %>
  </div>
</div>

<jsp:include page="../footer.jsp" />
