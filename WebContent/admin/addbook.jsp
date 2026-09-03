<%@ page contentType="text/html;charset=UTF-8" %>
<%-- FILE: WebContent/admin/addbook.jsp --%>
<jsp:include page="../header.jsp" />

<div class="card shadow-sm">
  <div class="card-body p-4">
    <h3 class="mb-3"><i class="bi bi-plus-circle"></i> Add New Book</h3>
    <form action="<%=request.getContextPath()%>/admin" method="post">
      <input type="hidden" name="action" value="addBook">
      <div class="row g-3">
        <div class="col-md-6"><label class="form-label">Title</label><input type="text" name="title" class="form-control" required></div>
        <div class="col-md-6"><label class="form-label">Author</label><input type="text" name="author" class="form-control" required></div>
        <div class="col-md-4"><label class="form-label">ISBN</label><input type="text" name="isbn" class="form-control"></div>
        <div class="col-md-4"><label class="form-label">Category</label><input type="text" name="category" class="form-control" required></div>
        <div class="col-md-4"><label class="form-label">Publisher</label><input type="text" name="publisher" class="form-control"></div>
        <div class="col-md-3"><label class="form-label">Publication Year</label><input type="number" name="pubYear" class="form-control" min="1000" max="2100" required></div>
        <div class="col-md-3"><label class="form-label">Quantity</label><input type="number" name="quantity" class="form-control" min="1" required></div>
        <div class="col-md-3"><label class="form-label">Shelf Location</label><input type="text" name="shelfLocation" class="form-control"></div>
        <div class="col-md-3"><label class="form-label">Cover Image URL</label><input type="text" name="coverUrl" class="form-control"></div>
        <div class="col-12"><label class="form-label">Description</label><textarea name="description" class="form-control" rows="3"></textarea></div>
      </div>
      <button type="submit" class="btn btn-success mt-3"><i class="bi bi-save"></i> Save Book</button>
      <a href="<%=request.getContextPath()%>/admin?action=books" class="btn btn-secondary mt-3">Cancel</a>
    </form>
  </div>
</div>

<jsp:include page="../footer.jsp" />
