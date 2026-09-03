<%@ page contentType="text/html;charset=UTF-8" %>
<%-- FILE: WebContent/index.jsp --%>
<jsp:include page="header.jsp" />

<div class="hero-catalog">
  <div class="container">
    <div class="row align-items-center">
      <div class="col-lg-7">
        <h1>Find your next book, borrow it in a minute.</h1>
        <p class="lead">LibVault keeps the whole catalog, your loans, due dates and fines in one
           place - so checking a book out is as easy as searching for it.</p>

        <form action="<%=request.getContextPath()%>/book" method="get" class="catalog-search">
          <input type="hidden" name="action" value="list">
          <div class="row g-2">
            <div class="col-8">
              <input type="text" name="keyword" class="form-control" placeholder="Search by title, author or ISBN">
            </div>
            <div class="col-4">
              <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i> Search</button>
            </div>
          </div>
        </form>
      </div>
      <div class="col-lg-5 d-none d-lg-block">
        <div class="book-shelf">
          <div class="spine"></div><div class="spine"></div><div class="spine"></div><div class="spine"></div>
          <div class="spine"></div><div class="spine"></div><div class="spine"></div><div class="spine"></div>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="container my-5">
  <div class="row g-4">
    <div class="col-md-4 feature-tile">
      <div class="icon-box"><i class="bi bi-collection"></i></div>
      <h4>Full catalog, always current</h4>
      <p>Browse every title with real-time availability, so you never make a trip for a book that's already out.</p>
    </div>
    <div class="col-md-4 feature-tile">
      <div class="icon-box"><i class="bi bi-arrow-repeat"></i></div>
      <h4>Borrow, renew, return online</h4>
      <p>Check a book out in one click, renew it if you need more time, and see exactly when it's due.</p>
    </div>
    <div class="col-md-4 feature-tile">
      <div class="icon-box"><i class="bi bi-envelope-check"></i></div>
      <h4>Stays in touch</h4>
      <p>Get an email the moment you borrow or return a book, so nothing slips past a due date.</p>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
