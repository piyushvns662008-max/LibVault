<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.libvault.model.Transaction" %>
<%-- FILE: WebContent/admin/fines.jsp --%>
<jsp:include page="../header.jsp" />
<%
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
%>
<h3 class="mb-3"><i class="bi bi-cash-coin"></i> Manage Fines</h3>

<div class="table-responsive">
<table class="table table-bordered table-hover bg-white">
  <thead class="table-light">
    <tr><th>ID</th><th>Book</th><th>Member</th><th>Fine Amount</th><th>Status</th><th>Action</th></tr>
  </thead>
  <tbody>
  <% if (transactions != null) for (Transaction t : transactions) {
        if (t.getFineAmount() <= 0) continue;
  %>
    <tr>
      <td>#<%=t.getTxnId()%></td>
      <td><%=t.getBookTitle()%></td>
      <td><%=t.getUserName()%></td>
      <td>Rs. <%=t.getFineAmount()%></td>
      <td>
        <% if (t.isFinePaid()) { %>
          <span class="badge bg-success">Paid</span>
        <% } else { %>
          <span class="badge bg-danger">Unpaid</span>
        <% } %>
      </td>
      <td>
        <% if (!t.isFinePaid()) { %>
          <a href="<%=request.getContextPath()%>/admin?action=payFine&txnId=<%=t.getTxnId()%>" class="btn btn-sm btn-outline-success">Mark as Paid</a>
        <% } %>
      </td>
    </tr>
  <% } %>
  </tbody>
</table>
</div>

<jsp:include page="../footer.jsp" />
