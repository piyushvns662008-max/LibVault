<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.libvault.model.Transaction" %>
<%-- FILE: WebContent/history.jsp --%>
<jsp:include page="header.jsp" />
<%
    List<Transaction> history = (List<Transaction>) request.getAttribute("history");
%>
<h3 class="mb-3"><i class="bi bi-clock-history"></i> My Borrowing History</h3>

<% if (history == null || history.isEmpty()) { %>
  <p class="text-muted">No past borrowing records yet.</p>
<% } else { %>
<div class="table-responsive">
<table class="table table-bordered bg-white">
  <thead class="table-light">
    <tr><th>Book</th><th>Issue Date</th><th>Due Date</th><th>Return Date</th><th>Fine Paid</th></tr>
  </thead>
  <tbody>
  <% for (Transaction t : history) { %>
    <tr>
      <td><%=t.getBookTitle()%></td>
      <td><%=t.getIssueDate()%></td>
      <td><%=t.getDueDate()%></td>
      <td><%=t.getReturnDate()%></td>
      <td><%= t.getFineAmount() > 0 ? "Rs. " + t.getFineAmount() : "No fine" %></td>
    </tr>
  <% } %>
  </tbody>
</table>
</div>
<% } %>

<jsp:include page="footer.jsp" />
