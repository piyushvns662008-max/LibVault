<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.libvault.model.Transaction, com.libvault.util.FineUtil" %>
<%-- FILE: WebContent/myborrowed.jsp --%>
<jsp:include page="header.jsp" />
<%
    List<Transaction> myBooks = (List<Transaction>) request.getAttribute("myBooks");
%>
<h3 class="mb-3"><i class="bi bi-journal-bookmark"></i> My Borrowed Books</h3>

<% if (myBooks == null || myBooks.isEmpty()) { %>
  <p class="text-muted">You have no books currently borrowed. <a href="<%=request.getContextPath()%>/book?action=list">Browse books</a> to get started.</p>
<% } else { %>
<div class="table-responsive">
<table class="table table-bordered table-hover bg-white">
  <thead class="table-light">
    <tr><th>Book</th><th>Issue Date</th><th>Due Date</th><th>Status</th><th>Fine</th><th>Action</th></tr>
  </thead>
  <tbody>
  <% for (Transaction t : myBooks) {
        boolean overdue = t.isOverdue();
        double fine = overdue ? FineUtil.calculateFine(t.getDueDate()) : 0;
  %>
    <tr>
      <td><%=t.getBookTitle()%></td>
      <td><%=t.getIssueDate()%></td>
      <td><%=t.getDueDate()%></td>
      <td>
        <% if (overdue) { %>
          <span class="badge badge-status-overdue">Overdue</span>
        <% } else { %>
          <span class="badge badge-status-issued">Issued</span>
        <% } %>
      </td>
      <td><%= fine > 0 ? "Rs. " + fine : "-" %></td>
      <td>
        <form action="<%=request.getContextPath()%>/book" method="post" class="d-inline">
          <input type="hidden" name="action" value="return">
          <input type="hidden" name="txnId" value="<%=t.getTxnId()%>">
          <input type="hidden" name="bookId" value="<%=t.getBookId()%>">
          <button type="submit" class="btn btn-sm btn-outline-primary">Return</button>
        </form>
      </td>
    </tr>
  <% } %>
  </tbody>
</table>
</div>
<p class="text-muted small">Note: a fine of Rs. <%=com.libvault.util.FineUtil.FINE_PER_DAY%>/day applies automatically for every day past the due date.</p>
<% } %>

<jsp:include page="footer.jsp" />
