<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.libvault.model.Transaction" %>
<%-- FILE: WebContent/admin/transactions.jsp --%>
<jsp:include page="../header.jsp" />
<%
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
%>
<h3 class="mb-3"><i class="bi bi-arrow-left-right"></i> All Transactions</h3>

<div class="table-responsive">
<table class="table table-bordered table-hover bg-white">
  <thead class="table-light">
    <tr><th>ID</th><th>Book</th><th>Member</th><th>Issue Date</th><th>Due Date</th><th>Return Date</th><th>Status</th><th>Fine</th><th>Actions</th></tr>
  </thead>
  <tbody>
  <% if (transactions != null) for (Transaction t : transactions) { %>
    <tr>
      <td>#<%=t.getTxnId()%></td>
      <td><%=t.getBookTitle()%></td>
      <td><%=t.getUserName()%></td>
      <td><%=t.getIssueDate()%></td>
      <td><%=t.getDueDate()%></td>
      <td><%=t.getReturnDate()==null?"-":t.getReturnDate()%></td>
      <td>
        <% if ("RETURNED".equals(t.getStatus())) { %>
          <span class="badge badge-status-returned">Returned</span>
        <% } else if (t.isOverdue()) { %>
          <span class="badge badge-status-overdue">Overdue</span>
        <% } else { %>
          <span class="badge badge-status-issued">Issued</span>
        <% } %>
      </td>
      <td><%= t.getFineAmount() > 0 ? "Rs. " + t.getFineAmount() : "-" %></td>
      <td>
        <% if ("ISSUED".equals(t.getStatus())) { %>
          <a href="<%=request.getContextPath()%>/admin?action=return&txnId=<%=t.getTxnId()%>&bookId=<%=t.getBookId()%>" class="btn btn-sm btn-outline-primary">Return</a>
          <a href="<%=request.getContextPath()%>/admin?action=renew&txnId=<%=t.getTxnId()%>" class="btn btn-sm btn-outline-secondary">Renew</a>
        <% } %>
      </td>
    </tr>
  <% } %>
  </tbody>
</table>
</div>

<jsp:include page="../footer.jsp" />
