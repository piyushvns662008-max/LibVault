<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.libvault.model.Book" %>
<%-- FILE: WebContent/books.jsp --%>
<jsp:include page="header.jsp" />
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
    List<String> categories = (List<String>) request.getAttribute("categories");
    String keyword = (String) request.getAttribute("keyword");
    String category = (String) request.getAttribute("category");
%>
<div class="section-heading">
  <h3><i class="bi bi-search"></i> Browse the Catalog</h3>
  <p class="text-muted mb-0">Search by title, author or ISBN, or narrow it down by category.</p>
</div>

<form action="<%=request.getContextPath()%>/book" method="get" class="card p-3 row g-2 mb-4 mx-0">
  <input type="hidden" name="action" value="list">
  <div class="col-md-6">
    <input type="text" name="keyword" class="form-control" placeholder="Search by title, author or ISBN"
           value="<%=keyword==null?"":keyword%>">
  </div>
  <div class="col-md-3">
    <select name="category" class="form-select">
      <option value="All">All Categories</option>
      <% if (categories != null) for (String c : categories) { %>
        <option value="<%=c%>" <%=c.equals(category)?"selected":""%>><%=c%></option>
      <% } %>
    </select>
  </div>
  <div class="col-md-3">
    <button type="submit" class="btn btn-primary w-100"><i class="bi bi-funnel"></i> Search / Filter</button>
  </div>
</form>

<div class="row g-4">
<% if (books == null || books.isEmpty()) { %>
  <p class="text-muted">No books found matching your search.</p>
<% } else {
    for (Book b : books) { %>
  <div class="col-md-3 col-sm-6">
    <div class="card book-card <%=b.getAvailableCopies()<=0?"unavailable":""%>">
      <img src="<%=b.getCoverUrl()!=null && !b.getCoverUrl().isEmpty() ? b.getCoverUrl() : "https://via.placeholder.com/200x260?text=No+Cover"%>" class="card-img-top book-cover" alt="cover">
      <div class="card-body">
        <h6 class="card-title"><%=b.getTitle()%></h6>
        <p class="card-text text-muted small mb-1">by <%=b.getAuthor()%></p>
        <p class="mb-2">
          <span class="badge bg-secondary"><%=b.getCategory()%></span>
          <% if (b.getAvailableCopies() > 0) { %>
            <span class="badge bg-success">Available</span>
          <% } else { %>
            <span class="badge bg-danger">Not Available</span>
          <% } %>
        </p>
        <a href="<%=request.getContextPath()%>/book?action=details&id=<%=b.getBookId()%>" class="btn btn-outline-primary btn-sm w-100">View Details</a>
      </div>
    </div>
  </div>
<%  }
} %>
</div>

<jsp:include page="footer.jsp" />
