<!-- Header Panel -->
<header>
    <form action="AdminHome.jsp" id="HomeBtn"> <button type="submit" name="btHome"> <i class='fas fa-house-user'></i> </button> </form>
    <span id="greeting">Hi ${applicationScope.session_admin}</span>
    <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>
    <form action="../LogoutPage.jsp" id="LogoutBtn"> <input type="submit" name="btLogout" value="logout"> </form>
</header>