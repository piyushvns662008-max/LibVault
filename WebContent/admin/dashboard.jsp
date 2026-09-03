<%@ page contentType="text/html;charset=UTF-8" %>
<%-- FILE: WebContent/admin/dashboard.jsp --%>
<jsp:include page="../header.jsp" />

<div class="section-heading">
  <h3><i class="bi bi-speedometer2"></i> Admin Dashboard</h3>
  <p class="text-muted mb-0">Today's snapshot of the library's circulation desk.</p>
</div>

<div class="ledger mb-4">
  <div class="row g-0 text-center">
    <div class="col ledger-item">
      <div class="value"><%=request.getAttribute("totalBooks")%></div>
      <div class="label">Total Books</div>
    </div>
    <div class="col ledger-item">
      <div class="value"><%=request.getAttribute("availableBooks")%></div>
      <div class="label">Available</div>
    </div>
    <div class="col ledger-item">
      <div class="value"><%=request.getAttribute("issuedBooks")%></div>
      <div class="label">Issued</div>
    </div>
    <div class="col ledger-item">
      <div class="value"><%=request.getAttribute("totalMembers")%></div>
      <div class="label">Members</div>
    </div>
    <div class="col ledger-item">
      <div class="value"><%=request.getAttribute("overdueBooks")%></div>
      <div class="label">Overdue</div>
    </div>
    <div class="col ledger-item">
      <div class="value">Rs. <%=request.getAttribute("totalFines")%></div>
      <div class="label">Fines Collected</div>
    </div>
  </div>
</div>

<h5 class="mb-3">Quick actions</h5>
<div class="row g-3">
  <div class="col-md-4 col-sm-6">
    <a href="<%=request.getContextPath()%>/admin?action=books" class="admin-action"><i class="bi bi-book"></i> Manage Books</a>
  </div>
  <div class="col-md-4 col-sm-6">
    <a href="<%=request.getContextPath()%>/admin?action=users" class="admin-action"><i class="bi bi-people"></i> Manage Members</a>
  </div>
  <div class="col-md-4 col-sm-6">
    <a href="<%=request.getContextPath()%>/admin?action=issue" class="admin-action"><i class="bi bi-journal-plus"></i> Issue a Book</a>
  </div>
  <div class="col-md-4 col-sm-6">
    <a href="<%=request.getContextPath()%>/admin?action=transactions" class="admin-action"><i class="bi bi-arrow-left-right"></i> Transactions</a>
  </div>
  <div class="col-md-4 col-sm-6">
    <a href="<%=request.getContextPath()%>/admin?action=fines" class="admin-action"><i class="bi bi-cash-coin"></i> Manage Fines</a>
  </div>
</div>

<jsp:include page="../footer.jsp" />
